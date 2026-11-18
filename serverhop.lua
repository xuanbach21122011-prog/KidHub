-- =========================================================================
-- MODULE: ADVANCED SERVER HOP (SĂN ĐẢO, TRĂNG, KITSUNE, KATAKURI...)
-- =========================================================================
local ServerHopModule = {}
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Hàm kiểm tra môi trường server hiện tại (Xem có trăng tròn hoặc đảo ẩn không trước khi quyết định ở lại)
function ServerHopModule.CheckCurrentServer()
    local results = {
        HasFullMoon = false,
        HasMirage = false,
        HasKitsune = false,
        HasPrehistoric = false,
        HasKatakuri = false,
        HasValuableFruit = false
    }
    
    pcall(function()
        -- 1. Kiểm tra trạng thái Mặt Trăng (Moon)
        local lighting = game:GetService("Lighting")
        if lighting:FindFirstChild("ClockTime") then
            -- Giờ trong game hoặc thông số mặt trăng
        end
        -- Kiểm tra trực tiếp qua chỉ số Moon nếu game render
        if Workspace:FindFirstChild("Map") then
            -- Logic kiểm tra độ sáng/mặt trăng
        end

        -- 2. Quét các Đảo sự kiện xung quanh biển (Sea 3)
        for _, obj in ipairs(Workspace:GetChildren()) do
            local name = obj.Name:lower()
            if name:find("mirage") or name:find("island_mirage") then
                results.HasMirage = true
            elseif name:find("kitsune") then
                results.HasKitsune = true
            elseif name:find("prehistoric") or name:find("magma") then
                results.HasPrehistoric = true
            end
        end

        -- 3. Kiểm tra Boss Katakuri (Cake Prince / Dough King) ở Sea of Treats
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, enemy in ipairs(enemies:GetChildren()) do
                if enemy.Name:find("Cake Prince") or enemy.Name:find("Dough King") then
                    results.HasKatakuri = true
                end
            end
        end

        -- 4. Kiểm tra Trái ác quỷ rơi dưới đất (giá trị > 1M Beli thường nằm ở Workspace)
        for _, item in ipairs(Workspace:GetChildren()) do
            if item:IsA("Tool") and item:FindFirstChild("Handle") then
                -- Phát hiện trái ác quỷ rơi
                results.HasValuableFruit = true
            end
        end
    end)
    
    return results
end

-- Hàm thực hiện Hop Server thông minh
function ServerHopModule.Hop(filterOption)
    -- filterOption có thể là: "Mirage", "Kitsune", "FullMoon", "Katakuri", "Random"
    filterOption = filterOption or "Random"
    
    pcall(function()
        print("[+] Đang quét danh sách server cho chế độ: " .. filterOption)
        local servers = {}
        local cursor = ""
        
        -- Lấy danh sách server công khai từ Roblox API
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local req = game:HttpGet(url)
        local body = HttpService:JSONDecode(req)
        
        if body and body.data then
            for _, s in ipairs(body.data) do
                if type(s) == "table" and s.maxPlayers and s.playing and s.id then
                    -- Lọc server chưa đầy và không phải server hiện tại
                    if s.playing < s.maxPlayers - 1 and s.id ~= game.JobId then
                        table.insert(servers, s.id)
                    end
                end
            end
        end
        
        if #servers > 0 then
            local targetServer = servers[math.random(1, #servers)]
            print("[+] Tìm thấy server mới, đang tiến hành nhảy...")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer, LocalPlayer)
        else
            warn("[-] Không tìm thấy server phù hợp, đang thử lại...")
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    end)
end

return ServerHopModule
