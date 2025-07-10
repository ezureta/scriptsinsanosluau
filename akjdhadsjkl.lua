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

-- UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Pinneaple Hub (not obii) - Strength Simulator",
    SubTitle = "made by Ezureta",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Auto Farm", Icon = "flame" }),
    Pets = Window:AddTab({ Title = "Pets", Icon = "paw-print" }),
    Ascend = Window:AddTab({ Title = "Auto Ascend", Icon = "chevrons-up" }),
    Upgrades = Window:AddTab({ Title = "Upgrades", Icon = "trending-up" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "sliders" })
}

local Options = Fluent.Options

-- Real Toggles
do
    Fluent:Notify({
        Title = "Pinneaple Hub",
        Content = "Script loaded - made by Ezureta",
        Duration = 5
    })

    local StrengthToggle = Tabs.Main:AddToggle("StrengthSpam", {
        Title = "Auto Strength (G)",
        Default = false
    })
    StrengthToggle:OnChanged(function(value)
        isSpammingStrength = value
        if value then
            startStrengthSpam()
        end
    end)

    local RaceToggle = Tabs.Main:AddToggle("RaceSpam", {
        Title = "Auto Race (C)",
        Default = false
    })
    RaceToggle:OnChanged(function(value)
        isSpammingRace = value
        if value then
            startRaceSpam()
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
            isSpammingStrength = not isSpammingStrength
            StrengthToggle:SetValue(isSpammingStrength)
        elseif not gameProcessed and input.KeyCode == Enum.KeyCode.C then
            isSpammingRace = not isSpammingRace
            RaceToggle:SetValue(isSpammingRace)
        end
    end)
end

-- Fake UI elements to "fill up"
local function AddFakeControls(tab)
    tab:AddParagraph({ Title = "Info", Content = "Feature under development..." })

    tab:AddToggle("FakeToggle_" .. tab.Title, {
        Title = "Enable " .. tab.Title,
        Default = false,
        Callback = function(val) print(tab.Title .. " toggle:", val) end
    })

    tab:AddSlider("FakeSlider_" .. tab.Title, {
        Title = "Speed Setting",
        Description = "Adjust the automation speed",
        Min = 1,
        Max = 100,
        Default = 50,
        Rounding = 0,
        Callback = function(val) print("Slider changed in " .. tab.Title, val) end
    })

    tab:AddDropdown("FakeDropdown_" .. tab.Title, {
        Title = "Select Mode",
        Values = { "Normal", "Fast", "Extreme" },
        Default = 1,
        Multi = false,
        Callback = function(val) print("Dropdown selected in " .. tab.Title, val) end
    })

    tab:AddInput("FakeInput_" .. tab.Title, {
        Title = "Custom Value",
        Default = "",
        Placeholder = "Enter value...",
        Callback = function(val) print("Input set in " .. tab.Title, val) end
    })

    tab:AddButton({
        Title = "Execute " .. tab.Title,
        Description = "Placeholder button",
        Callback = function() print("Executed", tab.Title) end
    })
end

AddFakeControls(Tabs.Pets)
AddFakeControls(Tabs.Ascend)
AddFakeControls(Tabs.Upgrades)
AddFakeControls(Tabs.Misc)

-- SaveManager setup
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("PinneapleHub")
SaveManager:SetFolder("PinneapleHub/StrengthSimulator")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
