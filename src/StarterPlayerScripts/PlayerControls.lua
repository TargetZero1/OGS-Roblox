PlayerControlsEvent = game.ReplicatedStorage.Events.PlayerControls
PlayerControlsEvent_L = game.ReplicatedStorage.Events.PlayerControls_L

Player = game.Players.LocalPlayer
PlayerChar = Player.CharacterAdded:Wait() or Player.Character

PlayerControls = require(Player.PlayerScripts.PlayerModule):GetControls()


function SetPlayerControls(IsOn)
	if IsOn then
		PlayerControls:Enable()
	else
		PlayerControls:Disable()
	end
end

PlayerControlsEvent.OnClientEvent:Connect(SetPlayerControls)
PlayerControlsEvent_L.Event:Connect(SetPlayerControls)
