-- =========================================================================
-- APEX HUB - MOBILE UI ARCHITECTURE (FULL 6 TABS)
-- =========================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- Xóa UI cũ nếu có
if CoreGui:FindFirstChild("ApexHub_MobileUI") then
    CoreGui.ApexHub_MobileUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ApexHub_MobileUI"
ScreenGui.Parent = CoreGui

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.5, -240, 0.3, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner Bo góc cho đẹp
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Top Bar (Tiêu đề + Logo)
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
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚡ APEX HUB | BLOX FRUITS PRO MAX"
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Nút Đóng (X)
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

-- Tab Menu Bar (Cột bên trái chọn Tab)
local TabBar = Instance.new("ScrollingFrame")
TabBar.Size = UDim2.new(0, 120, 1, -45)
TabBar.Position = UDim2.new(0, 5, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TabBar.BorderSizePixel = 0
TabBar.CanvasSize = UDim2.new(0, 0, 0, 250)
TabBar.ScrollBarThickness = 3
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabBar

-- Content Container (Khu vực hiển thị nội dung từng Tab bên phải)
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -135, 1, -45)
Container.Position = UDim2.new(0, 130, 0, 40)
Container.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Container.BorderSizePixel = 0
Container.Parent = MainFrame

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 6)
ContainerCorner.Parent = Container

-- Danh sách các Tab dữ liệu
local tabsData = {
    {"Main Farm", "Tab 1: Cày cấp, đánh nhanh, gom quái..."},
    {"Boss & Items", "Tab 2: Săn Boss, nhặt rương, nguyên liệu..."},
    {"Sea & Raid", "Tab 3: Sự kiện biển, đi Raid, Tộc V4..."},
    {"Teleport & ESP", "Tab 4: Dịch chuyển đảo, nhìn xuyên tường..."},
    {"Stats & Inv", "Tab 5: Quản lý chỉ số, công cụ kho đồ..."},
    {"Misc & Settings", "Tab 6: Đổi server, tối ưu FPS, Anti-AFK..."}
}

local tabButtons = {}
local tabPages = {}

-- Hàm chuyển đổi qua lại giữa các Tab
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

-- Khởi tạo vòng lặp tạo nút Tab và Trang tương ứng
for i, data in ipairs(tabsData) do
    -- Tạo nút bấm Tab bên trái
    local tBtn = Instance.new("TextButton")
    tBtn.Size = UDim2.new(1, -5, 0, 35)
    tBtn.BackgroundColor3 = (i == 1) and Color3.fromRGB(40, 170, 90) or Color3.fromRGB(35, 35, 48)
    tBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tBtn.TextSize = 12
    tBtn.Font = Enum.Font.GothamBold
    tBtn.Text = data[1]
    tBtn.Parent = TabBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = tBtn
    
    tabButtons[i] = tBtn

    -- Tạo trang nội dung tương ứng bên phải
    local tPage = Instance.new("ScrollingFrame")
    tPage.Size = UDim2.new(1, -10, 1, -10)
    tPage.Position = UDim2.new(0, 5, 0, 5)
    tPage.BackgroundTransparency = 1
    tPage.Visible = (i == 1)
    tPage.CanvasSize = UDim2.new(0, 0, 0, 400)
    tPage.ScrollBarThickness = 4
    tPage.Parent = Container

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 6)
    pageLayout.Parent = tPage

    -- Tiêu đề mô tả trong trang
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, 0, 0, 30)
    desc.BackgroundTransparency = 1
    desc.TextColor3 = Color3.fromRGB(180, 180, 180)
    desc.TextSize = 11
    desc.Font = Enum.Font.GothamSemibold
    desc.Text = data[2]
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = tPage

    -- Ví dụ thêm một nút Toggle mẫu cho mỗi Tab
    local sampleToggle = Instance.new("TextButton")
    sampleToggle.Size = UDim2.new(1, 0, 0, 32)
    sampleToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    sampleToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sampleToggle.TextSize = 12
    sampleToggle.Font = Enum.Font.GothamBold
    sampleToggle.Text = "[ TÍNH NĂNG MẪU ] : TẮT"
    sampleToggle.Parent = tPage

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 5)
    toggleCorner.Parent = sampleToggle

    sampleToggle.MouseButton1Click:Connect(function()
        if sampleToggle.Text:find("TẮT") then
            sampleToggle.Text = "[ TÍNH NĂNG MẪU ] : BẬT"
            sampleToggle.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        else
            sampleToggle.Text = "[ TÍNH NĂNG MẪU ] : TẮT"
            sampleToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        end
    end)

    tabPages[i] = tPage

    -- Sự kiện click chọn Tab
    tBtn.MouseButton1Click:Connect(function()
        switchTab(i)
    end)
end

print("[+] Apex Hub UI Mobile (6 Tabs) đã load thành công!")
