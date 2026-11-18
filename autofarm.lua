-- =========================================================================
-- MODULE: AUTO FARM PRO MAX (AUTO QUEST + CHECK LEVEL/ĐẢO + GOM QUÁI)
-- =========================================================================
local AutoFarmModule = {}
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

getgenv().FarmConfig = {
    Enabled = false,
}

local currentTween = nil
local CommF = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")

-- Hàm kiểm tra cấp độ và tên nhiệm vụ / quái phù hợp theo level hiện tại
local function getQuestInfo()
    local level = LocalPlayer.Data and LocalPlayer.Data.Level.Value or 1
    
    -- Hệ thống tự động phân loại nhiệm vụ dựa theo cấp độ (Sea 1, Sea 2, Sea 3)
    -- Trả về: { tên quest (tên NPC giao), tên bảng quest, tên quái cần đánh, tọa độ nhận quest }
    if level >= 1 and level <= 9 then
        return { Npc = "Bandit [Lv. 5]", QuestName = "BanditQuest1", MobName = "Bandit" }
    elseif level >= 10 and level <= 14 then
        return { Npc = "Monkey [Lv. 14]", QuestName = "JungleQuest", MobName = "Monkey" }
    elseif level >= 15 and level <= 29 then
        return { Npc = "Gorilla [Lv. 20]", QuestName = "JungleQuest", MobName = "Gorilla" }
    elseif level >= 30 and level <= 39 then
        return { Npc = "Pirate [Lv. 35]", QuestName = "BuggyQuest1", MobName = "Pirate" }
    -- (Ông có thể mở rộng thêm các mốc level khác tùy ý, script sẽ tự nhận diện theo Level hiện tại)
    else
        -- Mặc định tự tìm quái gần nhất nếu cấp độ chưa được khai báo thủ công ở bảng cơ bản
        return { Npc = nil, QuestName = nil, MobName = nil }
    end
end

-- Hàm tự động nhận nhiệm vụ từ NPC
local function checkAndGetQuest()
    pcall(function()
        if not CommF then return end
        local questData = getQuestInfo()
        
        -- Kiểm tra xem nhân vật đã có nhiệm vụ chưa (thông qua UI hiển thị quest bên trái màn hình)
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local mainUI = playerGui and playerGui:FindFirstChild("Main")
        local questDisplay = mainUI and mainUI:FindFirstChild("Quest")
        
        if not questDisplay or not questDisplay.Visible then
            -- Nếu chưa có quest, tiến hành gọi Remote nhận nhiệm vụ tương ứng
            if questData.QuestName then
                CommF:InvokeServer("StartQuest", questData.QuestName, 1)
            end
        end
    end)
end

-- Hàm gom tất cả quái xung quanh lại một điểm (Bring Mob)
local function bringMobs(targetMobRoot)
    pcall(function()
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, mob in ipairs(enemies:GetChildren()) do
                if mob ~= targetMobRoot.Parent then
                    local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                    local mobHum = mob:FindFirstChildOfClass("Humanoid")
                    if mobRoot and mobHum and mobHum.Health > 0 then
                        mobRoot.CFrame = targetMobRoot.CFrame
                        mobHum.WalkSpeed = 0
                        mobHum.JumpPower = 0
                        if mob:FindFirstChild("Humanoid") then
                            mob.Humanoid:ChangeState(Enum.HumanoidStateType.Stunned)
                        end
                    end
                end
            end
        end
    end)
end

-- Hàm tìm quái chuẩn xác dựa trên level hoặc quái gần nhất
local function getBestMob()
    local target = nil
    local shortestDist = math.huge
    local enemies = Workspace:FindFirstChild("Enemies")
    local questData = getQuestInfo()
    
    if enemies then
        local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            for _, mob in ipairs(enemies:GetChildren()) do
                local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                local mobHum = mob:FindFirstChildOfClass("Humanoid")
                if mobRoot and mobHum and mobHum.Health > 0 then
                    -- Nếu có tên quái theo nhiệm vụ thì ưu tiên tìm đúng loại quái đó, nếu không thì lấy quái gần nhất
                    local isCorrectMob = not questData.MobName or mob.Name:find(questData.MobName)
                    if isCorrectMob then
                        local dist = (rootPart.Position - mobRoot.Position).Magnitude
                        if dist < 500 and dist < shortestDist then
                            shortestDist = dist
                            target = mob
                        end
                    end
                end
            end
        end
    end
    return target
end

-- Vòng lặp chính: Check level -> Nhận Quest -> Bay đến quái -> Gom quái & Đánh nhanh
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if getgenv().FarmConfig.Enabled then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                    if char.Humanoid.Health > 0 then
                        -- 1. Tự động kiểm tra và nhận nhiệm vụ phù hợp với level hiện tại
                        checkAndGetQuest()
                        
                        local rootPart = char.HumanoidRootPart
                        local mob = getBestMob()
                        
                        if mob and mob:FindFirstChild("HumanoidRootPart") then
                            local mobRoot = mob.HumanoidRootPart
                            local mobHum = mob:FindFirstChildOfClass("Humanoid")
                            
                            if mobHum and mobHum.Health > 0 then
                                -- Độ cao chuẩn không che tầm nhìn: CFrame.new(0, 5.5, 2.5)
                                local targetCFrame = mobRoot.CFrame * CFrame.new(0, 5.5, 2.5)
                                local distance = (rootPart.Position - mobRoot.Position).Magnitude
                                
                                if distance > 12 then
                                    if currentTween then currentTween:Cancel() end
                                    local info = TweenInfo.new(distance / 300, Enum.EasingStyle.Linear)
                                    currentTween = TweenService:Create(rootPart, info, {CFrame = targetCFrame})
                                    currentTween:Play()
                                else
                                    if currentTween then currentTween:Cancel() end
                                    rootPart.CFrame = targetCFrame
                                    -- Gom quái lại gần điểm farm
                                    bringMobs(mobRoot)
                                end
                                
                                -- Tự động trang bị vũ khí và tấn công liên tục không cần click
                                local tool = char:FindFirstChildOfClass("Tool")
                                if tool then
                                    tool:Activate()
                                    if tool:FindFirstChild("RemoteEvent") then
                                        tool.RemoteEvent:FireServer(mobRoot.Position)
                                    end
                                else
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
