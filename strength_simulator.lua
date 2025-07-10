-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Remotes
local DamageIncreaseOnClickEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("DamageIncreaseOnClickEvent")
local ClickedDuringRace = ReplicatedStorage:WaitForChild("Events"):WaitForChild("RaceEvents"):WaitForChild("ClickedDuringRace")

-- UI Setup
local Main = require(game:GetService("ReplicatedStorage"):WaitForChild("Fluent"))

local Window = Main:CreateWindow({
    Title = "Strength Simulator",
    SubTitle = "by lofil",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark"
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "box" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Variables
local isSpammingStrength = false
local isSpammingRace = false
local strengthSpeed = 0.001
local raceSpeed = 0.001
local strengthThreads = 5
local raceThreads = 5

do
    Tabs.Main:AddParagraph({
        Title = "Strength Simulator",
        Content = "Activa los toggles para hacer spam automático.\nAjusta la velocidad y threads en los sliders."
    })

    -- Toggle para Strength Spam
    local StrengthToggle = Tabs.Main:AddToggle("StrengthToggle", {
        Title = "Strength Spam", 
        Default = false 
    })
    
    -- Slider para velocidad del Strength Spam
    local StrengthSpeedSlider = Tabs.Main:AddSlider("StrengthSpeedSlider", {
        Title = "Velocidad Strength",
        Description = "Ajusta la velocidad del spam de fuerza",
        Default = 0.001,
        Min = 0.0001,
        Max = 0.01,
        Rounding = 4
    })

    -- Slider para threads del Strength Spam
    local StrengthThreadsSlider = Tabs.Main:AddSlider("StrengthThreadsSlider", {
        Title = "Threads Strength",
        Description = "Número de threads para el spam de fuerza",
        Default = 5,
        Min = 1,
        Max = 10,
        Rounding = 0
    })

    -- Toggle para Race Spam
    local RaceToggle = Tabs.Main:AddToggle("RaceToggle", {
        Title = "Race Spam", 
        Default = false 
    })
    
    -- Slider para velocidad del Race Spam
    local RaceSpeedSlider = Tabs.Main:AddSlider("RaceSpeedSlider", {
        Title = "Velocidad Race",
        Description = "Ajusta la velocidad del spam de carrera",
        Default = 0.001,
        Min = 0.0001,
        Max = 0.01,
        Rounding = 4
    })

    -- Slider para threads del Race Spam
    local RaceThreadsSlider = Tabs.Main:AddSlider("RaceThreadsSlider", {
        Title = "Threads Race",
        Description = "Número de threads para el spam de carrera",
        Default = 5,
        Min = 1,
        Max = 10,
        Rounding = 0
    })

    -- Botón manual para Strength
    Tabs.Main:AddButton({
        Title = "Click Manual Strength",
        Description = "Hacer un click manual de fuerza",
        Callback = function()
            DamageIncreaseOnClickEvent:FireServer()
            Main:Notify({
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
            Main:Notify({
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

    -- Keybind para activar/desactivar Strength
    local StrengthKeybind = Tabs.Main:AddKeybind("StrengthKeybind", {
        Title = "Toggle Strength",
        Mode = "Toggle",
        Default = "G",
        ChangedCallback = function(New)
            if New then
                StrengthToggle:SetValue(not Main.Options["StrengthToggle"].Value)
            end
        end
    })

    -- Keybind para activar/desactivar Race
    local RaceKeybind = Tabs.Main:AddKeybind("RaceKeybind", {
        Title = "Toggle Race",
        Mode = "Toggle",
        Default = "C",
        ChangedCallback = function(New)
            if New then
                RaceToggle:SetValue(not Main.Options["RaceToggle"].Value)
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

    -- Eventos del Strength Toggle
    StrengthToggle:OnChanged(function()
        if Main.Options["StrengthToggle"].Value then
            isSpammingStrength = true
            startStrengthSpam()
            Main:Notify({
                Title = "Strength Spam Activado",
                Content = "Threads: " .. strengthThreads .. " | Velocidad: " .. strengthSpeed,
                Duration = 3
            })
        else
            isSpammingStrength = false
            Main:Notify({
                Title = "Strength Spam Desactivado",
                Content = "El spam de fuerza se detuvo",
                Duration = 3
            })
        end
    end)

    -- Eventos del Race Toggle
    RaceToggle:OnChanged(function()
        if Main.Options["RaceToggle"].Value then
            isSpammingRace = true
            startRaceSpam()
            Main:Notify({
                Title = "Race Spam Activado",
                Content = "Threads: " .. raceThreads .. " | Velocidad: " .. raceSpeed,
                Duration = 3
            })
        else
            isSpammingRace = false
            Main:Notify({
                Title = "Race Spam Desactivado",
                Content = "El spam de carrera se detuvo",
                Duration = 3
            })
        end
    end)

    -- Eventos de los sliders
    StrengthSpeedSlider:OnChanged(function(Value)
        strengthSpeed = Value
        Main:Notify({
            Title = "Velocidad Strength Actualizada",
            Content = "Nueva velocidad: " .. Value,
            Duration = 2
        })
    end)

    StrengthThreadsSlider:OnChanged(function(Value)
        strengthThreads = Value
        Main:Notify({
            Title = "Threads Strength Actualizados",
            Content = "Nuevos threads: " .. Value,
            Duration = 2
        })
    end)

    RaceSpeedSlider:OnChanged(function(Value)
        raceSpeed = Value
        Main:Notify({
            Title = "Velocidad Race Actualizada",
            Content = "Nueva velocidad: " .. Value,
            Duration = 2
        })
    end)

    RaceThreadsSlider:OnChanged(function(Value)
        raceThreads = Value
        Main:Notify({
            Title = "Threads Race Actualizados",
            Content = "Nuevos threads: " .. Value,
            Duration = 2
        })
    end)

    -- Evento del dropdown de presets
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
        
        Main:Notify({
            Title = "Preset Aplicado",
            Content = "Preset: " .. Value,
            Duration = 3
        })
    end)
end

do
    local InterfaceSection = Tabs.Settings:AddSection("Interface")

    InterfaceSection:AddDropdown("InterfaceTheme", {
        Title = "Theme",
        Description = "Cambia el tema de la interfaz.",
        Values = Main.Themes,
        Default = Main.Theme,
        Callback = function(Value)
            Main:SetTheme(Value)
        end
    })

    if Main.UseAcrylic then
        InterfaceSection:AddToggle("AcrylicToggle", {
            Title = "Acrylic",
            Description = "El fondo borroso requiere calidad gráfica 8+",
            Default = Main.Acrylic,
            Callback = function(Value)
                Main:ToggleAcrylic(Value)
            end
        })
    end

    InterfaceSection:AddToggle("TransparentToggle", {
        Title = "Transparencia",
        Description = "Hace la interfaz transparente.",
        Default = Main.Transparency,
        Callback = function(Value)
            Main:ToggleTransparency(Value)
        end
    })

    InterfaceSection:AddKeybind("MenuKeybind", { Title = "Minimizar Bind", Default = "RightShift" })
    Main.MinimizeKeybind = Main.Options.MenuKeybind 
end

-- Notificación de carga
Main:Notify({
    Title = "Strength Simulator",
    Content = "El script se ha cargado correctamente. Usa G para Strength, C para Race.",
    Duration = 8
})

-- Cleanup cuando se desmonte el script
game:BindToClose(function()
    isSpammingStrength = false
    isSpammingRace = false
end)