--[[
    HAZE V2.2 - CYAN NEON (WHITELIST & SYNTAX FIX)
    - UPDATED: Added jiejisung00 to Whitelist
    - FIXED: Table syntax check
    - FIXED: Kick message "YOU NOT WHILIST"
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- SECURITY: WHITELIST SYSTEM
-- ==========================================
local Whitelist = {
    "hanssaputra15",
    "L0rdDarkShad0w",
    "chibhothax",
    "jiejisung00" -- Nama baru udah masuk sini, Ze!
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
    return 
end

-- ==========================================
-- UI SYSTEM BYPASS
-- ==========================================
local PlayerGui = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")
local oldUIs = {"HAZE_HUB", "HAZE_V2_2", "HAZE_FINAL"}
for _, uiName in pairs(oldUIs) do 
    pcall(function() if PlayerGui:FindFirstChild(uiName) then PlayerGui[uiName]:Destroy() end end) 
end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "HAZE_V2_2"
ScreenGui.ResetOnSpawn = false

-- 1. MAIN FRAME
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -85, 0.3, 0)
MainFrame.Size = UDim2.new(0, 170, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 255)

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -10, 1, -20)
Scroll.Position = UDim2.new(0, 5, 0, 10)
Scroll.BackgroundTransparency = 1
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarThickness = 2

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ==========================================
-- UTILITY FUNCTIONS
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

local function getTargetPlayer(query)
    if query == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (p.Name:lower():find(query:lower()) or p.DisplayName:lower():find(query:lower())) then
            return p
        end
    end
    return nil
end

-- ==========================================
-- UI COMPONENTS
-- ==========================================
local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Text = name .. ": OFF"
    Instance.new("UICorner", btn)
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = name .. ": " .. (enabled and "ON" or "OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
        callback(enabled)
    end)
end

local function createInput(placeholder, callback)
    local box = Instance.new("TextBox", Scroll)
    box.Size = UDim2.new(0.9, 0, 0, 30)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = Enum.Font.Gotham
    box.TextSize = 10
    Instance.new("UICorner", box)
    box.FocusLost:Connect(function() callback(box.Text) end)
end

-- ==========================================
-- FEATURES LOGIC
-- ==========================================

-- AUTO EAT & RUN SPEED
getgenv().AutoFarm = false
getgenv().SpeedEnabled = false
getgenv().SpeedValue = 100

RunService.Heartbeat:Connect(function(delta)
    local char = LocalPlayer.Character
    if not char then return end
    
    if getgenv().AutoFarm then
        pcall(function()
            local setCubes = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("SetCubes")
            if setCubes then setCubes:FireServer() end
            if char:FindFirstChild("Events") then
                char.Events.Grab:FireServer(false, false, false)
                char.Events.Eat:FireServer()
            end
        end)
    end
    
    if getgenv().SpeedEnabled and char:FindFirstChild("HumanoidRootPart") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (hum.MoveDirection * getgenv().SpeedValue * delta)
        end
    end
end)

-- ATTACK TP
getgenv().AttackTP = false
getgenv().TargetPlayerName = ""

task.spawn(function()
    while task.wait(0.5) do
        if getgenv().AttackTP then
            local target = getTargetPlayer(getgenv().TargetPlayerName)
            local char = LocalPlayer.Character
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and char then
                pcall(function()
                    char:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                    if char:FindFirstChild("Events") and char.Events:FindFirstChild("Grab") then
                        char.Events.Grab:FireServer()
                    end
                end)
            end
        end
    end
end)

-- ESP SYSTEM
local espEnabled = false
local espObjects = {}

local function createESP(p)
    if p == LocalPlayer then return end
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(0, 255, 255)
    hl.OutlineColor = Color3.new(1,1,1)
    
    local bg = Instance.new("BillboardGui")
    bg.Size = UDim2.new(0, 150, 0, 50)
    bg.AlwaysOnTop = true
    bg.StudsOffset = Vector3.new(0, 3, 0)
    
    local tl = Instance.new("TextLabel", bg)
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.BackgroundTransparency = 1
    tl.TextColor3 = Color3.new(1, 1, 1)
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 12
    
    espObjects[p] = {player = p, highlight = hl, billboard = bg, label = tl}
end

RunService.Heartbeat:Connect(function()
    if not espEnabled then return end
    for p, obj in pairs(espObjects) do
        local char = p.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            obj.highlight.Parent = char
            obj.billboard.Parent = char.HumanoidRootPart
            local sz = cariDataBruteForce(p, "Size")
            obj.label.Text = string.format("%s\nSize: %s", p.DisplayName, sz)
        else
            obj.highlight.Parent = nil
            obj.billboard.Parent = nil
        end
    end
end)

-- ==========================================
-- ASSEMBLE UI
-- ==========================================
createToggle("Auto Eat", function(v) getgenv().AutoFarm = v end)
createToggle("Run Speed", function(v) getgenv().SpeedEnabled = v end)
createInput("Speed Value", function(t) getgenv().SpeedValue = tonumber(t) or 100 end)
createToggle("Player ESP", function(v) 
    espEnabled = v 
    if not v then for _, o in pairs(espObjects) do o.highlight.Parent = nil o.billboard.Parent = nil end end
end)
createInput("Target Name (TP)", function(t) getgenv().TargetPlayerName = t end)
createToggle("Attack TP Loop", function(v) getgenv().AttackTP = v end)

-- Init
for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
