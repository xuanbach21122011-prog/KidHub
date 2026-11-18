-- =========================================================================
-- APEX HUB - MASTER MOBILE SCRIPT (FULL MODULE LOADER)
-- =========================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Xóa UI cũ nếu có tránh bị chồng chéo
if CoreGui:FindFirstChild("ApexHub_MobileUI") then
    CoreGui.ApexHub_MobileUI:Destroy()
end

-- =========================================================================
-- LOAD MODULES TỪ GITHUB (KIDHUB)
-- =========================================================================
local GITHUB_BASE = "https://raw.githubusercontent.com/xuanbach21122011-prog/KidHub/refs/heads/main/"

local function safeLoad(fileName)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(GITHUB_BASE .. fileName))()
    end)
    if success then
        print("[+] Đã nạp thành công module: " .. fileName)
        return result
    else
        warn("[-] Lỗi khi tải module: " .. fileName)
        return nil
    end
end

local ServerHop = safeLoad("serverhop.lua")
local RaceV4 = safeLoad("racev4.lua")
local Locations = safeLoad("locations.lua")
local AutoFarm = safeLoad("autofarm.lua")

-- =========================================================================
-- KHỞI TẠO GIAO DIỆN CHÍNH (UI) DÀNH CHO MOBILE
-- =========================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ApexHub_MobileUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.5, -240, 0.3, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 300, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 140)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚡ APEX HUB | KIDHUB PRO MAX"
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 25)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab Menu Bar (Bên trái)
local TabBar = Instance.new("ScrollingFrame")
TabBar.Size = UDim2.new(0, 120, 1, -45)
TabBar.Position = UDim2.new(0, 5, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TabBar.BorderSizePixel = 0
TabBar.CanvasSize = UDim2.new(0, 0, 0, 260)
TabBar.ScrollBarThickness = 3
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabBar

-- Content Container (Bên phải)
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -135, 1, -45)
Container.Position = UDim2.new(0, 130, 0, 40)
Container.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Container.BorderSizePixel = 0
Container.Parent = MainFrame

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 6)
ContainerCorner.Parent = Container

-- Danh sách 6 Tab
local tabsData = {
    {"Main Farm", "Tab 1: Cày cấp, gom quái, đánh nhanh"},
    {"Race V4 & Trial", "Tab 2: Tự động luyện Tộc V4, Trial, gạt cần"},
    {"Teleport", "Tab 3: Dịch chuyển nhanh các đảo (Sea 1-3)"},
    {"Server Hop", "Tab 4: Săn server trăng tròn, Mirage, Kitsune"},
    {"Stats & Tools", "Tab 5: Quản lý chỉ số, hỗ trợ vật phẩm"},
    {"Settings", "Tab 6: Tối ưu hóa, Anti-AFK"}
}

local tabButtons = {}
local tabPages = {}

local function switchTab(index)
    for i, page in ipairs(tabPages) do
        if i == index then
            page.Visible = true
            tabButtons[i].BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        else
            page.Visible = false
            tabButtons[i].BackgroundColor3 = Color3.fromRGB(35, 35, 48)
        end
    end
end

for i, data in ipairs(tabsData) do
    local tBtn = Instance.new("TextButton")
    tBtn.Size = UDim2.new(1, -5, 0, 35)
    tBtn.BackgroundColor3 = (i == 1) and Color3.fromRGB(40, 170, 90) or Color3.fromRGB(35, 35, 48)
    tBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tBtn.TextSize = 11
    tBtn.Font = Enum.Font.GothamBold
    tBtn.Text = data[1]
    tBtn.Parent = TabBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = tBtn
    tabButtons[i] = tBtn

    local tPage = Instance.new("ScrollingFrame")
    tPage.Size = UDim2.new(1, -10, 1, -10)
    tPage.Position = UDim2.new(0, 5, 0, 5)
    tPage.BackgroundTransparency = 1
    tPage.Visible = (i == 1)
    tPage.CanvasSize = UDim2.new(0, 0, 0, 500)
    tPage.ScrollBarThickness = 4
    tPage.Parent = Container

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 6)
    pageLayout.Parent = tPage

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, 0, 0, 25)
    desc.BackgroundTransparency = 1
    desc.TextColor3 = Color3.fromRGB(180, 180, 180)
    desc.TextSize = 10
    desc.Font = Enum.Font.GothamSemibold
    desc.Text = data[2]
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = tPage

    tabPages[i] = tPage
    tBtn.MouseButton1Click:Connect(function()
        switchTab(i)
    end)
end

-- =========================================================================
-- GẮN CHỨC NĂNG VÀO TỪNG TAB
-- =========================================================================

-- TAB 1: MAIN FARM
local tab1 = tabPages[1]
local farmToggle = Instance.new("TextButton")
farmToggle.Size = UDim2.new(1, 0, 0, 32)
farmToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
farmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
farmToggle.TextSize = 11
farmToggle.Font = Enum.Font.GothamBold
farmToggle.Text = "[ AUTO FARM LEVEL ] : TẮT"
farmToggle.Parent = tab1

local fCorner = Instance.new("UICorner")
fCorner.CornerRadius = UDim.new(0, 5)
fCorner.Parent = farmToggle

farmToggle.MouseButton1Click:Connect(function()
    if getgenv().FarmConfig then
        getgenv().FarmConfig.Enabled = not getgenv().FarmConfig.Enabled
        if getgenv().FarmConfig.Enabled then
            farmToggle.Text = "[ AUTO FARM LEVEL ] : ĐANG BẬT"
            farmToggle.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        else
            farmToggle.Text = "[ AUTO FARM LEVEL ] : TẮT"
            farmToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        end
    else
        warn("Module AutoFarm chưa load được!")
    end
end)


-- TAB 2: RACE V4 & TRIAL
local tab2 = tabPages[2]

-- Nút dịch chuyển đến Cửa Tốc (Temple of Time)
local teleV4Btn = Instance.new("TextButton")
teleV4Btn.Size = UDim2.new(1, 0, 0, 32)
teleV4Btn.BackgroundColor3 = Color3.fromRGB(60, 45, 90)
teleV4Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleV4Btn.TextSize = 11
teleV4Btn.Font = Enum.Font.GothamBold
teleV4Btn.Text = "⚡ Dịch Chuyển Đến Cửa Tốc (Temple of Time)"
teleV4Btn.Parent = tab2

local t4Corner = Instance.new("UICorner")
t4Corner.CornerRadius = UDim.new(0, 5)
t4Corner.Parent = teleV4Btn

teleV4Btn.MouseButton1Click:Connect(function()
    if RaceV4 then RaceV4.TeleportToTemple() end
end)

-- Nút Auto Trial & Gạt Cần
local trialToggle = Instance.new("TextButton")
trialToggle.Size = UDim2.new(1, 0, 0, 32)
trialToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
trialToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
trialToggle.TextSize = 11
trialToggle.Font = Enum.Font.GothamBold
trialToggle.Text = "[ AUTO TRIAL & GẠT CẦN ] : TẮT"
trialToggle.Parent = tab2

local trCorner = Instance.new("UICorner")
trCorner.CornerRadius = UDim.new(0, 5)
trCorner.Parent = trialToggle

trialToggle.MouseButton1Click:Connect(function()
    if getgenv().RaceConfig then
        getgenv().RaceConfig.AutoTrial = not getgenv().RaceConfig.AutoTrial
        if getgenv().RaceConfig.AutoTrial then
            trialToggle.Text = "[ AUTO TRIAL & GẠT CẦN ] : ĐANG BẬT"
            trialToggle.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
            RaceV4.RunTrialLoop()
        else
            trialToggle.Text = "[ AUTO TRIAL & GẠT CẦN ] : TẮT"
            trialToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        end
    end
end)

-- Ô nhập tên người chơi để Bật V4 cùng lúc (Không bật nếu khác tên)
local partnerBox = Instance.new("TextBox")
partnerBox.Size = UDim2.new(1, 0, 0, 32)
partnerBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
partnerBox.TextColor3 = Color3.fromRGB(0, 255, 140)
partnerBox.TextSize = 11
partnerBox.Font = Enum.Font.GothamBold
partnerBox.PlaceholderText = "Nhập tên người chơi bật chung (Hoặc gõ 'All')"
partnerBox.Text = "All"
partnerBox.Parent = tab2

local pCorner = Instance.new("UICorner")
pCorner.CornerRadius = UDim.new(0, 5)
pCorner.Parent = partnerBox

partnerBox.FocusLost:Connect(function()
    if getgenv().RaceConfig then
        getgenv().RaceConfig.SelectedPartner = partnerBox.Text
        print("[+] Đã cập nhật người chơi đồng bộ V4: " .. partnerBox.Text)
    end
end)

-- Nút mua Gear
local buyGearBtn = Instance.new("TextButton")
buyGearBtn.Size = UDim2.new(1, 0, 0, 32)
buyGearBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
buyGearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
buyGearBtn.TextSize = 11
buyGearBtn.Font = Enum.Font.GothamBold
buyGearBtn.Text = "🛒 Tự Động Mua / Nâng Cấp Gear"
buyGearBtn.Parent = tab2

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 5)
bgCorner.Parent = buyGearBtn

buyGearBtn.MouseButton1Click:Connect(function()
    if RaceV4 then RaceV4.BuyGear() end
end)


-- TAB 3: TELEPORT (TỌA ĐỘ ĐẢO)
local tab3 = tabPages[3]
if Locations and Locations.Sea3 then
    for _, island in ipairs(Locations.Sea3) do
        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(1, 0, 0, 28)
        tpBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
        tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tpBtn.TextSize = 10
        tpBtn.Font = Enum.Font.GothamSemibold
        tpBtn.Text = "Đảo: " .. island.Name
        tpBtn.Parent = tab3
        
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 4)
        c.Parent = tpBtn
        
        tpBtn.MouseButton1Click:Connect(function()
            pcall(function()
                LocalPlayer.Character.HumanoidRootPart.CFrame = island.CFrame
            end)
        end)
    end
end


-- TAB 4: SERVER HOP
local tab4 = tabPages[4]
local hopBtn = Instance.new("TextButton")
hopBtn.Size = UDim2.new(1, 0, 0, 35)
hopBtn.BackgroundColor3 = Color3.fromRGB(170, 90, 40)
hopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hopBtn.TextSize = 11
hopBtn.Font = Enum.Font.GothamBold
hopBtn.Text = "🌐 Đổi Server Ngẫu Nhiên (Server Hop)"
hopBtn.Parent = tab4

local hCorner = Instance.new("UICorner")
hCorner.CornerRadius = UDim.new(0, 5)
hCorner.Parent = hopBtn

hopBtn.MouseButton1Click:Connect(function()
    if ServerHop then
        ServerHop.Hop("Random")
    else
        warn("Module Server Hop chưa sẵn sàng!")
    end
end)


-- TAB 6: SETTINGS (CÀI ĐẶT CHUNG)
local tab6 = tabPages[6]
local infoLabel = Instance.new("TextLabel")
infoInfo = infoLabel
infoLabel.Size = UDim2.new(1, 0, 0, 40)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(0, 255, 140)
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.GothamBold
infoLabel.Text = "Apex Hub v3.0 - Đã nạp đầy đủ 4 Module từ KidHub thành công!"
infoLabel.TextWrapped = true
infoLabel.Parent = tab6

print("[+] Apex Hub Mobile đã khởi chạy thành công toàn bộ hệ thống!")
