local player = game.Players.LocalPlayer

-- Función para encontrar la granja del jugador
local function encontrarMiGranja()
    local raiz = workspace:FindFirstChild("Farm")
    if not raiz then
        warn("No se encontró la raíz de la granja.")
        return nil
    end
    for _, subFarm in ipairs(raiz:GetChildren()) do
        if subFarm.Name == "Farm" and subFarm:FindFirstChild("Important") then
            local data = subFarm.Important:FindFirstChild("Data")
            if data then
                local owner = data:FindFirstChild("Owner")
                if owner and owner:IsA("StringValue") and owner.Value == player.Name then
                    return subFarm
                end
            end
        end
    end
    warn("No se encontró la granja del jugador.")
    return nil
end

-- Obtener la granja del jugador
local miGranja = encontrarMiGranja()

-- Si se encuentra la granja, obtener la posición de Can_Plant
if miGranja then
    local canPlant = miGranja.Important.Plant_Locations:FindFirstChild("Can_Plant")
    if canPlant and canPlant:IsA("BasePart") then
        -- Obtener las dimensiones de la parte Can_Plant
        local partSize = canPlant.Size
        local partPosition = canPlant.Position

        -- Función para generar una posición aleatoria dentro de la parte
        local function generarPosicionAleatoria()
            local randomX = math.random(-partSize.X/2, partSize.X/2)
            local randomY = math.random(-partSize.Y/2, partSize.Y/2)
            local randomZ = math.random(-partSize.Z/2, partSize.Z/2)

            return partPosition + Vector3.new(randomX, randomY, randomZ)
        end

        -- Solo enviar el evento para "Carrot"
        local planta = "Carrot"
        local posAleatoria = generarPosicionAleatoria()
        local args = {posAleatoria, planta}

        -- Enviar el evento
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Plant_RE"):FireServer(unpack(args))
        end)

        if not success then
            warn("Error al enviar el evento para", planta, "Error:", err)
        end
    else
        warn("No se encontró Can_Plant o no es una parte válida.")
    end
else
    warn("No se encontró tu granja.")
end
