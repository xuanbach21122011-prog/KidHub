-- =========================================================================
-- MODULE: AUTOFARM TWEEN (BAY ĐẾN MƯỢT MÀ + FIX LỖI KHÔNG GÂY SÁT THƯƠNG)
-- =========================================================================
local AutoFarmModule = {}
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

getgenv().FarmConfig = {
    Enabled = false,
}

-- Hàm tìm quái gần nhất và còn sống
local function getBestMob()
    local target = nil
    local shortestDist = math.huge
    local enemies = Workspace:FindFirstChild("Enemies")
    
    if enemies then
        local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            for _, mob in ipairs(enemies:GetChildren()) do
                local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                local mobHum = mob:FindFirstChildOfClass("Humanoid")
                if mobRoot and mobHum and mobHum.Health > 0 then
                    local dist = (rootPart.Position - mobRoot.Position).Magnitude
                    if dist < 500 and dist < shortestDist then
                        shortestDist = dist
                        target = mob
                    end
                end
            end
        end
    end
    return target
end

-- Biến lưu trữ Tween hiện tại để tránh bị chồng chéo lệnh
local currentTween = nil

-- Vòng lặp Farm bằng phương pháp bay mượt (Tween) và ép đánh trúng đích
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if getgenv().FarmConfig.Enabled then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                    if char.Humanoid.Health > 0 then
                        local rootPart = char.HumanoidRootPart
                        local mob = getBestMob()
                        
                        if mob and mob:FindFirstChild("HumanoidRootPart") then
                            local mobRoot = mob.HumanoidRootPart
                            local mobHum = mob:FindFirstChildOfClass("Humanoid")
                            
                            if mobHum and mobHum.Health > 0 then
                                -- Tính toán vị trí đứng trên đầu quái một chút
                                local targetCFrame = mobRoot.CFrame * CFrame.new(0, 5, 2)
                                local distance = (rootPart.Position - mobRoot.Position).Magnitude
                                
                                -- Nếu ở xa thì dùng Tween bay đến mượt mà (không bị anti-cheat kéo giật về)
                                if distance > 15 then
                                    if currentTween then currentTween:Cancel() end
                                    local info = TweenInfo.new(distance / 250, Enum.EasingStyle.Linear) -- Tốc độ bay mượt
                                    currentTween = TweenService:Create(rootPart, info, {CFrame = targetCFrame})
                                    currentTween:Play()
                                else
                                    -- Khi đã bay tới sát quái, cố định vị trí nhẹ nhàng và kích hoạt đánh
                                    if currentTween then currentTween:Cancel() end
                                    rootPart.CFrame = targetCFrame
                                end
                                
                                -- Kích hoạt vũ khí liên tục để gây sát thương chuẩn xác
                                local tool = char:FindFirstChildOfClass("Tool")
                                if tool then
                                    tool:Activate()
                                else
                                    -- Tự động cầm vũ khí lên nếu tay không
                                    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
                                    if backpack then
                                        for _, item in ipairs(backpack:GetChildren()) do
                                            if item:IsA("Tool") then
                                                char.Humanoid:EquipTool(item)
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                if currentTween then currentTween:Cancel() end
            end
        end)
    end
end)

return AutoFarmModule
