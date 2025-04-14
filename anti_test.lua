local VirtualUser = cloneref(game:GetService('VirtualUser'))
local Players     = cloneref(game:GetService('Players'))

local LocalPlayer = Players.LocalPlayer


LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.zero)
end)
