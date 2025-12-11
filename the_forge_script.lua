-- ============================================
-- THE FORGE ROBLOX - Advanced Auto Script
-- Version: 2.0
-- Features: Auto Forge, Auto Combat, Auto Farm, Auto Quest, Auto Swing, Teleport, Speed, Auto Collect, Anti-AFK
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

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
    AutoCollect = true,
    AutoRepair = false,
    AutoUpgrade = false,
    TeleportEnabled = true,
    AntiAFK = true,
    AntiKick = true,
    NoClip = false,
    FlyEnabled = false,
    WalkSpeed = 50,
    JumpPower = 50,
    FarmDistance = 100,
    CombatRange = 50,
    CollectDistance = 30,
    ForgeDelay = 2,
    CombatDelay = 0.5,
    FarmDelay = 1,
    SwingDelay = 0.1,
    QuestDelay = 3,
    CollectDelay = 0.5,
    SelectedStoneType = "All",
    SelectedEnemyType = "All",
    SelectedMap = "All",
    SelectedWeapon = "All",
    SelectedResource = "All"
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
    "Gem",
    "Mithril",
    "Platinum",
    "Titanium"
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
    "NPC",
    "Boss",
    "Guard",
    "Knight"
}

-- Map Selection
local mapTypes = {
    "All",
    "Map 1",
    "Map 2",
    "Spawn",
    "Forest",
    "Cave",
    "Dungeon",
    "Boss Area"
}

-- Weapon Types for Combat
local weaponTypes = {
    "All",
    "Skeleton Axe",
    "Iron Sword",
    "Steel Sword",
    "Diamond Sword",
    "Mithril Sword",
    "Axe",
    "Sword",
    "Hammer",
    "Mace",
    "Spear",
    "Bow",
    "Staff",
    "Dagger",
    "Greatsword"
}

-- Resource Types for Farming (More Specific)
local resourceTypes = {
    "All",
    "Iron Ore",
    "Copper Ore",
    "Gold Ore",
    "Silver Ore",
    "Diamond Ore",
    "Emerald Ore",
    "Ruby Ore",
    "Mithril Ore",
    "Platinum Ore",
    "Titanium Ore",
    "Crystal",
    "Gem",
    "Stone",
    "Rock",
    "Coal",
    "Wood",
    "Herb"
}

-- UI Setup with Evil Hub Theme
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EvilHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- UI State
local uiVisible = false
local uiMinimized = false
local originalSize = UDim2.new(0, 380, 0, 600)
local minimizedSize = UDim2.new(0, 380, 0, 50)

-- Calculate center position for main frame
local function getCenterPosition(frameSize)
    local screenSize = workspace.CurrentCamera.ViewportSize
    return UDim2.new(0.5, -frameSize.X.Offset/2, 0.5, -frameSize.Y.Offset/2)
end

-- Floating Menu Button (Bottom Left - Always Visible)
local menuButton = Instance.new("TextButton")
menuButton.Size = UDim2.new(0, 60, 0, 60)
menuButton.Position = UDim2.new(0, 10, 1, -70)
menuButton.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
menuButton.BorderSizePixel = 0
menuButton.Text = "EH"
menuButton.TextColor3 = Color3.fromRGB(255, 0, 0)
menuButton.TextSize = 24
menuButton.Font = Enum.Font.GothamBold
menuButton.TextStrokeTransparency = 0.5
menuButton.TextStrokeColor3 = Color3.fromRGB(139, 0, 0)
menuButton.Parent = screenGui
menuButton.ZIndex = 10

local menuButtonCorner = Instance.new("UICorner")
menuButtonCorner.CornerRadius = UDim.new(0, 10)
menuButtonCorner.Parent = menuButton

-- Glowing red border on menu button
local menuButtonBorder = Instance.new("UIStroke")
menuButtonBorder.Color = Color3.fromRGB(255, 0, 0)
menuButtonBorder.Thickness = 3
menuButtonBorder.Transparency = 0.3
menuButtonBorder.Parent = menuButton

-- Pulsing glow effect on menu button
spawn(function()
    while menuButton.Parent do
        for i = 0.3, 0.8, 0.05 do
            menuButtonBorder.Transparency = i
            wait(0.1)
        end
        for i = 0.8, 0.3, -0.05 do
            menuButtonBorder.Transparency = i
            wait(0.1)
        end
    end
end)

-- Hover effect on menu button
menuButton.MouseEnter:Connect(function()
    menuButton.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
end)

menuButton.MouseLeave:Connect(function()
    menuButton.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
end)

-- Main Frame (Centered)
local mainFrame = Instance.new("Frame")
mainFrame.Size = originalSize
mainFrame.Position = getCenterPosition(originalSize)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = uiVisible
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Animated Red Border
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(255, 0, 0)
border.Thickness = 3
border.Transparency = 0.3
border.Parent = mainFrame

-- Pulsing border effect
spawn(function()
    while mainFrame.Parent do
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

-- Title Bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
title.Text = "🔥 EVIL HUB 🔥"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextStrokeTransparency = 0.5
title.TextStrokeColor3 = Color3.fromRGB(139, 0, 0)
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

local titleBorder = Instance.new("UIStroke")
titleBorder.Color = Color3.fromRGB(255, 0, 0)
titleBorder.Thickness = 3
titleBorder.Transparency = 0.2
titleBorder.Parent = title

-- Pulsing title glow
spawn(function()
    while title.Parent do
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

-- Scroll Frame (Define before minimize button)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -70)
scrollFrame.Position = UDim2.new(0, 10, 0, 60)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.Parent = scrollFrame

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -75, 0, 10)
minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimizeButton.Text = "─"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 18
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = title

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 5)
minimizeCorner.Parent = minimizeButton

minimizeButton.MouseButton1Click:Connect(function()
    uiMinimized = not uiMinimized
    if uiMinimized then
        mainFrame.Size = minimizedSize
        mainFrame.Position = getCenterPosition(minimizedSize)
        scrollFrame.Visible = false
        minimizeButton.Text = "□"
    else
        mainFrame.Size = originalSize
        mainFrame.Position = getCenterPosition(originalSize)
        scrollFrame.Visible = true
        minimizeButton.Text = "─"
    end
end)

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = title

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Toggle UI Visibility Function
local function toggleUI()
    uiVisible = not uiVisible
    if uiVisible then
        mainFrame.Visible = true
        mainFrame.Position = getCenterPosition(uiMinimized and minimizedSize or originalSize)
        menuButton.Text = "EH"
    else
        mainFrame.Visible = false
        menuButton.Text = "EH"
    end
end

-- Menu Button Click to Toggle UI
menuButton.MouseButton1Click:Connect(function()
    toggleUI()
end)

-- Toggle Function
local function createToggle(name, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = scrollFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleFrame
    
    local toggleBorder = Instance.new("UIStroke")
    toggleBorder.Color = Color3.fromRGB(60, 60, 80)
    toggleBorder.Thickness = 1
    toggleBorder.Transparency = 0.5
    toggleBorder.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 15
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 15)
    padding.Parent = label
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 70, 0, 30)
    toggleButton.Position = UDim2.new(1, -80, 0.5, 0)
    toggleButton.AnchorPoint = Vector2.new(0, 0.5)
    toggleButton.BackgroundColor3 = default and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(200, 50, 50)
    toggleButton.Text = default and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 13
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = toggleFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = toggleButton
    
    toggleButton.MouseButton1Click:Connect(function()
        default = not default
        toggleButton.BackgroundColor3 = default and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(200, 50, 50)
        toggleButton.Text = default and "ON" or "OFF"
        if callback then callback(default) end
    end)
    
    return function() return default end
end

-- Dropdown Function
local function createDropdown(name, options, default, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 45)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = scrollFrame
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 8)
    dropdownCorner.Parent = dropdownFrame
    
    local dropdownBorder = Instance.new("UIStroke")
    dropdownBorder.Color = Color3.fromRGB(60, 60, 80)
    dropdownBorder.Thickness = 1
    dropdownBorder.Transparency = 0.5
    dropdownBorder.Parent = dropdownFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdownFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 15)
    padding.Parent = label
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(0.45, -10, 0, 32)
    dropdownButton.Position = UDim2.new(0.5, 5, 0.5, 0)
    dropdownButton.AnchorPoint = Vector2.new(0, 0.5)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    dropdownButton.Text = default
    dropdownButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    dropdownButton.TextSize = 12
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Parent = dropdownFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
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
            dropdownList.Size = UDim2.new(0, dropdownButton.AbsoluteSize.X, 0, math.min(#options * 28, 180))
            dropdownList.Position = UDim2.new(0, dropdownButton.AbsolutePosition.X - dropdownFrame.AbsolutePosition.X, 0, 45)
            dropdownList.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            dropdownList.BorderSizePixel = 0
            dropdownList.Parent = dropdownFrame
            dropdownList.ZIndex = 10
            
            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 6)
            listCorner.Parent = dropdownList
            
            local listBorder = Instance.new("UIStroke")
            listBorder.Color = Color3.fromRGB(255, 0, 0)
            listBorder.Thickness = 2
            listBorder.Transparency = 0.3
            listBorder.Parent = dropdownList
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 3)
            listLayout.Parent = dropdownList
            
            for _, option in pairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, -10, 0, 25)
                optionButton.Position = UDim2.new(0, 5, 0, 0)
                optionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                optionButton.Text = option
                optionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                optionButton.TextSize = 11
                optionButton.Font = Enum.Font.Gotham
                optionButton.Parent = dropdownList
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, 4)
                optionCorner.Parent = optionButton
                
                optionButton.MouseEnter:Connect(function()
                    optionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                end)
                
                optionButton.MouseLeave:Connect(function()
                    optionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                end)
                
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

-- Slider Function
local function createSlider(name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 55)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = scrollFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 8)
    sliderCorner.Parent = sliderFrame
    
    local sliderBorder = Instance.new("UIStroke")
    sliderBorder.Color = Color3.fromRGB(60, 60, 80)
    sliderBorder.Thickness = 1
    sliderBorder.Transparency = 0.5
    sliderBorder.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 22)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, -20, 0, 6)
    sliderTrack.Position = UDim2.new(0, 10, 0, 35)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
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
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 18, 0, 18)
    sliderButton.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    sliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    sliderButton.Text = ""
    sliderButton.Parent = sliderTrack
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 9)
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

-- Create UI Elements
createToggle("Auto Forge", config.AutoForge, function(val) config.AutoForge = val end)
createToggle("Auto Combat", config.AutoCombat, function(val) config.AutoCombat = val end)
createToggle("Auto Farm", config.AutoFarm, function(val) config.AutoFarm = val end)
createToggle("Auto Quest", config.AutoQuest, function(val) config.AutoQuest = val end)
createToggle("Auto Swing", config.AutoSwing, function(val) config.AutoSwing = val end)
createToggle("Auto Collect", config.AutoCollect, function(val) config.AutoCollect = val end)
createToggle("Auto Repair", config.AutoRepair, function(val) config.AutoRepair = val end)
createToggle("Auto Upgrade", config.AutoUpgrade, function(val) config.AutoUpgrade = val end)
createToggle("Teleport", config.TeleportEnabled, function(val) config.TeleportEnabled = val end)
createToggle("Anti-AFK", config.AntiAFK, function(val) config.AntiAFK = val end)
createToggle("Anti Kick", config.AntiKick, function(val) config.AntiKick = val end)
createToggle("NoClip", config.NoClip, function(val) 
    config.NoClip = val
    if val then
        enableNoClip()
    else
        disableNoClip()
    end
end)
createToggle("Fly (Through Walls)", config.FlyEnabled, function(val) 
    config.FlyEnabled = val
    if val then
        enableFly()
    else
        disableFly()
    end
end)

createDropdown("Map Selection", mapTypes, config.SelectedMap, function(val) config.SelectedMap = val end)
createDropdown("Weapon Type", weaponTypes, config.SelectedWeapon, function(val) config.SelectedWeapon = val end)
createDropdown("Stone Type", stoneTypes, config.SelectedStoneType, function(val) config.SelectedStoneType = val end)
createDropdown("Resource Type", resourceTypes, config.SelectedResource, function(val) config.SelectedResource = val end)
createDropdown("Enemy Type", enemyTypes, config.SelectedEnemyType, function(val) config.SelectedEnemyType = val end)

createSlider("Walk Speed", 16, 300, config.WalkSpeed, function(val) 
    config.WalkSpeed = val
    if humanoid then
        humanoid.WalkSpeed = val
    end
end)

createSlider("Jump Power", 50, 200, config.JumpPower, function(val) 
    config.JumpPower = val
    if humanoid then
        humanoid.JumpPower = val
    end
end)

createSlider("Farm Distance", 10, 200, config.FarmDistance, function(val) config.FarmDistance = val end)
createSlider("Combat Range", 10, 100, config.CombatRange, function(val) config.CombatRange = val end)

-- NoClip Function (Make character pass through walls/ground)
local function enableNoClip()
    if not character or not config.NoClip then return end
    
    pcall(function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

local function disableNoClip()
    if not character then return end
    
    pcall(function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end)
end

-- Fly Function (Move through objects)
local flyBodyVelocity = nil
local flyBodyGyro = nil

local function enableFly()
    if not character or not humanoidRootPart or not config.FlyEnabled then return end
    
    pcall(function()
        -- Remove old fly parts if they exist
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
        
        -- Enable noclip
        enableNoClip()
        
        -- Create BodyVelocity for flying
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.Parent = humanoidRootPart
        
        -- Create BodyGyro for stability
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
        flyBodyGyro.P = 1000
        flyBodyGyro.D = 50
        flyBodyGyro.CFrame = humanoidRootPart.CFrame
        flyBodyGyro.Parent = humanoidRootPart
        
        -- Make HumanoidRootPart non-collidable
        humanoidRootPart.CanCollide = false
    end)
end

local function disableFly()
    pcall(function()
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        if flyBodyGyro then
            flyBodyGyro:Destroy()
            flyBodyGyro = nil
        end
        if humanoidRootPart then
            humanoidRootPart.CanCollide = true
        end
        disableNoClip()
    end)
end

-- Teleport Function with NoClip/Fly support
local function teleportToPosition(position, useNoClip)
    if not config.TeleportEnabled or not humanoidRootPart then return end
    
    pcall(function()
        -- Enable noclip/fly if needed for farm/combat to pass through walls/ground
        if useNoClip and (config.NoClip or config.FlyEnabled) then
            if config.FlyEnabled then
                enableFly()
                -- Direct teleport through objects with fly
                if flyBodyVelocity then
                    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            else
                enableNoClip()
            end
            -- Direct teleport (can pass through walls/ground)
            humanoidRootPart.CFrame = CFrame.new(position)
        else
            -- Normal teleport
            if config.WalkSpeed > 50 then
                humanoidRootPart.CFrame = CFrame.new(position)
            else
                if humanoid then
                    humanoid:MoveTo(position)
                end
            end
        end
    end)
end

-- Equip Weapon Function
local function equipWeapon(weaponName)
    if not character or config.SelectedWeapon == "All" then return end
    
    pcall(function()
        -- Check if weapon is already equipped
        local currentTool = character:FindFirstChildOfClass("Tool")
        if currentTool and string.find(currentTool.Name:lower(), weaponName:lower()) then
            return -- Already equipped
        end
        
        -- Search in player's backpack
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local toolName = tool.Name:lower()
                    if string.find(toolName, weaponName:lower()) then
                        -- Equip the weapon
                        tool.Parent = character
                        wait(0.2)
                        break
                    end
                end
            end
        end
        
        -- Also check in StarterGear
        local starterGear = game:GetService("StarterGear"):GetChildren()
        for _, tool in pairs(starterGear) do
            if tool:IsA("Tool") then
                local toolName = tool.Name:lower()
                if string.find(toolName, weaponName:lower()) then
                    local newTool = tool:Clone()
                    newTool.Parent = character
                    wait(0.2)
                    break
                end
            end
        end
    end)
end

-- Check if position is in selected map
local function isInSelectedMap(position)
    if config.SelectedMap == "All" then return true end
    
    local result = false
    pcall(function()
        local mapName = config.SelectedMap:lower()
        
        -- Check workspace for map markers/areas
        for _, obj in pairs(Workspace:GetChildren()) do
            local objName = obj.Name:lower()
            -- Check if object name contains map name
            if string.find(objName, mapName) or string.find(objName, "map") then
                if obj:IsA("BasePart") or obj:IsA("Model") then
                    local objPos = nil
                    if obj:IsA("BasePart") then
                        objPos = obj.Position
                    elseif obj:GetPrimaryPartCFrame() then
                        objPos = obj:GetPrimaryPartCFrame().Position
                    elseif obj:FindFirstChild("HumanoidRootPart") then
                        objPos = obj.HumanoidRootPart.Position
                    end
                    
                    if objPos then
                        local dist = (position - objPos).Magnitude
                        -- Check if within reasonable map area (adjust distance as needed)
                        if dist < 1000 then
                            result = true
                            break
                        end
                    end
                end
            end
        end
        
        -- Also check by position ranges (game-specific, adjust as needed)
        if not result then
            if mapName == "map 1" or mapName == "spawn" then
                -- Map 1 typically at lower Y or specific X/Z range
                if position.Y < 100 or (position.X < 100 and position.Z < 100) then
                    result = true
                end
            elseif mapName == "map 2" then
                -- Map 2 typically at higher Y or different area
                if position.Y >= 100 or (position.X >= 100 or position.Z >= 100) then
                    result = true
                end
            end
        end
    end)
    
    return result
end

-- Find Nearest Enemy
local function findNearestEnemy()
    local nearest = nil
    local distance = math.huge
    
    pcall(function()
        for _, npc in pairs(Workspace:GetChildren()) do
            if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") then
                if npc.Humanoid.Health > 0 and npc ~= character then
                    local npcName = npc.Name:lower()
                    local npcPos = npc.HumanoidRootPart.Position
                    
                    -- Check map filter
                    if isInSelectedMap(npcPos) then
                        -- Check enemy type filter
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
        end
    end)
    
    return nearest
end

-- Find Nearest Resource
local function findNearestResource()
    local nearest = nil
    local distance = math.huge
    
    -- Use SelectedResource if specified, otherwise use SelectedStoneType
    local resourceNames = {}
    if config.SelectedResource ~= "All" then
        -- Use specific resource type
        resourceNames = {config.SelectedResource}
    elseif config.SelectedStoneType ~= "All" then
        resourceNames = {config.SelectedStoneType}
    else
        -- All resources
        resourceNames = {"Ore", "Rock", "Crystal", "Gem", "Resource", "Node", "Deposit", "Iron", "Copper", "Gold", "Silver", "Diamond", "Emerald", "Ruby", "Stone", "Mithril", "Platinum", "Titanium", "Coal", "Wood", "Herb"}
    end
    
    pcall(function()
        -- Search in all descendants for better coverage
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local objName = obj.Name:lower()
                local objPos = nil
                
                -- Get position
                if obj:IsA("BasePart") then
                    objPos = obj.Position
                elseif obj:FindFirstChild("Position") then
                    objPos = obj.Position.Value
                elseif obj:GetPrimaryPartCFrame() then
                    objPos = obj:GetPrimaryPartCFrame().Position
                elseif obj:FindFirstChild("HumanoidRootPart") then
                    objPos = obj.HumanoidRootPart.Position
                end
                
                if objPos then
                    -- Check map filter
                    if isInSelectedMap(objPos) then
                        -- Check if matches resource name
                        local matchesResource = false
                        for _, name in pairs(resourceNames) do
                            local nameLower = name:lower()
                            if string.find(objName, nameLower) or obj:FindFirstChild(name) then
                                matchesResource = true
                                break
                            end
                        end
                        
                        if matchesResource then
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
    end)
    
    return nearest
end

-- Find Collectible Items (Optimized for The Forge Beta - Runes, Coins, Items)
local function findNearestCollectible()
    local nearest = nil
    local distance = math.huge
    
    pcall(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local objName = obj.Name:lower()
                local objPos = nil
                
                -- Get position
                if obj:IsA("BasePart") then
                    objPos = obj.Position
                elseif obj:GetPrimaryPartCFrame() then
                    objPos = obj:GetPrimaryPartCFrame().Position
                elseif obj:FindFirstChild("HumanoidRootPart") then
                    objPos = obj.HumanoidRootPart.Position
                end
                
                if objPos then
                    -- The Forge Beta collectibles: Runes, Coins, Items, Drops
                    if string.find(objName, "rune") or string.find(objName, "coin") or string.find(objName, "item") or 
                       string.find(objName, "drop") or string.find(objName, "gold") or string.find(objName, "gem") or
                       obj:FindFirstChild("ProximityPrompt") or obj:FindFirstChild("ClickDetector") then
                        local charPos = humanoidRootPart.Position
                        local dist = (objPos - charPos).Magnitude
                        
                        if dist < distance and dist <= config.CollectDistance then
                            distance = dist
                            nearest = obj
                        end
                    end
                end
            end
        end
    end)
    
    return nearest
end

-- Auto Detect Remote Events for The Forge Beta
local detectedEvents = {
    ForgeEvent = nil,
    CombatEvent = nil,
    FarmEvent = nil,
    QuestEvent = nil,
    SwingEvent = nil
}

local function detectRemoteEvents()
    pcall(function()
        -- Search in ReplicatedStorage
        for _, child in pairs(ReplicatedStorage:GetDescendants()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local name = child.Name:lower()
                
                -- Detect Forge events
                if string.find(name, "forge") or string.find(name, "craft") or string.find(name, "smith") or string.find(name, "anvil") then
                    detectedEvents.ForgeEvent = child
                end
                
                -- Detect Combat events
                if string.find(name, "attack") or string.find(name, "combat") or string.find(name, "hit") or string.find(name, "damage") or string.find(name, "fight") then
                    detectedEvents.CombatEvent = child
                end
                
                -- Detect Farm/Mine events
                if string.find(name, "mine") or string.find(name, "farm") or string.find(name, "harvest") or string.find(name, "collect") or string.find(name, "ore") then
                    detectedEvents.FarmEvent = child
                end
                
                -- Detect Quest events
                if string.find(name, "quest") or string.find(name, "mission") or string.find(name, "task") then
                    detectedEvents.QuestEvent = child
                end
                
                -- Detect Swing events
                if string.find(name, "swing") or string.find(name, "use") or string.find(name, "activate") then
                    detectedEvents.SwingEvent = child
                end
            end
        end
        
        -- Print detected events
        print("=== THE FORGE BETA - Detected Remote Events ===")
        for eventType, event in pairs(detectedEvents) do
            if event then
                print("✓ " .. eventType .. ": " .. event.Name .. " (" .. event.ClassName .. ")")
            else
                print("✗ " .. eventType .. ": Not found")
            end
        end
        print("=============================================")
    end)
end

-- Auto Detect on load
spawn(function()
    wait(3) -- Wait for game to fully load
    detectRemoteEvents()
end)

-- Auto Forge (Optimized for The Forge Beta)
local function autoForge()
    if not config.AutoForge then return end
    
    pcall(function()
        -- Find forge station
        local forge = nil
        for _, obj in pairs(Workspace:GetDescendants()) do
            local objName = obj.Name:lower()
            if string.find(objName, "forge") or string.find(objName, "anvil") or string.find(objName, "craft") or string.find(objName, "smith") then
                if obj:IsA("Model") or obj:IsA("BasePart") then
                    forge = obj
                    break
                end
            end
        end
        
        if forge then
            local forgePart = nil
            if forge:IsA("BasePart") then
                forgePart = forge
            else
                forgePart = forge:FindFirstChild("Part") or forge:FindFirstChild("BasePart") or forge:FindFirstChild("HumanoidRootPart") or forge:GetPrimaryPartCFrame() and forge
            end
            
            if forgePart then
                local forgePos = nil
                if forgePart:IsA("BasePart") then
                    forgePos = forgePart.Position
                elseif forgePart:GetPrimaryPartCFrame() then
                    forgePos = forgePart:GetPrimaryPartCFrame().Position
                end
                
                if forgePos then
                    local charPos = humanoidRootPart.Position
                    local dist = (forgePos - charPos).Magnitude
                    
                    if dist > 10 then
                        teleportToPosition(forgePos)
                        wait(0.5)
                    end
                    
                    -- Use detected event or try common patterns
                    if detectedEvents.ForgeEvent then
                        if detectedEvents.ForgeEvent:IsA("RemoteEvent") then
                            detectedEvents.ForgeEvent:FireServer()
                        elseif detectedEvents.ForgeEvent:IsA("RemoteFunction") then
                            detectedEvents.ForgeEvent:InvokeServer()
                        end
                    else
                        -- Fallback: Try common patterns
                        local forgeEvents = {"ForgeEvent", "Forge", "Craft", "Smith", "Create", "Anvil"}
                        for _, eventName in pairs(forgeEvents) do
                            local event = ReplicatedStorage:FindFirstChild(eventName)
                            if event then
                                if event:IsA("RemoteEvent") then
                                    event:FireServer()
                                elseif event:IsA("RemoteFunction") then
                                    event:InvokeServer()
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- Auto Combat (Optimized for The Forge Beta)
local function autoCombat()
    if not config.AutoCombat then return end
    
    pcall(function()
        local enemy = findNearestEnemy()
        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
            -- Equip selected weapon before combat
            if config.SelectedWeapon ~= "All" then
                equipWeapon(config.SelectedWeapon)
                wait(0.1)
            end
            
            local enemyPos = enemy.HumanoidRootPart.Position
            local charPos = humanoidRootPart.Position
            local dist = (enemyPos - charPos).Magnitude
            
            if dist > 5 then
                teleportToPosition(enemyPos, true) -- Use NoClip/Fly for combat
                wait(0.2)
            end
            
            if humanoid then
                humanoid:MoveTo(enemyPos)
            end
            
            -- Activate equipped tool/weapon (The Forge Beta uses tool activation)
            if character then
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    -- Try multiple activation methods
                    tool:Activate()
                    -- Also try clicking if tool has ClickDetector
                    local clickDetector = tool:FindFirstChild("ClickDetector")
                    if clickDetector then
                        fireclickdetector(clickDetector)
                    end
                end
            end
            
            -- Use detected event or try common patterns
            if detectedEvents.CombatEvent then
                if detectedEvents.CombatEvent:IsA("RemoteEvent") then
                    detectedEvents.CombatEvent:FireServer(enemy)
                elseif detectedEvents.CombatEvent:IsA("RemoteFunction") then
                    detectedEvents.CombatEvent:InvokeServer(enemy)
                end
            else
                -- Fallback: Try common patterns
                local combatEvents = {"CombatEvent", "AttackEvent", "Attack", "Hit", "Damage", "Swing", "Fight"}
                for _, eventName in pairs(combatEvents) do
                    local event = ReplicatedStorage:FindFirstChild(eventName)
                    if event then
                        if event:IsA("RemoteEvent") then
                            event:FireServer(enemy)
                        elseif event:IsA("RemoteFunction") then
                            event:InvokeServer(enemy)
                        end
                        break
                    end
                end
            end
        end
    end)
end

-- Auto Farm (Optimized for The Forge Beta)
local function autoFarm()
    if not config.AutoFarm then return end
    
    pcall(function()
        local resource = findNearestResource()
        if resource then
            local resourcePos = nil
            if resource:IsA("BasePart") then
                resourcePos = resource.Position
            elseif resource:FindFirstChild("Position") then
                resourcePos = resource.Position.Value
            elseif resource:GetPrimaryPartCFrame() then
                resourcePos = resource:GetPrimaryPartCFrame().Position
            elseif resource:FindFirstChild("HumanoidRootPart") then
                resourcePos = resource.HumanoidRootPart.Position
            end
            
            if resourcePos then
                local charPos = humanoidRootPart.Position
                local dist = (resourcePos - charPos).Magnitude
                
                if dist > 5 then
                    teleportToPosition(resourcePos, true) -- Use NoClip/Fly for farming
                    wait(0.2)
                end
                
                -- The Forge Beta: Try clicking on resource first
                if resource:IsA("BasePart") or resource:IsA("Model") then
                    local clickDetector = resource:FindFirstChild("ClickDetector") or resource:FindFirstDescendant("ClickDetector")
                    if clickDetector then
                        fireclickdetector(clickDetector)
                    end
                    
                    -- Try ProximityPrompt (common in The Forge Beta)
                    local proximityPrompt = resource:FindFirstChild("ProximityPrompt") or resource:FindFirstDescendant("ProximityPrompt")
                    if proximityPrompt and proximityPrompt:IsA("ProximityPrompt") then
                        proximityPrompt:InputHoldBegin()
                        wait(0.1)
                        proximityPrompt:InputHoldEnd()
                    end
                end
                
                -- Use detected event or try common patterns
                if detectedEvents.FarmEvent then
                    if detectedEvents.FarmEvent:IsA("RemoteEvent") then
                        detectedEvents.FarmEvent:FireServer(resource)
                    elseif detectedEvents.FarmEvent:IsA("RemoteFunction") then
                        detectedEvents.FarmEvent:InvokeServer(resource)
                    end
                else
                    -- Fallback: Try common patterns
                    local farmEvents = {"MineEvent", "FarmEvent", "Mine", "Farm", "Collect", "Harvest", "Ore", "Pickaxe"}
                    for _, eventName in pairs(farmEvents) do
                        local event = ReplicatedStorage:FindFirstChild(eventName)
                        if event then
                            if event:IsA("RemoteEvent") then
                                event:FireServer(resource)
                            elseif event:IsA("RemoteFunction") then
                                event:InvokeServer(resource)
                            end
                            break
                        end
                    end
                end
            end
        end
    end)
end

-- Auto Quest (Optimized for The Forge Beta)
local function autoQuest()
    if not config.AutoQuest then return end
    
    pcall(function()
        -- Find quest NPCs (The Forge Beta uses NPCs with ProximityPrompt)
        local questNPCs = {}
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and (npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Head")) then
                local npcName = npc.Name:lower()
                local hasProximityPrompt = npc:FindFirstChild("ProximityPrompt") or npc:FindFirstDescendant("ProximityPrompt")
                
                if string.find(npcName, "quest") or string.find(npcName, "npc") or string.find(npcName, "merchant") or string.find(npcName, "vendor") or npc:FindFirstChild("Quest") or hasProximityPrompt then
                    table.insert(questNPCs, npc)
                end
            end
        end
        
        -- Interact with nearest quest NPC
        if #questNPCs > 0 then
            local nearestNPC = nil
            local nearestDist = math.huge
            
            for _, npc in pairs(questNPCs) do
                local npcPos = nil
                if npc:FindFirstChild("HumanoidRootPart") then
                    npcPos = npc.HumanoidRootPart.Position
                elseif npc:FindFirstChild("Head") then
                    npcPos = npc.Head.Position
                end
                
                if npcPos then
                    local dist = (npcPos - humanoidRootPart.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestNPC = npc
                    end
                end
            end
            
            if nearestNPC and nearestDist < 20 then
                -- Try ProximityPrompt interaction
                local proximityPrompt = nearestNPC:FindFirstChild("ProximityPrompt") or nearestNPC:FindFirstDescendant("ProximityPrompt")
                if proximityPrompt and proximityPrompt:IsA("ProximityPrompt") then
                    proximityPrompt:InputHoldBegin()
                    wait(0.1)
                    proximityPrompt:InputHoldEnd()
                end
            end
        end
        
        -- Use detected event or try common patterns
        if detectedEvents.QuestEvent then
            if detectedEvents.QuestEvent:IsA("RemoteEvent") then
                detectedEvents.QuestEvent:FireServer("Accept")
            elseif detectedEvents.QuestEvent:IsA("RemoteFunction") then
                detectedEvents.QuestEvent:InvokeServer("Accept")
            end
        else
            -- Fallback: Try common patterns
            local questEvents = {"QuestEvent", "AcceptQuest", "Quest", "CompleteQuest", "Mission"}
            for _, eventName in pairs(questEvents) do
                local event = ReplicatedStorage:FindFirstChild(eventName)
                if event then
                    if event:IsA("RemoteEvent") then
                        event:FireServer("Accept")
                    elseif event:IsA("RemoteFunction") then
                        event:InvokeServer("Accept")
                    end
                    break
                end
            end
        end
    end)
end

-- Auto Swing (Optimized for The Forge Beta)
local function autoSwing()
    if not config.AutoSwing then return end
    
    pcall(function()
        -- Activate tool first (The Forge Beta uses tool activation)
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
                -- Also try clicking if tool has ClickDetector
                local clickDetector = tool:FindFirstChild("ClickDetector")
                if clickDetector then
                    fireclickdetector(clickDetector)
                end
            end
        end
        
        -- Use detected event or try common patterns
        if detectedEvents.SwingEvent then
            if detectedEvents.SwingEvent:IsA("RemoteEvent") then
                detectedEvents.SwingEvent:FireServer()
            elseif detectedEvents.SwingEvent:IsA("RemoteFunction") then
                detectedEvents.SwingEvent:InvokeServer()
            end
        else
            -- Fallback: Try common patterns
            local swingEvents = {"SwingEvent", "Attack", "Swing", "Hit", "Use"}
            for _, eventName in pairs(swingEvents) do
                local event = ReplicatedStorage:FindFirstChild(eventName)
                if event then
                    if event:IsA("RemoteEvent") then
                        event:FireServer()
                    elseif event:IsA("RemoteFunction") then
                        event:InvokeServer()
                    end
                    break
                end
            end
        end
    end)
end

-- Auto Collect (Optimized for The Forge Beta - Runes, Coins, Items)
local function autoCollect()
    if not config.AutoCollect then return end
    
    pcall(function()
        local collectible = findNearestCollectible()
        if collectible then
            local collectPos = nil
            if collectible:IsA("BasePart") then
                collectPos = collectible.Position
            elseif collectible:GetPrimaryPartCFrame() then
                collectPos = collectible:GetPrimaryPartCFrame().Position
            elseif collectible:FindFirstChild("HumanoidRootPart") then
                collectPos = collectible.HumanoidRootPart.Position
            end
            
            if collectPos then
                local charPos = humanoidRootPart.Position
                local dist = (collectPos - charPos).Magnitude
                
                if dist > 3 then
                    teleportToPosition(collectPos, true) -- Use NoClip to collect through objects
                end
                
                -- The Forge Beta: Multiple collection methods
                -- Method 1: ProximityPrompt (most common)
                local proximityPrompt = collectible:FindFirstChild("ProximityPrompt") or collectible:FindFirstDescendant("ProximityPrompt")
                if proximityPrompt and proximityPrompt:IsA("ProximityPrompt") then
                    proximityPrompt:InputHoldBegin()
                    wait(0.1)
                    proximityPrompt:InputHoldEnd()
                end
                
                -- Method 2: ClickDetector
                local clickDetector = collectible:FindFirstChild("ClickDetector") or collectible:FindFirstDescendant("ClickDetector")
                if clickDetector then
                    fireclickdetector(clickDetector)
                end
                
                -- Method 3: TouchInterest
                if collectible:IsA("BasePart") and collectible:FindFirstChild("TouchInterest") then
                    firetouchinterest(humanoidRootPart, collectible, 0)
                    firetouchinterest(humanoidRootPart, collectible, 1)
                end
                
                -- Method 4: RemoteEvent (if exists)
                local collectEvents = {"CollectEvent", "PickupEvent", "Collect", "Pickup", "Rune"}
                for _, eventName in pairs(collectEvents) do
                    local event = ReplicatedStorage:FindFirstChild(eventName)
                    if event then
                        if event:IsA("RemoteEvent") then
                            event:FireServer(collectible)
                        elseif event:IsA("RemoteFunction") then
                            event:InvokeServer(collectible)
                        end
                        break
                    end
                end
            end
        end
    end)
end

-- Auto Upgrade (Optimized for The Forge Beta - Upgrade items with runes)
local function autoUpgrade()
    if not config.AutoUpgrade then return end
    
    pcall(function()
        -- Find upgrade station (Anvil, Upgrade Station, etc.)
        local upgradeStation = nil
        for _, obj in pairs(Workspace:GetDescendants()) do
            local objName = obj.Name:lower()
            if string.find(objName, "upgrade") or string.find(objName, "anvil") or string.find(objName, "enhance") then
                if obj:IsA("Model") or obj:IsA("BasePart") then
                    upgradeStation = obj
                    break
                end
            end
        end
        
        if upgradeStation then
            local stationPos = nil
            if upgradeStation:IsA("BasePart") then
                stationPos = upgradeStation.Position
            elseif upgradeStation:GetPrimaryPartCFrame() then
                stationPos = upgradeStation:GetPrimaryPartCFrame().Position
            end
            
            if stationPos then
                local dist = (stationPos - humanoidRootPart.Position).Magnitude
                if dist > 10 then
                    teleportToPosition(stationPos)
                    wait(0.5)
                end
                
                -- Try ProximityPrompt
                local proximityPrompt = upgradeStation:FindFirstChild("ProximityPrompt") or upgradeStation:FindFirstDescendant("ProximityPrompt")
                if proximityPrompt and proximityPrompt:IsA("ProximityPrompt") then
                    proximityPrompt:InputHoldBegin()
                    wait(0.1)
                    proximityPrompt:InputHoldEnd()
                end
                
                -- Try upgrade events
                local upgradeEvents = {"UpgradeEvent", "Upgrade", "Enhance", "Improve"}
                for _, eventName in pairs(upgradeEvents) do
                    local event = ReplicatedStorage:FindFirstChild(eventName)
                    if event then
                        if event:IsA("RemoteEvent") then
                            event:FireServer()
                        elseif event:IsA("RemoteFunction") then
                            event:InvokeServer()
                        end
                        break
                    end
                end
            end
        end
    end)
end

-- Auto Repair (Optimized for The Forge Beta)
local function autoRepair()
    if not config.AutoRepair then return end
    
    pcall(function()
        -- Check if character needs repair (low health or durability)
        if character and humanoid then
            if humanoid.Health < humanoid.MaxHealth * 0.5 then
                -- Find repair station
                local repairStation = nil
                for _, obj in pairs(Workspace:GetDescendants()) do
                    local objName = obj.Name:lower()
                    if string.find(objName, "repair") or string.find(objName, "heal") or string.find(objName, "restore") then
                        if obj:IsA("Model") or obj:IsA("BasePart") then
                            repairStation = obj
                            break
                        end
                    end
                end
                
                if repairStation then
                    local stationPos = nil
                    if repairStation:IsA("BasePart") then
                        stationPos = repairStation.Position
                    elseif repairStation:GetPrimaryPartCFrame() then
                        stationPos = repairStation:GetPrimaryPartCFrame().Position
                    end
                    
                    if stationPos then
                        local dist = (stationPos - humanoidRootPart.Position).Magnitude
                        if dist > 10 then
                            teleportToPosition(stationPos)
                            wait(0.5)
                        end
                        
                        -- Try ProximityPrompt
                        local proximityPrompt = repairStation:FindFirstChild("ProximityPrompt") or repairStation:FindFirstDescendant("ProximityPrompt")
                        if proximityPrompt and proximityPrompt:IsA("ProximityPrompt") then
                            proximityPrompt:InputHoldBegin()
                            wait(0.1)
                            proximityPrompt:InputHoldEnd()
                        end
                        
                        -- Try repair events
                        local repairEvents = {"RepairEvent", "Repair", "Heal", "Restore"}
                        for _, eventName in pairs(repairEvents) do
                            local event = ReplicatedStorage:FindFirstChild(eventName)
                            if event then
                                if event:IsA("RemoteEvent") then
                                    event:FireServer()
                                elseif event:IsA("RemoteFunction") then
                                    event:InvokeServer()
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- Anti-AFK
local function antiAFK()
    if not config.AntiAFK then return end
    
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- Anti Kick Moderator
local function setupAntiKick()
    pcall(function()
        -- Check if executor supports advanced functions
        local hasMetatable = pcall(function() return getrawmetatable(game) end)
        
        if hasMetatable then
            -- Hook Player:Kick using metatable (for advanced executors)
            local mt = getrawmetatable(game)
            local oldNamecall = mt.__namecall
            
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                
                if config.AntiKick and method == "Kick" and self == player then
                    warn("[Anti Kick] Blocked kick attempt via Player:Kick")
                    return
                end
                
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
        end
        
        -- Intercept RemoteEvents that might be used for kicking
        local function hookRemoteEvent(remote)
            if remote:IsA("RemoteEvent") then
                local name = remote.Name:lower()
                if string.find(name, "kick") or string.find(name, "ban") or string.find(name, "mod") or string.find(name, "punish") or string.find(name, "remove") then
                    -- Hook OnClientEvent
                    local connection
                    connection = remote.OnClientEvent:Connect(function(...)
                        if config.AntiKick then
                            warn("[Anti Kick] Blocked OnClientEvent from: " .. remote.Name)
                            connection:Disconnect()
                            -- Reconnect to continue monitoring
                            task.wait(0.1)
                            hookRemoteEvent(remote)
                            return
                        end
                    end)
                end
            elseif remote:IsA("RemoteFunction") then
                local name = remote.Name:lower()
                if string.find(name, "kick") or string.find(name, "ban") or string.find(name, "mod") then
                    -- Hook RemoteFunction
                    local oldInvoke = remote.InvokeServer
                    remote.InvokeServer = function(self, ...)
                        if config.AntiKick then
                            warn("[Anti Kick] Blocked InvokeServer to: " .. remote.Name)
                            return nil
                        end
                        return oldInvoke(self, ...)
                    end
                end
            end
        end
        
        -- Hook existing RemoteEvents
        for _, child in pairs(ReplicatedStorage:GetDescendants()) do
            hookRemoteEvent(child)
        end
        
        -- Monitor for new RemoteEvents
        ReplicatedStorage.DescendantAdded:Connect(function(child)
            hookRemoteEvent(child)
        end)
        
        -- Also check Workspace and other services
        for _, service in pairs({Workspace, game:GetService("StarterGui"), game:GetService("StarterPlayer")}) do
            for _, child in pairs(service:GetDescendants()) do
                hookRemoteEvent(child)
            end
            service.DescendantAdded:Connect(function(child)
                hookRemoteEvent(child)
            end)
        end
        
        -- Prevent teleport kicks (if metatable available)
        if hasMetatable then
            local TeleportService = game:GetService("TeleportService")
            local mt2 = getrawmetatable(TeleportService)
            if mt2 then
                setreadonly(mt2, false)
                local oldTeleportNamecall = mt2.__namecall
                mt2.__namecall = newcclosure(function(self, ...)
                    local args = {...}
                    local method = getnamecallmethod()
                    
                    if config.AntiKick and method == "Teleport" then
                        local placeId = args[1]
                        local players = args[2]
                        if players and (type(players) == "table" and table.find(players, player)) or players == player then
                            warn("[Anti Kick] Blocked teleport kick attempt to place: " .. tostring(placeId))
                            return
                        end
                    end
                    
                    return oldTeleportNamecall(self, ...)
                end)
                setreadonly(mt2, true)
            end
        end
        
        -- Keep player in game - reconnect if kicked
        player.CharacterRemoving:Connect(function()
            if config.AntiKick then
                warn("[Anti Kick] Character removal detected - attempting to reconnect")
            end
        end)
        
        -- Monitor player state
        player.PlayerGui.ChildRemoved:Connect(function(child)
            if config.AntiKick and child.Name == "EvilHub" then
                warn("[Anti Kick] UI removed - possible kick attempt")
            end
        end)
    end)
end

-- Initialize Anti Kick
setupAntiKick()

-- Re-setup Anti Kick when config changes
spawn(function()
    local lastAntiKickState = config.AntiKick
    while true do
        wait(1)
        if lastAntiKickState ~= config.AntiKick then
            lastAntiKickState = config.AntiKick
            if config.AntiKick then
                setupAntiKick()
            end
        end
    end
end)

-- Main Loop
local lastForge = 0
local lastCombat = 0
local lastFarm = 0
local lastQuest = 0
local lastSwing = 0
local lastCollect = 0
local lastAFK = 0
local lastUpgrade = 0
local lastRepair = 0

RunService.Heartbeat:Connect(function()
    local currentTime = tick()
    
    -- Update character references
    if not character or not character.Parent then
        character = player.Character
        if character then
            humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
            humanoid = character:WaitForChild("Humanoid", 5)
        end
    end
    
    if not humanoidRootPart or not humanoid then return end
    
    -- Update Walk Speed and Jump Power
    if humanoid then
        if humanoid.WalkSpeed ~= config.WalkSpeed then
            humanoid.WalkSpeed = config.WalkSpeed
        end
        if humanoid.JumpPower ~= config.JumpPower then
            humanoid.JumpPower = config.JumpPower
        end
    end
    
    -- Maintain NoClip/Fly
    if config.NoClip or config.FlyEnabled then
        if config.FlyEnabled then
            enableFly()
        else
            enableNoClip()
        end
    else
        if not config.AutoFarm and not config.AutoCombat then
            disableNoClip()
            disableFly()
        end
    end
    
    -- Auto enable NoClip/Fly during Farm/Combat
    if (config.AutoFarm or config.AutoCombat) and (config.NoClip or config.FlyEnabled) then
        if config.FlyEnabled then
            enableFly()
        else
            enableNoClip()
        end
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
    
    -- Auto Collect
    if config.AutoCollect and currentTime - lastCollect >= config.CollectDelay then
        autoCollect()
        lastCollect = currentTime
    end
    
    -- Auto Upgrade
    if config.AutoUpgrade and currentTime - lastUpgrade >= 5 then
        autoUpgrade()
        lastUpgrade = currentTime
    end
    
    -- Auto Repair
    if config.AutoRepair and currentTime - lastRepair >= 3 then
        autoRepair()
        lastRepair = currentTime
    end
    
    -- Anti-AFK
    if config.AntiAFK and currentTime - lastAFK >= 30 then
        antiAFK()
        lastAFK = currentTime
    end
end)

-- Character Respawn Handler
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = config.WalkSpeed
        humanoid.JumpPower = config.JumpPower
    end
    
    -- Re-enable NoClip/Fly if enabled
    wait(0.5)
    if config.FlyEnabled then
        enableFly()
    elseif config.NoClip then
        enableNoClip()
    end
end)

-- Debug: List all RemoteEvents in ReplicatedStorage (for The Forge Beta compatibility)
spawn(function()
    wait(2) -- Wait for game to load
    print("=== THE FORGE BETA - Remote Events Detection ===")
    local events = {}
    for _, child in pairs(ReplicatedStorage:GetDescendants()) do
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            table.insert(events, child.Name)
        end
    end
    if #events > 0 then
        print("Found RemoteEvents/RemoteFunctions:")
        for _, name in pairs(events) do
            print("  - " .. name)
        end
    else
        print("No RemoteEvents found in ReplicatedStorage")
    end
    print("=============================================")
end)

print("🔥 EVIL HUB - THE FORGE BETA EDITION 🔥")
print("✅ Optimized for The Forge Beta Roblox")
print("")
print("📋 Features:")
print("  ✓ Auto Forge (with auto-detection)")
print("  ✓ Auto Combat (with weapon equip)")
print("  ✓ Auto Farm (with ProximityPrompt support)")
print("  ✓ Auto Quest (with NPC interaction)")
print("  ✓ Auto Swing (with tool activation)")
print("  ✓ Auto Collect (Runes, Coins, Items)")
print("  ✓ Auto Upgrade (Items with runes)")
print("  ✓ Auto Repair (Auto heal when low HP)")
print("  ✓ Teleport & NoClip/Fly")
print("  ✓ Speed Control")
print("  ✓ Anti-AFK & Anti Kick")
print("")
print("🔍 Remote Events Detection:")
print("  Script akan otomatis mendeteksi remote events yang digunakan game")
print("  Cek console untuk melihat remote events yang terdeteksi")
print("")
print("⚠️ NOTE: Beberapa fitur mungkin perlu penyesuaian jika game update")

