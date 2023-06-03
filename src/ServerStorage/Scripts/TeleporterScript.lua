TransitionEvent = game.ReplicatedStorage.Events.StartTransition
Trigger = script.Parent.Trigger
Destination = script.Parent.Destination
DestinationName = script.Parent.DesinationName.Value

EquipmentConfigerationEvent = game.ServerStorage.Events.EquipmentConfiguration

PlayerDebounces = {}

Trigger.Touched:Connect(function(TouchedPart)
	local Player = game.Players:FindFirstChild(TouchedPart.Parent.Name)
	if(Player == nil) then return end
	
	if PlayerDebounces[Player.Name] and PlayerDebounces[Player.Name] == true then
		return
	end
	PlayerDebounces[Player.Name] = true
	TransitionEvent:FireClient(Player,DestinationName,2)
	wait(0.5)
	local Character = TouchedPart.Parent
	Character:PivotTo(Destination:GetPivot())
	
	local CurrentPlace = Player:FindFirstChild("CurrentPlace")
	if CurrentPlace then
		CurrentPlace.Value = DestinationName
		EquipmentConfigerationEvent:Fire(Player,DestinationName)
	end
	PlayerDebounces[Player.Name] = false
end)