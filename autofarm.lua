-- =========================================================================
-- MODULE: AUTOFARM & FAST ATTACK (FIX LỖI BAY LÊN TRỜI)
-- =========================================================================
local AutoFarmModule = {}
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

getgenv().FarmConfig = {
    Enabled = false,
    FastAttack = true,
    Distance = 3 -- Khoảng cách đứng so với quái
}

-- Hàm tìm quái gần nhất
local function getNearestMob()
    local nearest = nil
    local shortestDistance = math.huge
    local enemies = Workspace:FindFirstChild("Enemies")
    
    if enemies then
        local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            for _, mob in ipairs(enemies:GetChildren()) do
                local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                local mobHum = mob:FindFirstChildOfClass("Humanoid")
                if mobRoot and mobHum and mobHum.Health > 0 then
                    local dist = (rootPart.Position - mobRoot.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        nearest = mob
                    end
                end
            end
        end
    end
    return nearest
end

-- Vòng lặp Auto Farm cốt lõi (Ổn định không bay ngược lên trời)
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if getgenv().FarmConfig.Enabled then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local rootPart = char.HumanoidRootPart
                    local targetMob = getNearestMob()
                    
                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                        local mobRoot = targetMob.HumanoidRootPart
                        local mobHum = targetMob:FindFirstChildOfClass("Humanoid")
                        
                        -- Ghim vị trí đứng ngay trên đầu/trước mặt quái (Cố định trục Y không bị cộng dồn vô hạn)
                        rootPart.CFrame = mobRoot.CFrame * CFrame.new(0, 5, 3)
                        
                        -- Tự động đánh quái
                        if mobHum and mobHum.Health > 0 then
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then
                                tool:Activate()
                            else
                                -- Nếu chưa cầm vũ khí, tự động trang bị vũ khí đầu tiên trong balo
                                local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
                                if backpack then
                                    for _, item in ipairs(backpack:GetChildren()) do
                                        if item:IsA("Tool") and (item.ToolTip == "Melee" or item.ToolTip == "Sword" or item.ToolTip == "Blox Fruit") then
                                            LocalPlayer.Character.Humanoid:EquipTool(item)
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

return AutoFarmModule
