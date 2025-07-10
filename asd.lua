-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Remotes
local DamageIncreaseOnClickEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("DamageIncreaseOnClickEvent")
local ClickedDuringRace = ReplicatedStorage:WaitForChild("Events"):WaitForChild("RaceEvents"):WaitForChild("ClickedDuringRace")

-- Variables
local isSpammingStrength = false
local isSpammingRace = false

-- Spam functions
local function startStrengthSpam()
    task.spawn(function()
        while isSpammingStrength do
            DamageIncreaseOnClickEvent:FireServer()
            task.wait()
        end
    end)
end

local function startRaceSpam()
    task.spawn(function()
        while isSpammingRace do
            ClickedDuringRace:FireServer()
            task.wait()
        end
    end)
end

-- Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Pinneaple Hub (not obii) - Strength Simulator",
    SubTitle = "made by Ezureta :3",
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

do
    Fluent:Notify({
        Title = "Pinneaple Hub",
        Content = "Loaded successfully - made by Ezureta.",
        Duration = 5
    })

    -- Strength Toggle
    local StrengthToggle = Tabs.Main:AddToggle("StrengthSpam", {
        Title = "Auto Strength (G)",
        Default = false
    })
    StrengthToggle:OnChanged(function(value)
        isSpammingStrength = value
        if value then
            startStrengthSpam()
            print("Auto Strength ENABLED via UI")
        else
            print("Auto Strength DISABLED via UI")
        end
    end)

    -- Race Toggle
    local RaceToggle = Tabs.Main:AddToggle("RaceSpam", {
        Title = "Auto Race (C)",
        Default = false
    })
    RaceToggle:OnChanged(function(value)
        isSpammingRace = value
        if value then
            startRaceSpam()
            print("Auto Race ENABLED via UI")
        else
            print("Auto Race DISABLED via UI")
        end
    end)

    -- Optional keybind toggles
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
            isSpammingStrength = not isSpammingStrength
            StrengthToggle:SetValue(isSpammingStrength)
        elseif not gameProcessed and input.KeyCode == Enum.KeyCode.C then
            isSpammingRace = not isSpammingRace
            RaceToggle:SetValue(isSpammingRace)
        end
    end)

    Fluent:Notify({
        Title = "Pinneaple Hub",
        Content = "Toggles loaded (Auto Strength & Auto Race)",
        Duration = 5
    })
end

-- Save system
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("PinneapleHub")
SaveManager:SetFolder("PinneapleHub/StrengthSimulator")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
