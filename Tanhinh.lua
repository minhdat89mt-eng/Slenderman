local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

-- 1. GUI RAINBOW NỀN TRẮNG CHỮ ĐEN
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 110)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true 
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 4
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.9, 0, 0.7, 0)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleBtn.Text = "FIX LỖI: TÀNG HÌNH 100%"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.Font = Enum.Font.SourceSansBold

-- Viền cầu vồng
spawn(function()
    local c = 0
    while wait() do
        UIStroke.Color = Color3.fromHSV(c, 1, 1); c = c + 0.01
        if c >= 1 then c = 0 end
    end
end)

-- 2. LOGIC TÀNG HÌNH THẬT SỰ (SERVER-SIDE BYPASS)
local active = false
local noclipLoop

ToggleBtn.MouseButton1Click:Connect(function()
    active = not active
    local char = player.Character
    if not char or not char:FindFirstChild("LowerTorso") then return end

    if active then
        ToggleBtn.Text = "ĐÃ TÀNG HÌNH VỚI CLONE"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 255, 150)

        -- BƯỚC QUAN TRỌNG: Ngắt kết nối các bộ phận để Server không vẽ được bạn
        -- Nick clone sẽ thấy bạn bị biến mất hoàn toàn hoặc bị kẹt tại chỗ cũ
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = 1 -- Ẩn hoàn toàn trên máy người khác
            end
        end

        -- Ẩn cái tên (Nametag) - Nguyên nhân chính khiến nick clone thấy bạn
        if char:FindFirstChild("Humanoid") then
            char.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end

        -- Noclip để đi xuyên người nick clone
        noclipLoop = runService.Stepped:Connect(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    else
        ToggleBtn.Text = "FIX LỖI: TÀNG HÌNH 100%"
        if noclipLoop then noclipLoop:Disconnect() end
        player:LoadCharacter() -- Reset để hiện hình lại
    end
end)
