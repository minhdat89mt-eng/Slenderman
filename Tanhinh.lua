-- ==========================================
-- SCRIPT TÀNG HÌNH + MENU HỒNG (GIỐNG ẢNH)
-- ==========================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- 1. TẠO GIAO DIỆN (GUI) GIỐNG TRONG ẢNH
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "InvisGui_ByGemini"

-- Khung chính màu hồng
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 105, 180) -- Màu hồng
MainFrame.Position = UDim2.new(0.5, -75, 0.3, 0)
MainFrame.Size = UDim2.new(0, 150, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = true -- Bạn có thể lấy chuột kéo bảng này đi chỗ khác

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0.3, 0)
Title.Text = "Hacker Menu =)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- Nút bấm bật/tắt
ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleBtn.Text = "TÀNG HÌNH: TẮT"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Màu đỏ lúc tắt
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold

-- 2. CHỨC NĂNG TÀNG HÌNH CHI TIẾT
local isInvis = false

local function makeInvis()
    local c = player.Character
    if not c then return end
    
    isInvis = not isInvis
    
    if isInvis then
        ToggleBtn.Text = "TÀNG HÌNH: BẬT"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Màu xanh lúc bật
        -- Làm tàng hình mọi bộ phận
        for _, part in pairs(c:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 1
            elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                part.Handle.Transparency = 1
            end
        end
        -- Ẩn tên hiển thị trên đầu
        if c:FindFirstChild("HumanoidRootPart") then
            c.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
    else
        ToggleBtn.Text = "TÀNG HÌNH: TẮT"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        -- Hiện lại nhân vật
        for _, part in pairs(c:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 0
            elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                part.Handle.Transparency = 0
            end
        end
        -- Hiện lại tên
        if c:FindFirstChild("HumanoidRootPart") then
            c.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(makeInvis)

-- 3. CHỨC NĂNG ANTI-KICK (NGĂN BỊ ĐUỔI KHỎI SERVER)
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then
        warn("Hệ thống vừa cố Kick bạn nhưng đã bị script chặn lại!")
        return nil
    end
    return old(self, ...)
end)

setreadonly(mt, true)

print("Script đã chạy thành công! Chúc bạn tàng hình vui vẻ.")
