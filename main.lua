--[[
    HAZE V2.2 - CYAN NEON (ULTIMATE FIX)
    - FIXED: Pesan Kick ganti jadi "YOU NOT WHILIST"
    - FIXED: cariDataBruteForce dimasukin (ESP ga bakal error)
    - FIXED: createESP function added (ESP sekarang muncul)
    - FIXED: Run Speed logic dibikin lebih stabil
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- SECURITY: WHITELIST SYSTEM
-- ==========================================
local Whitelist = {
    "hanssaputra15",
    "L0rdDarkShad0w",
    "chibhothax"
}

local isWhitelisted = false
for _, name in ipairs(Whitelist) do
    if LocalPlayer.Name == name then
        isWhitelisted = true
        break
    end
end

if not isWhitelisted then
    LocalPlayer:Kick("YOU NOT WHILIST")
    return -- Stop execution
end

-- ==========================================
-- BYPASS COREGUI PERMISSION (ANTI-CRASH)
-- ==========================================
local PlayerGui
local success = pcall(function() 
    PlayerGui = game:GetService("CoreGui") 
    local test = PlayerGui.Name 
end)

if not success or not PlayerGui then
    PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
end

-- ==========================================
-- HANS BIG PLATFORM (ANTI-LICIN EDITION)
-- ==========================================
if not workspace:FindFirstChild("HansBigPlatform") then
    local p = Instance.new("Part")
    p.Name = "HansBigPlatform"
    p.Size = Vector3.new(3000, 10, 3000)
    p.Anchored = true
    p.CanCollide = true
    p.Position = Vector3.new(0, -6, 0)
    p.Material = Enum.Material.Fabric 
    p.CustomPhysicalProperties = PhysicalProperties.new(100, 2, 0, 100, 100) 
    p.Parent = workspace
end

-- Bersihkan UI HAZE lama aja (UI Game Asli AMAN)
local oldUIs = {"HAZE_HUB", "HAZE_V2_2", "MainFrame"}
for _, uiName in pairs(oldUIs) do
    pcall(function()
        if PlayerGui:FindFirstChild(uiName) then PlayerGui[uiName]:Destroy() end
    end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HAZE_V2_2"
pcall(function()
    ScreenGui.Parent = (gethui and gethui()) or PlayerGui
end)
ScreenGui.ResetOnSpawn = false

-- 1. ANIMASI INTRO
local function playIntro()
    local IntroText = Instance.new("TextLabel")
    IntroText.Parent = ScreenGui
    IntroText.BackgroundTransparency = 1
    IntroText.Position = UDim2.new(0.5, 0, 0.5, 0)
    IntroText.Font = Enum.Font.GothamBold
    IntroText.Text = "HAZE V2.2"
    IntroText.TextColor3 = Color3.fromRGB(0, 255, 255) 
    IntroText.TextSize = 0
    IntroText.AnchorPoint = Vector2.new(0.5, 0.5)
    
    TweenService:Create(IntroText, TweenInfo.new(0.8, Enum.EasingStyle.Back), {TextSize = 60}):Play()
    task.wait(1.2)
    TweenService:Create(IntroText, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    task.delay(0.8, function() IntroText:Destroy() end)
end
playIntro()

-- 2. MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -85, 0.3, 0)
MainFrame.Size = UDim2.new(0, 170, 0, 280) 
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 255, 255) 
Stroke.Thickness = 1.5

-- 3. SCROLLING AREA
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -10, 1, -40)
Scroll.Position = UDim2.new(0, 5, 0, 35)
Scroll.BackgroundTransparency = 1
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y 
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0) 
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255) 

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 4. LOGO "H" TOGGLE
local MenuBtn = Instance.new("TextButton", ScreenGui)
MenuBtn.Size = UDim2.new(0, 42, 0, 42) 
MenuBtn.Position = UDim2.new(0, 20, 0.5, -20)
MenuBtn.Text = "H"
MenuBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MenuBtn.TextColor3 = Color3.fromRGB(0, 255, 255) 
MenuBtn.Font = Enum.Font.GothamBold
MenuBtn.TextSize = 24 
MenuBtn.Draggable = true 
Instance.new("UICorner", MenuBtn).CornerRadius = UDim.new(1, 0)

local BtnStroke = Instance.new("UIStroke", MenuBtn)
BtnStroke.Color = Color3.fromRGB(0, 255, 255) 
BtnStroke.Thickness = 2 
BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 

MenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible 
end)

-- 5. COMPONENT GENERATORS
local function createToggle(name, default, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.95, 0, 0, 28)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 10
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    
    local enabled = default
    local function update()
        btn.Text = name .. ": " .. (enabled and "ON" or "OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
        callback(enabled)
    end
    btn.MouseButton1Click:Connect(function() enabled = not enabled update() end)
    update()
end

local function createInput(placeholder, callback)
    local box = Instance.new("TextBox", Scroll)
    box.Size = UDim2.new(0.95, 0, 0, 28)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = Enum.Font.Gotham
    box.TextSize = 10
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
    box.FocusLost:Connect(function() callback(box.Text) end)
end

-- ==========================================
-- UTILITY: BRUTE FORCE DATA FINDER
-- ==========================================
local function cariDataBruteForce(targetPlayer, namaData)
    local val = "?"
    pcall(function()
        local ls = targetPlayer:FindFirstChild("leaderstats")
        if ls and ls:FindFirstChild(namaData) then 
            val = ls[namaData].Value 
        else
            local attr = targetPlayer:GetAttribute(namaData)
            if attr then val = attr end
        end
    end)
    return tostring(val)
end

-- ==========================================
-- FEATURE LOGIC
-- ==========================================

-- ANTI-VOID
getgenv().AntiVoid = false
task.spawn(function()
    while task.wait(0.05) do
        if getgenv().AntiVoid then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root and root.Position.Y < -50 then
                root.Velocity = Vector3.new(0, 0, 0)
                root.CFrame = CFrame.new(0, 50, 0)
            end
        end
    end
end)
createToggle("Anti-Void", false, function(v) getgenv().AntiVoid = v end)

-- AUTO EAT & SPEED
getgenv().AutoFarm = false
getgenv().SpeedEnabled = false
getgenv().SpeedValue = 100

local setCubesEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("SetCubes")

RunService.Heartbeat:Connect(function(delta)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if getgenv().AutoFarm then
        pcall(function()
            if setCubesEvent then setCubesEvent:FireServer() end
            if char:FindFirstChild("Events") then
                if char.Events:FindFirstChild("Grab") then char.Events.Grab:FireServer(false, false, false) end
                if char.Events:FindFirstChild("Eat") then char.Events.Eat:FireServer() end
            end
        end)
    end
    
    if getgenv().SpeedEnabled and hum and root then
        if hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * getgenv().SpeedValue * delta)
        end
    end
end)

createToggle("Auto Eat", false, function(v) getgenv().AutoFarm = v end)
createInput("Speed Value", function(t) getgenv().SpeedValue = tonumber(t) or 100 end)
createToggle("Run Speed", false, function(v) getgenv().SpeedEnabled = v end)

-- AUTO SELL (UI BAR)
getgenv().AutoSellBar = false
local cachedBar = nil
local isSelling = false

local function findBar()
    if cachedBar and cachedBar.Parent then return cachedBar end
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        for _, v in pairs(playerGui:GetDescendants()) do
            if v:IsA("Frame") and (v.Name:lower():find("bar") or v.Name:lower():find("meter")) then
                cachedBar = v
                return v
            end
        end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    if not getgenv().AutoSellBar or isSelling then return end
    local b = findBar()
    if b and b.Size.X.Scale >= 1 then
        local c = LocalPlayer.Character
        local s = c and c:FindFirstChild("Events") and c.Events:FindFirstChild("Sell")
        if s then
            isSelling = true
            pcall(function() s:FireServer() end)
            task.delay(0.5, function() isSelling = false end)
        end
    end
end)

createToggle("Auto Sell (Bar)", false, function(v) getgenv().AutoSellBar = v end)

-- GRAVITY & GOD MODE
createToggle("Gravity Lock", false, function(v)
    _G.GravityLock = v
    if _G.GravityLock then
        if not _G.GravLockLoop then
            _G.GravLockLoop = RunService.Heartbeat:Connect(function() workspace.Gravity = 196.2 end)
        end
    else
        if _G.GravLockLoop then _G.GravLockLoop:Disconnect() _G.GravLockLoop = nil end
    end
end)

createToggle("God Anti-Ragdoll", false, function(v)
    _G.GodModeRagdoll = v
    local RS = game:GetService("ReplicatedStorage")
    if _G.GodModeRagdoll then
        if not _G.GodLoop then
            _G.GodLoop = RunService.Heartbeat:Connect(function()
                local currentChar = LocalPlayer.Character
                if currentChar then
                    pcall(function() if RS.Events:FindFirstChild("unRagdoll") then RS.Events.unRagdoll:FireServer(currentChar) end end)
                    local hum = currentChar:FindFirstChild("Humanoid")
                    if hum then
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    end
                end
            end)
        end
    else
        if _G.GodLoop then _G.GodLoop:Disconnect() _G.GodLoop = nil end
    end
end)

-- ==========================================
-- ESP SYSTEM (FIXED)
-- ==========================================
local espEnabled = false
local espObjects = {}

local function createESP(player)
    if player == LocalPlayer then return end
    
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(0, 255, 255)
    hl.OutlineColor = Color3.new(1, 1, 1)
    
    local bg = Instance.new("BillboardGui")
    bg.Size = UDim2.new(0, 150, 0, 50)
    bg.AlwaysOnTop = true
    bg
