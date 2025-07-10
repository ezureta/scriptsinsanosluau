-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Remotes
local DamageIncreaseOnClickEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("DamageIncreaseOnClickEvent")
local ClickedDuringRace = ReplicatedStorage:WaitForChild("Events"):WaitForChild("RaceEvents"):WaitForChild("ClickedDuringRace")

-- Load the DrRay library from the GitHub repository Library
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()

-- Verificar que la librería se cargó correctamente
if not DrRayLibrary then
    print("Error: No se pudo cargar la librería DrRay")
    return
end

-- Create a new window and set its title and theme
local window = DrRayLibrary:Load("Strength Simulator", "Default")

-- Verificar que la ventana se creó correctamente
if not window then
    print("Error: No se pudo crear la ventana")
    return
end

-- Variables
local isSpammingStrength = false
local isSpammingRace = false
local strengthSpeed = 0.001
local raceSpeed = 0.001
local strengthThreads = 5
local raceThreads = 5

-- Variables para estadísticas
local statsEnabled = false
local clickCount = 0
local startTime = 0

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

-- Función para mostrar estadísticas
local function startStats()
    statsEnabled = true
    clickCount = 0
    startTime = tick()
    
    task.spawn(function()
        while statsEnabled and (isSpammingStrength or isSpammingRace) do
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

-- Create the main tab
local mainTab = window:AddTab("Main", "rbxassetid://0")

-- Verificar que el tab se creó correctamente
if not mainTab then
    print("Error: No se pudo crear el tab principal")
    return
end

-- Add elements to the main tab
mainTab.newLabel("Strength Simulator - Auto Click Spam")
mainTab.newLabel("Activa los toggles para hacer spam automático.")

-- Toggle para Strength Spam
mainTab.newToggle("Strength Spam", "Activa/desactiva el spam de fuerza", false, function(toggleState)
    if toggleState then
        isSpammingStrength = true
        startStrengthSpam()
        print("Strength Spam ACTIVADO")
    else
        isSpammingStrength = false
        print("Strength Spam DESACTIVADO")
    end
end)

-- Toggle para Race Spam
mainTab.newToggle("Race Spam", "Activa/desactiva el spam de carrera", false, function(toggleState)
    if toggleState then
        isSpammingRace = true
        startRaceSpam()
        print("Race Spam ACTIVADO")
    else
        isSpammingRace = false
        print("Race Spam DESACTIVADO")
    end
end)

-- Botón manual para Strength
mainTab.newButton("Click Manual Strength", "Hacer un click manual de fuerza", function()
    DamageIncreaseOnClickEvent:FireServer()
    print("Click manual de fuerza enviado")
end)

-- Botón manual para Race
mainTab.newButton("Click Manual Race", "Hacer un click manual de carrera", function()
    ClickedDuringRace:FireServer()
    print("Click manual de carrera enviado")
end)

-- Input para velocidad Strength
mainTab.newInput("Velocidad Strength", "Ajusta la velocidad (0.0001 - 0.01)", function(text)
    local newSpeed = tonumber(text)
    if newSpeed and newSpeed >= 0.0001 and newSpeed <= 0.01 then
        strengthSpeed = newSpeed
        print("Velocidad Strength actualizada: " .. newSpeed)
    else
        print("Velocidad inválida. Usa un número entre 0.0001 y 0.01")
    end
end)

-- Input para velocidad Race
mainTab.newInput("Velocidad Race", "Ajusta la velocidad (0.0001 - 0.01)", function(text)
    local newSpeed = tonumber(text)
    if newSpeed and newSpeed >= 0.0001 and newSpeed <= 0.01 then
        raceSpeed = newSpeed
        print("Velocidad Race actualizada: " .. newSpeed)
    else
        print("Velocidad inválida. Usa un número entre 0.0001 y 0.01")
    end
end)

-- Input para threads Strength
mainTab.newInput("Threads Strength", "Número de threads (1-10)", function(text)
    local newThreads = tonumber(text)
    if newThreads and newThreads >= 1 and newThreads <= 10 then
        strengthThreads = newThreads
        print("Threads Strength actualizados: " .. newThreads)
    else
        print("Threads inválidos. Usa un número entre 1 y 10")
    end
end)

-- Input para threads Race
mainTab.newInput("Threads Race", "Número de threads (1-10)", function(text)
    local newThreads = tonumber(text)
    if newThreads and newThreads >= 1 and newThreads <= 10 then
        raceThreads = newThreads
        print("Threads Race actualizados: " .. newThreads)
    else
        print("Threads inválidos. Usa un número entre 1 y 10")
    end
end)

-- Dropdown para presets de velocidad
mainTab.newDropdown("Presets de Velocidad", "Selecciona una velocidad predefinida", {
    "Ultra Rápido (0.0001)",
    "Muy Rápido (0.001)", 
    "Rápido (0.005)",
    "Normal (0.01)",
    "Lento (0.05)"
}, function(selectedOption)
    if selectedOption == "Ultra Rápido (0.0001)" then
        strengthSpeed = 0.0001
        raceSpeed = 0.0001
    elseif selectedOption == "Muy Rápido (0.001)" then
        strengthSpeed = 0.001
        raceSpeed = 0.001
    elseif selectedOption == "Rápido (0.005)" then
        strengthSpeed = 0.005
        raceSpeed = 0.005
    elseif selectedOption == "Normal (0.01)" then
        strengthSpeed = 0.01
        raceSpeed = 0.01
    elseif selectedOption == "Lento (0.05)" then
        strengthSpeed = 0.05
        raceSpeed = 0.05
    end
    print("Preset aplicado: " .. selectedOption)
end)

-- Create the settings tab
local settingsTab = window:AddTab("Settings", "rbxassetid://0")

-- Verificar que el tab de settings se creó correctamente
if not settingsTab then
    print("Error: No se pudo crear el tab de settings")
    return
end

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

-- Contador de clicks
local originalStrengthFireServer = DamageIncreaseOnClickEvent.FireServer
DamageIncreaseOnClickEvent.FireServer = function(self, ...)
    clickCount = clickCount + 1
    return originalStrengthFireServer(self, ...)
end

local originalRaceFireServer = ClickedDuringRace.FireServer
ClickedDuringRace.FireServer = function(self, ...)
    clickCount = clickCount + 1
    return originalRaceFireServer(self, ...)
end

-- Notificación de carga
print("Strength Simulator cargado correctamente!")
print("Usa los toggles para activar/desactivar el spam automático")

-- Cleanup cuando se desmonte el script
game:BindToClose(function()
    isSpammingStrength = false
    isSpammingRace = false
    statsEnabled = false
end)
