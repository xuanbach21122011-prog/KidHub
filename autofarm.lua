-- =========================================================================
-- MODULE: AUTO FARM & COMBAT LOGIC
-- =========================================================================
local AutoFarmModule = {}
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

getgenv().FarmConfig = {
    Enabled = false,
    BringMob = true,
    FastAttack = true,
    AutoHaki = true,
    SafeHeight = 28,
    SafeDistance = 8
}

-- 1. Logic tự động bật Haki
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if getgenv().FarmConfig.Enabled and getgenv().FarmConfig.AutoHaki and LocalPlayer.Character then
                local baf = LocalPlayer.Character:FindFirstChild("HasBuso")
                if not baf then
                    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                    if remotes and remotes:FindFirstChild("CommF_") then
                        remotes.CommF_:InvokeServer("Buso")
                    end
                end
            end
        end)
    end
end)

-- 2. Logic Gom Quái (Bring Mob)
RunService.Stepped:Connect(function()
    pcall(function()
        if getgenv().FarmConfig.Enabled and getgenv().FarmConfig.BringMob then
            local char = LocalPlayer.Character
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local enemies = Workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, enemy in ipairs(enemies:GetChildren()) do
                        local eRoot = enemy:FindFirstChild("HumanoidRootPart")
                        local eHum = enemy:FindFirstChildOfClass("Humanoid")
                        if eRoot and eHum and eHum.Health > 0 then
                            if (eRoot.Position - rootPart.Position).Magnitude < 400 then
                                eRoot.CFrame = rootPart.CFrame * CFrame.new(0, -4, -3)
                                eHum.PlatformStand = true
                            end
                        end
                    end
                end
            end
        end
    end)
end)

-- 3. Logic Farm vị trí an toàn trên đầu quái
RunService.RenderStepped:Connect(function()
    pcall(function()
        if getgenv().FarmConfig.Enabled then
            local char = LocalPlayer.Character
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local enemies = Workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, enemy in ipairs(enemies:GetChildren()) do
                        local eRoot = enemy:FindFirstChild("HumanoidRootPart")
                        local eHum = enemy:FindFirstChildOfClass("Humanoid")
                        if eRoot and eHum and eHum.Health > 0 then
                            rootPart.CFrame = eRoot.CFrame * CFrame.new(0, getgenv().FarmConfig.SafeHeight, getgenv().FarmConfig.SafeDistance)
                            rootPart.Velocity = Vector3.new(0, 0, 0)
                            break
                        end
                    end
                end
            end
        end
    end)
end)

-- 4. Fast Attack vũ khí
task.spawn(function()
    while task.wait(0.04) do
        pcall(function()
            if getgenv().FarmConfig.Enabled and getgenv().FarmConfig.FastAttack then
                local char = LocalPlayer.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end
        end)
    end
end)

return AutoFarmModule
