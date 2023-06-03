local HurdleTouchEvent = game.ServerStorage.Events.Running.TouchedHurdle
local MessageEvent = game.ReplicatedStorage.Events.PlayerMessage
local DebounceList = {}


script.Parent.Touched:Connect(function(TouchPart)
	local Player = game.Players:FindFirstChild(TouchPart.Parent.Name)
	local Humanoid:Humanoid = TouchPart.Parent:FindFirstChild("Humanoid")
	if Player and Humanoid and not DebounceList[Player] then
		Humanoid.WalkSpeed = Humanoid.WalkSpeed * 0.8
		DebounceList[Player] = 1
		MessageEvent:FireClient(Player ,"-20% Speed" ,Color3.new(0.054902, 0.517647, 0.827451),2,"LostItems")
		wait(3)
		DebounceList[Player] = nil
	end
end)