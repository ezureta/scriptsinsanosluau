-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Remotes
local DamageIncreaseOnClickEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("DamageIncreaseOnClickEvent")
local ClickedDuringRace = ReplicatedStorage:WaitForChild("Events"):WaitForChild("RaceEvents"):WaitForChild("ClickedDuringRace")

-- UI Setup
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Strength Simulator",
    SubTitle = "by lofil",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Variables
local isSpammingStrength = false
local isSpammingRace = false
local strengthSpeed = 0.001
local raceSpeed = 0.001
local strengthThreads = 5
local raceThreads = 5

do
    Fluent:Notify({
        Title = "Strength Simulator",
        Content = "Script cargado correctamente",
        Duration = 5
    })

    Tabs.Main:AddParagraph({
        Title = "Strength Simulator",
        Content = "Activa los toggles para hacer spam automático.\nAjusta la velocidad y threads en los sliders."
    })

    -- Toggle para Strength Spam
    local StrengthToggle = Tabs.Main:AddToggle("StrengthToggle", {
        Title = "Strength Spam", 
        Default = false 
    })

    StrengthToggle:OnChanged(function()
        if Options.StrengthToggle.Value then
            isSpammingStrength = true
            startStrengthSpam()
            Fluent:Notify({
                Title = "Strength Spam Activado",
                Content = "Threads: " .. strengthThreads .. " | Velocidad: " .. strengthSpeed,
                Duration = 3
            })
        else
            isSpammingStrength = false
            Fluent:Notify({
                Title = "Strength Spam Desactivado",
                Content = "El spam de fuerza se detuvo",
                Duration = 3
            })
        end
    end)

    -- Toggle para Race Spam
    local RaceToggle = Tabs.Main:AddToggle("RaceToggle", {
        Title = "Race Spam", 
        Default = false 
    })

    RaceToggle:OnChanged(function()
        if Options.RaceToggle.Value then
            isSpammingRace = true
            startRaceSpam()
            Fluent:Notify({
                Title = "Race Spam Activado",
                Content = "Threads: " .. raceThreads .. " | Velocidad: " .. raceSpeed,
                Duration = 3
            })
        else
            isSpammingRace = false
            Fluent:Notify({
                Title = "Race Spam Desactivado",
                Content = "El spam de carrera se detuvo",
                Duration = 3
            })
        end
    end)

    -- Slider para velocidad del Strength Spam
    local StrengthSpeedSlider = Tabs.Main:AddSlider("StrengthSpeedSlider", {
        Title = "Velocidad Strength",
        Description = "Ajusta la velocidad del spam de fuerza",
        Default = 0.001,
        Min = 0.0001,
        Max = 0.01,
        Rounding = 4,
        Callback = function(Value)
            strengthSpeed = Value
            Fluent:Notify({
                Title = "Velocidad Strength Actualizada",
                Content = "Nueva velocidad: " .. Value,
                Duration = 2
            })
        end
    })

    -- Slider para threads del Strength Spam
    local StrengthThreadsSlider = Tabs.Main:AddSlider("StrengthThreadsSlider", {
        Title = "Threads Strength",
        Description = "Número de threads para el spam de fuerza",
        Default = 5,
        Min = 1,
        Max = 10,
        Rounding = 0,
        Callback = function(Value)
            strengthThreads = Value
            Fluent:Notify({
                Title = "Threads Strength Actualizados",
                Content = "Nuevos threads: " .. Value,
                Duration = 2
            })
        end
    })

    -- Slider para velocidad del Race Spam
    local RaceSpeedSlider = Tabs.Main:AddSlider("RaceSpeedSlider", {
        Title = "Velocidad Race",
        Description = "Ajusta la velocidad del spam de carrera",
        Default = 0.001,
        Min = 0.0001,
        Max = 0.01,
        Rounding = 4,
        Callback = function(Value)
            raceSpeed = Value
            Fluent:Notify({
                Title = "Velocidad Race Actualizada",
                Content = "Nueva velocidad: " .. Value,
                Duration = 2
            })
        end
    })

    -- Slider para threads del Race Spam
    local RaceThreadsSlider = Tabs.Main:AddSlider("RaceThreadsSlider", {
        Title = "Threads Race",
        Description = "Número de threads para el spam de carrera",
        Default = 5,
        Min = 1,
        Max = 10,
        Rounding = 0,
        Callback = function(Value)
            raceThreads = Value
            Fluent:Notify({
                Title = "Threads Race Actualizados",
                Content = "Nuevos threads: " .. Value,
                Duration = 2
            })
        end
    })

    -- Botón manual para Strength
    Tabs.Main:AddButton({
        Title = "Click Manual Strength",
        Description = "Hacer un click manual de fuerza",
        Callback = function()
            DamageIncreaseOnClickEvent:FireServer()
            Fluent:Notify({
                Title = "Click Enviado",
                Content = "Se envió un click manual de fuerza",
                Duration = 2
            })
        end
    })

    -- Botón manual para Race
    Tabs.Main:AddButton({
        Title = "Click Manual Race",
        Description = "Hacer un click manual de carrera",
        Callback = function()
            ClickedDuringRace:FireServer()
            Fluent:Notify({
                Title = "Click Enviado",
                Content = "Se envió un click manual de carrera",
                Duration = 2
            })
        end
    })

    -- Dropdown para presets de velocidad
    local SpeedPresetDropdown = Tabs.Main:AddDropdown("SpeedPresetDropdown", {
        Title = "Presets de Velocidad",
        Description = "Selecciona una velocidad predefinida",
        Values = {"Ultra Rápido", "Muy Rápido", "Rápido", "Normal", "Lento"},
        Multi = false,
        Default = 1,
    })

    SpeedPresetDropdown:OnChanged(function(Value)
        if Value == "Ultra Rápido" then
            strengthSpeed = 0.0001
            raceSpeed = 0.0001
        elseif Value == "Muy Rápido" then
            strengthSpeed = 0.001
            raceSpeed = 0.001
        elseif Value == "Rápido" then
            strengthSpeed = 0.005
            raceSpeed = 0.005
        elseif Value == "Normal" then
            strengthSpeed = 0.01
            raceSpeed = 0.01
        elseif Value == "Lento" then
            strengthSpeed = 0.05
            raceSpeed = 0.05
        end
        
        StrengthSpeedSlider:SetValue(strengthSpeed)
        RaceSpeedSlider:SetValue(raceSpeed)
        
        Fluent:Notify({
            Title = "Preset Aplicado",
            Content = "Preset: " .. Value,
            Duration = 3
        })
    end)

    -- Keybind para activar/desactivar Strength
    local StrengthKeybind = Tabs.Main:AddKeybind("StrengthKeybind", {
        Title = "Toggle Strength",
        Mode = "Toggle",
        Default = "G",
        Callback = function(Value)
            if Value then
                StrengthToggle:SetValue(not Options.StrengthToggle.Value)
            end
        end
    })

    -- Keybind para activar/desactivar Race
    local RaceKeybind = Tabs.Main:AddKeybind("RaceKeybind", {
        Title = "Toggle Race",
        Mode = "Toggle",
        Default = "C",
        Callback = function(Value)
            if Value then
                RaceToggle:SetValue(not Options.RaceToggle.Value)
            end
        end
    })

    -- Función de spam ultra rápida para Strength
    local function startStrengthSpam()
        for i = 1, strengthThreads do
            task.spawn(function()
                while isSpammingStrength do
                    DamageIncreaseOnClickEvent:FireServer()
                    task.wait(strengthSpeed)
                end
            end)
        end
    end

    -- Función de spam ultra rápida para Race
    local function startRaceSpam()
        for i = 1, raceThreads do
            task.spawn(function()
                while isSpammingRace do
                    ClickedDuringRace:FireServer()
                    task.wait(raceSpeed)
                end
            end)
        end
    end
end

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("StrengthSimulator")
SaveManager:SetFolder("StrengthSimulator/configs")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Strength Simulator",
    Content = "El script se ha cargado correctamente. Usa G para Strength, C para Race.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

-- Cleanup cuando se desmonte el script
game:BindToClose(function()
    isSpammingStrength = false
    isSpammingRace = false
end)
