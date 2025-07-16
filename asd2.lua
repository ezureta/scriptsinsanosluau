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
        print("Parte encontrada:", canPlant:GetFullName(), "Posición:", tostring(canPlant.Position))
        
        -- Lista de plantas que pueden ser usadas
        local plantas = {
            "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", 
            "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", 
            "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", 
            "Ember Lily", "Sugar Apple", "Burning Bud", "Cauliflower", "Rafflesia", "Green Apple", 
            "Avocado", "Banana", "Pineapple", "Kiwi", "Bell Pepper", "Prickly Pear", "Loquat", 
            "Pitcher Plant", "Feijoa", "Wild Carrot", "Pear", "Cantaloupe", "Parasol Flower", 
            "Rosy Delight", "Elephant Ears", "Delphinium", "Lily of the Valley", "Traveler's Fruit", 
            "Peace Lily", "Aloe Vera", "Guanabana", "Chocolate Carrot", "Red Lollipop", 
            "Blue Lollipop", "Candy Sunflower", "Easter Egg", "Candy Blossom", "Peach", 
            "Raspberry", "Papaya", "Passionfruit", "Soul Fruit", "Cursed Fruit", "Mega Mushroom", 
            "Cherry Blossom", "Purple Cabbage", "Lemon", "Pink Tulip", "Cranberry", "Durian", 
            "Eggplant", "Lotus", "Venus Fly Trap", "Nightshade", "Glowshroom", "Mint", "Moonflower", 
            "Starfruit", "Moonglow", "Moon Blossom", "Crimson Vine", "Moon Melon", "Blood Banana", 
            "Celestiberry", "Moon Mango", "Rose", "Foxglove", "Lilac", "Pink Lily", "Purple Dahlia", 
            "Sunflower", "Lavender", "Nectarshade", "Nectarine", "Hive Fruit", "Manuka Flower", 
            "Dandelion", "Lumira", "Honeysuckle", "Crocus", "Succulent", "Violet Corn", "Bendboo", 
            "Cocovine", "Dragon Pepper", "Bee Balm", "Nectar Thorn", "Suncoil", "Liberty Lily", 
            "Firework Flower", "Stonebite", "Paradise Petal", "Horned Dinoshroom", "Boneboo", 
            "Firefly Fern", "Fossilight", "Bone Blossom", "Horsetail", "Lingonberry", "Amber Spine", 
            "Grand Volcania", "Noble Flower", "Ice Cream Bean", "Lime", "White Mulberry", "Merica Mushroom", 
            "Giant Pinecone", "Taro Flower"
        }

        -- Llamar al evento remoto para cada planta
        for _, planta in ipairs(plantas) do
            local args = {canPlant.Position, planta}

            -- Depuración antes de llamar al evento remoto
            print("Enviando evento para plantar:", planta)
            local success, err = pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Plant_RE"):FireServer(unpack(args))
            end)

            if success then
                print("Evento enviado correctamente para", planta)
            else
                warn("Error al enviar el evento para", planta, "Error:", err)
            end
        end
    else
        warn("No se encontró Can_Plant o no es una parte válida.")
    end
else
    warn("No se encontró tu granja.")
end
