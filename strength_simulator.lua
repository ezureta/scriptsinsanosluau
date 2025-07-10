-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Remote
local DamageIncreaseOnClickEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("DamageIncreaseOnClickEvent")

-- Load the DrRay library from the GitHub repository Library
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()

-- Create a new window and set its title and theme
local window = DrRayLibrary:Load("Strength Simulator", "Default")

-- Variables
local isSpamming = false
local spamSpeed = 0.01 -- Velocidad del spam en segundos

-- Create the main tab
local mainTab = DrRayLibrary.newTab("Main", "rbxassetid://0")

-- Add elements to the main tab
mainTab.newLabel("Strength Simulator - Auto Click Spam")
mainTab.newLabel("Activa el toggle para hacer spam automático del click de fuerza.")

-- Toggle para activar/desactivar el spam
mainTab.newToggle("Auto Click Spam", "Activa/desactiva el spam automático", false, function(toggleState)
    if toggleState then
        isSpamming = true
        startSpam()
        print("Spam Activado")
    else
        isSpamming = false
        print("Spam Desactivado")
    end
end)

-- Botón manual para testing
mainTab.newButton("Click Manual", "Hacer un click manual para probar", function()
    DamageIncreaseOnClickEvent:FireServer()
    print("Click manual enviado")
end)

-- Input para ajustar velocidad
mainTab.newInput("Velocidad del Spam", "Ajusta la velocidad (0.001 - 0.1)", function(text)
    local newSpeed = tonumber(text)
    if newSpeed and newSpeed >= 0.001 and newSpeed <= 0.1 then
        spamSpeed = newSpeed
        print("Velocidad actualizada: " .. newSpeed)
    else
        print("Velocidad inválida. Usa un número entre 0.001 y 0.1")
    end
end)

-- Dropdown para presets de velocidad
mainTab.newDropdown("Presets de Velocidad", "Selecciona una velocidad predefinida", {
    "Muy Rápido (0.001)",
    "Rápido (0.005)", 
    "Normal (0.01)",
    "Lento (0.05)",
    "Muy Lento (0.1)"
}, function(selectedOption)
    if selectedOption == "Muy Rápido (0.001)" then
        spamSpeed = 0.001
    elseif selectedOption == "Rápido (0.005)" then
        spamSpeed = 0.005
    elseif selectedOption == "Normal (0.01)" then
        spamSpeed = 0.01
    elseif selectedOption == "Lento (0.05)" then
        spamSpeed = 0.05
    elseif selectedOption == "Muy Lento (0.1)" then
        spamSpeed = 0.1
    end
    print("Preset seleccionado: " .. selectedOption)
end)

-- Create the settings tab
local settingsTab = DrRayLibrary.newTab("Settings", "rbxassetid://0")

-- Add elements to the settings tab
settingsTab.newLabel("Configuración del Simulador")
settingsTab.newLabel("Aquí puedes ajustar configuraciones adicionales.")

-- Toggle para mostrar estadísticas
settingsTab.newToggle("Mostrar Estadísticas", "Muestra clicks por segundo", false, function(toggleState)
    if toggleState then
        print("Estadísticas activadas")
        startStats()
    else
        print("Estadísticas desactivadas")
        stopStats()
    end
end)

-- Input para keybind personalizado
settingsTab.newInput("Keybind Personalizado", "Presiona una tecla para el keybind", function(text)
    print("Keybind configurado: " .. text)
end)

-- Función de spam
local function startSpam()
    task.spawn(function()
        while isSpamming do
            DamageIncreaseOnClickEvent:FireServer()
            task.wait(spamSpeed)
        end
    end)
end

-- Variables para estadísticas
local statsEnabled = false
local clickCount = 0
local startTime = 0

-- Función para mostrar estadísticas
local function startStats()
    statsEnabled = true
    clickCount = 0
    startTime = tick()
    
    task.spawn(function()
        while statsEnabled and isSpamming do
            task.wait(1)
            local elapsed = tick() - startTime
            local clicksPerSecond = clickCount / elapsed
            print("Clicks por segundo: " .. string.format("%.2f", clicksPerSecond))
        end
    end)
end

local function stopStats()
    statsEnabled = false
end

-- Contador de clicks
local originalFireServer = DamageIncreaseOnClickEvent.FireServer
DamageIncreaseOnClickEvent.FireServer = function(self, ...)
    clickCount = clickCount + 1
    return originalFireServer(self, ...)
end

-- Notificación de carga
print("Strength Simulator cargado correctamente!")
print("Usa el toggle para activar/desactivar el spam automático")

-- Cleanup cuando se desmonte el script
game:BindToClose(function()
    isSpamming = false
    statsEnabled = false
end)