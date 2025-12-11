-- EVIL HUB - The Forge Roblox Auto Script
-- Features: Auto Forge, Auto Combat, Auto Farm, Auto Quest, Teleport, Auto Swing, Speed

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Configuration
local config = {
    AutoForge = true,
    AutoCombat = true,
    AutoFarm = true,
    AutoQuest = true,
    AutoSwing = true,
    TeleportEnabled = true,
    WalkSpeed = 50,
    FarmDistance = 50,
    CombatRange = 20,
    ForgeDelay = 2,
    CombatDelay = 0.5,
    FarmDelay = 1,
    SwingDelay = 0.1,
    QuestDelay = 3,
    SelectedStoneType = "All",
    SelectedEnemyType = "All"
}

-- Stone Types for Farming
local stoneTypes = {
    "All",
    "Iron",
    "Copper",
    "Gold",
    "Silver",
    "Diamond",
    "Emerald",
    "Ruby",
    "Crystal",
    "Ore",
    "Rock",
    "Stone",
    "Gem"
}

-- Enemy Types for Combat
local enemyTypes = {
    "All",
    "Goblin",
    "Orc",
    "Troll",
    "Skeleton",
    "Zombie",
    "Demon",
    "Dragon",
    "Bandit",
    "Monster",
    "Enemy",
    "NPC"
}

-- UI Setup with Demonic Red Effects
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EVILHUB"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 550)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Glowing red border with pulsing effect
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(255, 0, 0)
border.Thickness = 3
border.Transparency = 0.3
border.Parent = mainFrame

-- Pulsing glow effect on border
spawn(function()
    while true do
        for i = 0.3, 0.8, 0.05 do
            border.Transparency = i
            wait(0.1)
        end
        for i = 0.8, 0.3, -0.05 do
            border.Transparency = i
            wait(0.1)
        end
    end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
title.Text = "EVIL HUB"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.TextSize = 26
title.Font = Enum.Font.GothamBold
title.TextStrokeTransparency = 0.5
title.TextStrokeColor3 = Color3.fromRGB(139, 0, 0)
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Glowing red border on title
local titleBorder = Instance.new("UIStroke")
titleBorder.Color = Color3.fromRGB(255, 0, 0)
titleBorder.Thickness = 3
titleBorder.Transparency = 0.2
titleBorder.Parent = title

-- Pulsing title glow
spawn(function()
    while true do
        for i = 0.2, 0.6, 0.03 do
            titleBorder.Transparency = i
            wait(0.08)
        end
        for i = 0.6, 0.2, -0.03 do
            titleBorder.Transparency = i
            wait(0.08)
        end
    end
end)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -60)
scrollFrame.Position = UDim2.new(0, 10, 0, 55)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(139, 0, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = scrollFrame

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- Toggle Functions with Evil Hub Red Theme
local function createToggle(name, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 35)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = scrollFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 5)
    toggleCorner.Parent = toggleFrame
    
    -- Red glow border on toggle frame
    local toggleBorder = Instance.new("UIStroke")
    toggleBorder.Color = Color3.fromRGB(139, 0, 0)
    toggleBorder.Thickness = 1.5
    toggleBorder.Transparency = 0.5
    toggleBorder.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 100, 100)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = label
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 60, 0, 25)
    toggleButton.Position = UDim2.new(1, -70, 0.5, 0)
    toggleButton.AnchorPoint = Vector2.new(0, 0.5)
    toggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 139, 0) or Color3.fromRGB(139, 0, 0)
    toggleButton.Text = default and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 12
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = toggleFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = toggleButton
    
    -- Red glow on toggle button
    local buttonBorder = Instance.new("UIStroke")
    buttonBorder.Color = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    buttonBorder.Thickness = 2
    buttonBorder.Transparency = 0.3
    buttonBorder.Parent = toggleButton
    
    toggleButton.MouseButton1Click:Connect(function()
        default = not default
        if default then
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 139, 0)
            buttonBorder.Color = Color3.fromRGB(0, 255, 0)
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
            buttonBorder.Color = Color3.fromRGB(255, 0, 0)
        end
        toggleButton.Text = default and "ON" or "OFF"
        if callback then callback(default) end
    end)
    
    return function() return default end
end

-- Dropdown Function with Red Theme
local function createDropdown(name, options, default, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = scrollFrame
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 5)
    dropdownCorner.Parent = dropdownFrame
    
    -- Red border on dropdown
    local dropdownBorder = Instance.new("UIStroke")
    dropdownBorder.Color = Color3.fromRGB(139, 0, 0)
    dropdownBorder.Thickness = 1.5
    dropdownBorder.Transparency = 0.5
    dropdownBorder.Parent = dropdownFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 100, 100)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdownFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = label
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(0.45, -10, 0, 30)
    dropdownButton.Position = UDim2.new(0.5, 5, 0.5, 0)
    dropdownButton.AnchorPoint = Vector2.new(0, 0.5)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    dropdownButton.Text = default
    dropdownButton.TextColor3 = Color3.fromRGB(255, 150, 150)
    dropdownButton.TextSize = 12
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Parent = dropdownFrame
    
    -- Red border on dropdown button
    local buttonBorder = Instance.new("UIStroke")
    buttonBorder.Color = Color3.fromRGB(255, 0, 0)
    buttonBorder.Thickness = 1.5
    buttonBorder.Transparency = 0.4
    buttonBorder.Parent = dropdownButton
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = dropdownButton
    
    local dropdownOpen = false
    local dropdownList = nil
    
    dropdownButton.MouseButton1Click:Connect(function()
        if dropdownOpen then
            if dropdownList then dropdownList:Destroy() end
            dropdownOpen = false
        else
            dropdownOpen = true
            dropdownList = Instance.new("Frame")
            dropdownList.Size = UDim2.new(0, dropdownButton.AbsoluteSize.X, 0, math.min(#options * 25, 150))
            dropdownList.Position = UDim2.new(0, dropdownButton.AbsolutePosition.X - dropdownFrame.AbsolutePosition.X, 0, 40)
            dropdownList.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
            dropdownList.BorderSizePixel = 0
            dropdownList.Parent = dropdownFrame
            dropdownList.ZIndex = 10
            
            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 5)
            listCorner.Parent = dropdownList
            
            -- Red border on dropdown list
            local listBorder = Instance.new("UIStroke")
            listBorder.Color = Color3.fromRGB(255, 0, 0)
            listBorder.Thickness = 2
            listBorder.Transparency = 0.3
            listBorder.Parent = dropdownList
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 2)
            listLayout.Parent = dropdownList
            
            for _, option in pairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, -10, 0, 23)
                optionButton.Position = UDim2.new(0, 5, 0, 0)
                optionButton.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
                optionButton.Text = option
                optionButton.TextColor3 = Color3.fromRGB(255, 150, 150)
                optionButton.TextSize = 11
                optionButton.Font = Enum.Font.Gotham
                optionButton.Parent = dropdownList
                
                -- Red border on option buttons
                local optionBorder = Instance.new("UIStroke")
                optionBorder.Color = Color3.fromRGB(139, 0, 0)
                optionBorder.Thickness = 1
                optionBorder.Transparency = 0.6
                optionBorder.Parent = optionButton
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, 3)
                optionCorner.Parent = optionButton
                
                optionButton.MouseButton1Click:Connect(function()
                    dropdownButton.Text = option
                    if callback then callback(option) end
                    dropdownList:Destroy()
                    dropdownOpen = false
                end)
            end
        end
    end)
end

-- Slider Function with Red Theme
local function createSlider(name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = scrollFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 5)
    sliderCorner.Parent = sliderFrame
    
    -- Red border on slider frame
    local sliderBorder = Instance.new("UIStroke")
    sliderBorder.Color = Color3.fromRGB(139, 0, 0)
    sliderBorder.Thickness = 1.5
    sliderBorder.Transparency = 0.5
    sliderBorder.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 100, 100)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, -20, 0, 5)
    sliderTrack.Position = UDim2.new(0, 10, 0, 30)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderFrame
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = sliderTrack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill
    
    -- Glowing effect on slider fill
    local fillGlow = Instance.new("UIStroke")
    fillGlow.Color = Color3.fromRGB(255, 100, 100)
    fillGlow.Thickness = 2
    fillGlow.Transparency = 0.5
    fillGlow.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 15, 0, 15)
    sliderButton.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    sliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    sliderButton.Text = ""
    sliderButton.Parent = sliderTrack
    
    -- Red glow on slider button
    local buttonGlow = Instance.new("UIStroke")
    buttonGlow.Color = Color3.fromRGB(255, 150, 150)
    buttonGlow.Thickness = 2
    buttonGlow.Transparency = 0.3
    buttonGlow.Parent = sliderButton
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 7)
    buttonCorner.Parent = sliderButton
    
    local dragging = false
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = sliderTrack.AbsolutePosition.X
            local trackSize = sliderTrack.AbsoluteSize.X
            local relativeX = math.clamp((mousePos.X - trackPos) / trackSize, 0, 1)
            local value = math.floor(min + (max - min) * relativeX)
            
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativeX, 0, 0.5, 0)
            label.Text = name .. ": " .. value
            if callback then callback(value) end
        end
    end)
end

-- Create Toggles
createToggle("Auto Forge", config.AutoForge, function(val) config.AutoForge = val end)
createToggle("Auto Combat", config.AutoCombat, function(val) config.AutoCombat = val end)
createToggle("Auto Farm", config.AutoFarm, function(val) config.AutoFarm = val end)
createToggle("Auto Quest", config.AutoQuest, function(val) config.AutoQuest = val end)
createToggle("Auto Swing", config.AutoSwing, function(val) config.AutoSwing = val end)
createToggle("Teleport", config.TeleportEnabled, function(val) config.TeleportEnabled = val end)

-- Create Dropdowns
createDropdown("Stone Type", stoneTypes, config.SelectedStoneType, function(val) config.SelectedStoneType = val end)
createDropdown("Enemy Type", enemyTypes, config.SelectedEnemyType, function(val) config.SelectedEnemyType = val end)

-- Create Slider
createSlider("Walk Speed", 16, 200, config.WalkSpeed, function(val) 
    config.WalkSpeed = val
    if humanoid then
        humanoid.WalkSpeed = val
    end
end)

-- Teleport Function with Speed
local function teleportToPosition(position)
    if not config.TeleportEnabled then return end
    if humanoidRootPart then
        if config.WalkSpeed > 50 then
            -- Fast teleport
            humanoidRootPart.CFrame = CFrame.new(position)
        else
            -- Normal movement
            if humanoid then
                humanoid:MoveTo(position)
            end
        end
    end
end

-- Find Nearest NPC/Enemy with Type Filter
local function findNearestEnemy()
    local nearest = nil
    local distance = math.huge
    
    for _, npc in pairs(Workspace:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") then
            if npc.Humanoid.Health > 0 and npc ~= character then
                local npcName = npc.Name:lower()
                local matchType = false
                
                if config.SelectedEnemyType == "All" then
                    matchType = true
                else
                    for _, enemyType in pairs(enemyTypes) do
                        if enemyType ~= "All" and string.find(npcName, enemyType:lower()) then
                            if config.SelectedEnemyType == enemyType then
                                matchType = true
                                break
                            end
                        end
                    end
                end
                
                if matchType then
                    local npcPos = npc.HumanoidRootPart.Position
                    local charPos = humanoidRootPart.Position
                    local dist = (npcPos - charPos).Magnitude
                    
                    if dist < distance and dist <= config.CombatRange then
                        distance = dist
                        nearest = npc
                    end
                end
            end
        end
    end
    
    return nearest
end

-- Find Nearest Resource/Farmable with Type Filter
local function findNearestResource()
    local nearest = nil
    local distance = math.huge
    
    local resourceNames = {}
    if config.SelectedStoneType == "All" then
        resourceNames = {"Ore", "Rock", "Crystal", "Gem", "Resource", "Node", "Deposit", "Iron", "Copper", "Gold", "Silver", "Diamond", "Emerald", "Ruby", "Stone"}
    else
        resourceNames = {config.SelectedStoneType}
    end
    
    for _, obj in pairs(Workspace:GetChildren()) do
        for _, name in pairs(resourceNames) do
            local objName = obj.Name:lower()
            if string.find(objName, name:lower()) or obj:FindFirstChild(name) then
                if obj:FindFirstChild("Position") or obj:IsA("BasePart") or obj:GetPrimaryPartCFrame() then
                    local objPos = nil
                    if obj:IsA("BasePart") then
                        objPos = obj.Position
                    elseif obj:FindFirstChild("Position") then
                        objPos = obj.Position.Value
                    elseif obj:GetPrimaryPartCFrame() then
                        objPos = obj:GetPrimaryPartCFrame().Position
                    end
                    
                    if objPos then
                        local charPos = humanoidRootPart.Position
                        local dist = (objPos - charPos).Magnitude
                        
                        if dist < distance and dist <= config.FarmDistance then
                            distance = dist
                            nearest = obj
                        end
                    end
                end
            end
        end
    end
    
    return nearest
end

-- Auto Forge Function
local function autoForge()
    if not config.AutoForge then return end
    
    -- Try to find forge station
    local forge = Workspace:FindFirstChild("Forge") or 
                  Workspace:FindFirstChild("ForgeStation") or
                  Workspace:FindFirstChild("Anvil")
    
    if forge then
        local forgePart = forge:FindFirstChild("Part") or forge:FindFirstChild("BasePart")
        if forgePart then
            local forgePos = forgePart.Position
            local charPos = humanoidRootPart.Position
            local dist = (forgePos - charPos).Magnitude
            
            if dist > 10 then
                teleportToPosition(forgePos)
                wait(0.5)
            end
            
            -- Try to interact with forge
            if ReplicatedStorage:FindFirstChild("ForgeEvent") then
                ReplicatedStorage.ForgeEvent:FireServer()
            elseif ReplicatedStorage:FindFirstChild("RemoteEvent") then
                for _, remote in pairs(ReplicatedStorage:GetChildren()) do
                    if remote:IsA("RemoteEvent") and string.find(remote.Name:lower(), "forge") then
                        remote:FireServer()
                        break
                    end
                end
            end
        end
    end
end

-- Auto Combat Function
local function autoCombat()
    if not config.AutoCombat then return end
    
    local enemy = findNearestEnemy()
    if enemy and enemy:FindFirstChild("HumanoidRootPart") then
        local enemyPos = enemy.HumanoidRootPart.Position
        local charPos = humanoidRootPart.Position
        local dist = (enemyPos - charPos).Magnitude
        
        if dist > 5 then
            teleportToPosition(enemyPos)
            wait(0.3)
        end
        
        -- Try to attack
        if humanoid then
            humanoid:MoveTo(enemyPos)
        end
        
        -- Try to fire combat events
        if ReplicatedStorage:FindFirstChild("CombatEvent") then
            ReplicatedStorage.CombatEvent:FireServer(enemy)
        elseif ReplicatedStorage:FindFirstChild("AttackEvent") then
            ReplicatedStorage.AttackEvent:FireServer(enemy)
        else
            -- Try to find any combat-related remote
            for _, remote in pairs(ReplicatedStorage:GetChildren()) do
                if remote:IsA("RemoteEvent") then
                    local name = remote.Name:lower()
                    if string.find(name, "attack") or string.find(name, "combat") or string.find(name, "hit") then
                        remote:FireServer(enemy)
                        break
                    end
                end
            end
        end
    end
end

-- Auto Farm Function
local function autoFarm()
    if not config.AutoFarm then return end
    
    local resource = findNearestResource()
    if resource then
        local resourcePos = nil
        if resource:IsA("BasePart") then
            resourcePos = resource.Position
        elseif resource:FindFirstChild("Position") then
            resourcePos = resource.Position.Value
        elseif resource:GetPrimaryPartCFrame() then
            resourcePos = resource:GetPrimaryPartCFrame().Position
        end
        
        if resourcePos then
            local charPos = humanoidRootPart.Position
            local dist = (resourcePos - charPos).Magnitude
            
            if dist > 5 then
                teleportToPosition(resourcePos)
                wait(0.3)
            end
            
            -- Try to mine/farm
            if ReplicatedStorage:FindFirstChild("MineEvent") then
                ReplicatedStorage.MineEvent:FireServer(resource)
            elseif ReplicatedStorage:FindFirstChild("FarmEvent") then
                ReplicatedStorage.FarmEvent:FireServer(resource)
            else
                for _, remote in pairs(ReplicatedStorage:GetChildren()) do
                    if remote:IsA("RemoteEvent") then
                        local name = remote.Name:lower()
                        if string.find(name, "mine") or string.find(name, "farm") or string.find(name, "collect") then
                            remote:FireServer(resource)
                            break
                        end
                    end
                end
            end
        end
    end
end

-- Auto Quest Function
local function autoQuest()
    if not config.AutoQuest then return end
    
    -- Find quest NPCs or quest objects
    local questNPCs = {}
    for _, npc in pairs(Workspace:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") then
            local npcName = npc.Name:lower()
            if string.find(npcName, "quest") or string.find(npcName, "npc") or npc:FindFirstChild("Quest") then
                table.insert(questNPCs, npc)
            end
        end
    end
    
    -- Try to accept/complete quests
    if ReplicatedStorage:FindFirstChild("QuestEvent") then
        ReplicatedStorage.QuestEvent:FireServer("Accept")
    elseif ReplicatedStorage:FindFirstChild("AcceptQuest") then
        ReplicatedStorage.AcceptQuest:FireServer()
    else
        for _, remote in pairs(ReplicatedStorage:GetChildren()) do
            if remote:IsA("RemoteEvent") then
                local name = remote.Name:lower()
                if string.find(name, "quest") then
                    remote:FireServer("Accept")
                    break
                end
            end
        end
    end
    
    -- Try to complete quests
    if ReplicatedStorage:FindFirstChild("CompleteQuest") then
        ReplicatedStorage.CompleteQuest:FireServer()
    end
end

-- Auto Swing Function
local function autoSwing()
    if not config.AutoSwing then return end
    
    -- Try to swing/attack
    if ReplicatedStorage:FindFirstChild("SwingEvent") then
        ReplicatedStorage.SwingEvent:FireServer()
    elseif ReplicatedStorage:FindFirstChild("Attack") then
        ReplicatedStorage.Attack:FireServer()
    else
        for _, remote in pairs(ReplicatedStorage:GetChildren()) do
            if remote:IsA("RemoteEvent") then
                local name = remote.Name:lower()
                if string.find(name, "swing") or string.find(name, "attack") or string.find(name, "hit") then
                    remote:FireServer()
                    break
                end
            end
        end
    end
    
    -- Also try to use tool if equipped
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
    end
end

-- Main Loop
local lastForge = 0
local lastCombat = 0
local lastFarm = 0
local lastQuest = 0
local lastSwing = 0

RunService.Heartbeat:Connect(function()
    local currentTime = tick()
    
    -- Update Walk Speed
    if humanoid and humanoid.WalkSpeed ~= config.WalkSpeed then
        humanoid.WalkSpeed = config.WalkSpeed
    end
    
    -- Auto Forge
    if config.AutoForge and currentTime - lastForge >= config.ForgeDelay then
        autoForge()
        lastForge = currentTime
    end
    
    -- Auto Combat
    if config.AutoCombat and currentTime - lastCombat >= config.CombatDelay then
        autoCombat()
        lastCombat = currentTime
    end
    
    -- Auto Farm
    if config.AutoFarm and currentTime - lastFarm >= config.FarmDelay then
        autoFarm()
        lastFarm = currentTime
    end
    
    -- Auto Quest
    if config.AutoQuest and currentTime - lastQuest >= config.QuestDelay then
        autoQuest()
        lastQuest = currentTime
    end
    
    -- Auto Swing
    if config.AutoSwing and currentTime - lastSwing >= config.SwingDelay then
        autoSwing()
        lastSwing = currentTime
    end
end)

-- Character Respawn Handler
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = config.WalkSpeed
    end
end)

print("EVIL HUB - The Forge Bot Loaded Successfully!")
print("Features: Auto Forge, Auto Combat, Auto Farm, Auto Quest, Auto Swing, Teleport, Speed")

