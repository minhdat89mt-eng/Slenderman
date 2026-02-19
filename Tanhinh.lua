-- ==========================================
-- SCRIPT TÀNG HÌNH MỜ + GUI RAINBOW RGB
-- ==========================================

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

-- 1. TẠO GIAO DIỆN (GUI)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "RainbowMenu"
MainFrame.Size = UDim2.new(0, 180, 0, 110)
MainFrame.Position = UDim2.new(0.5, -90, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Nền trắng
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 

-- Tạo viền bảy sắc cầu vồng (RGB Border)
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 4
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Nút bấm
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.85, 0, 0.6, 0)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.2, 0)
ToggleBtn.Text = "TÀNG HÌNH: TẮT"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Chữ đen
ToggleBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16

-- 2. HIỆU ỨNG VIỀN CẦU VỒNG (RGB)
spawn(function()
    local counter = 0
    while wait() do
        local color = Color3.fromHSV(counter, 1, 1)
        UIStroke.Color = color
        counter = counter + 0.01
        if counter >= 1 then counter = 0 end
    end
end)

-- 3. LOGIC TÀNG HÌNH & ĐI XUYÊN (NOCLIP)
local isActive = false
local noclipConn

ToggleBtn.MouseButton1Click:Connect(function()
    isActive = not isActive
    local char = player.Character
    if not char then return end

    if isActive then
        ToggleBtn.Text = "TÀNG HÌNH: BẬT"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
        
        -- Làm mờ 70% để bạn vẫn thấy đường nhưng nick khác khó thấy
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = 0.7 
            elseif v:IsA("Accessory") and v:FindFirstChild("Handle") then
                v.Handle.Transparency = 0.7
            end
        end

        -- Ẩn tên để nick clone không soi được
        if char:FindFirstChild("Humanoid") then
            char.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end

        -- Đi xuyên người (Noclip)
        noclipConn = runService.Stepped:Connect(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        ToggleBtn.Text = "TÀNG HÌNH: TẮT"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        
        if noclipConn then noclipConn:Disconnect() end
        player:LoadCharacter() -- Reset nhân vật về bình thường
    end
end)
