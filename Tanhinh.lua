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
ToggleBtn.Text = "KÍCH HOẠT SIÊU TÀNG HÌNH"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.Font = Enum.Font.SourceSansBold

-- Hiệu ứng viền cầu vồng
spawn(function()
    local c = 0
    while wait() do
        UIStroke.Color = Color3.fromHSV(c, 1, 1)
        c = c + 0.01
        if c >= 1 then c = 0 end
    end
end)

-- 2. LOGIC TÀNG HÌNH & ANTI-DIE
local active = false
local fakeFloor
local mainLoop

ToggleBtn.MouseButton1Click:Connect(function()
    active = not active
    local char = player.Character
    if not char then return end

    if active then
        ToggleBtn.Text = "ĐANG TÀNG HÌNH (AN TOÀN)"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 255, 150)

        -- Tạo đế bảo vệ cách mặt đất 50m
        fakeFloor = Instance.new("Part")
        fakeFloor.Size = Vector3.new(10000, 1, 10000)
        fakeFloor.Position = char.HumanoidRootPart.Position - Vector3.new(0, 50, 0)
        fakeFloor.Anchored = true
        fakeFloor.Transparency = 1 
        fakeFloor.Parent = workspace

        -- Dịch chuyển nhân vật
        char.HumanoidRootPart.CFrame = fakeFloor.CFrame + Vector3.new(0, 5, 0)

        -- Vòng lặp khóa trạng thái
        mainLoop = runService.RenderStepped:Connect(function()
            if char and char:FindFirstChild("Humanoid") then
                -- Anti-Die: Khóa máu để không bao giờ chết
                char.Humanoid.Health = char.Humanoid.MaxHealth
                
                -- Làm mờ nhân vật 70%
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") or v:IsA("Decal") then
                        v.Transparency = 0.7
                        v.CanCollide = false
                    end
                end
                
                -- Giữ Camera cho bạn quan sát mặt đất
                workspace.CurrentCamera.CameraSubject = char.Humanoid
            end
        end)
    else
        ToggleBtn.Text = "KÍCH HOẠT SIÊU TÀNG HÌNH"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        
        if mainLoop then mainLoop:Disconnect() end
        if fakeFloor then fakeFloor:Destroy() end
        player:LoadCharacter() 
    end
end)
