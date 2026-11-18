-- =========================================================================
-- MODULE: AUTO RACE V2, V3, V4 & TRIAL SYSTEM
-- =========================================================================
local RaceV4Module = {}
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

getgenv().RaceConfig = {
    AutoUpgradeV2V3 = true,
    AutoTrial = true,
    AutoBuyGear = true,
    AutoPullLever = true,
    AutoAwaken = true,       -- Tự động bật V4 / V3 khi có người khác bật
    SelectedPartner = "None" -- Tên người chơi chọn để bật cùng lúc (Hoặc "All" để bật ké bất kỳ ai)
}

local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
local CommF = Remotes and Remotes:FindFirstChild("CommF_")

-- 1. Tự động kiểm tra và làm nhiệm vụ V2 / V3
function RaceV4Module.CheckAndDoUpgrade()
    pcall(function()
        if not CommF then return end
        -- Gọi tiến trình kiểm tra quest hoa (V2) hoặc từ giã cướp biển (V3)
        CommF:InvokeServer("Alchemist", "1")
        CommF:InvokeServer("Alchemist", "2")
        -- Nhận quest V3 từ Arowe
        CommF:InvokeServer("GetQuestV3")
    end)
end

-- 2. Tự động dịch chuyển đến cửa tộc / Temple of Time
function RaceV4Module.TeleportToTemple()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Tọa độ Temple of Time (V4)
            char.HumanoidRootPart.CFrame = CFrame.new(28282, 14899, 105)
        end
    end)
end

-- 3. Tự động bật V3 / V4 khi người chơi được chỉ định (hoặc người khác) bật
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if getgenv().RaceConfig.AutoAwaken then
                for _, player in ipairs(Players:GetChildren()) do
                    if player ~= LocalPlayer and player.Character then
                        local isTargetMatch = (getgenv().RaceConfig.SelectedPartner == "All" or player.Name == getgenv().RaceConfig.SelectedPartner)
                        
                        -- Kiểm tra xem người chơi đó có đang bật V4 không (dựa vào hiệu ứng Aura/Awaken)
                        local char = player.Character
                        local v4Effect = char:FindFirstChild("RaceTransformed") or char:FindFirstChild("InV4")
                        
                        if isTargetMatch and v4Effect then
                            -- Bật V4 / V3 của mình lên ngay lập tức
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Y, false, game)
                            task.wait(0.1)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Y, false, game)
                        end
                    end
                end
            end
        end)
    end
end)

-- 4. Tự động vượt thử thách Trial của từng tộc & gạt cần
function RaceV4Module.RunTrialLoop()
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                if getgenv().RaceConfig.AutoTrial then
                    -- Kiểm tra xem đang ở trong khu vực Trial hay không
                    local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart and rootPart.Position.Y > 14000 then -- Vùng không gian trên mây / Trial
                        -- Logic tự động đi qua các thử thách (Săn quái / né đạn / leo tháp tùy thuộc vào tộc)
                        local enemies = Workspace:FindFirstChild("Enemies")
                        if enemies then
                            for _, enemy in ipairs(enemies:GetChildren()) do
                                local eRoot = enemy:FindFirstChild("HumanoidRootPart")
                                local eHum = enemy:FindFirstChildOfClass("Humanoid")
                                if eRoot and eHum and eHum.Health > 0 then
                                    rootPart.CFrame = eRoot.CFrame * CFrame.new(0, 10, 0)
                                    -- Đánh quái hoàn thành Trial
                                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                                    if tool then tool:Activate() end
                                end
                            end
                        end
                        
                        -- Tự động gạt cần khi hoàn thành Trial
                        if CommF then
                            CommF:InvokeServer("AwakeningProg", "Check")
                            CommF:InvokeServer("AwakeningProg", "Unlock")
                        end
                    end
                end
            end)
        end
    end)
end

-- 5. Tự động mua Gear tại Ancient Clock (Đồng hồ cổ)
function RaceV4Module.BuyGear()
    pcall(function()
        if CommF then
            -- Gửi yêu cầu mua hoặc nâng cấp Gear
            CommF:InvokeServer("BuyGear")
        end
    end)
end

return RaceV4Module
