FollowEvent = game.ReplicatedStorage.Events.FollowObject

CamEvent = game.ReplicatedStorage.Events.Camera
CamEvent_L = game.ReplicatedStorage.Events.Camera_L

ResetPlayer = game.ReplicatedStorage.Events.ResetPlayerStuff
Camera = workspace.CurrentCamera
Player = game.Players.LocalPlayer
PlayerChar = Player.Character or Player.CharacterAdded:Wait()

PlayerControls = require(Player.PlayerScripts.PlayerModule):GetControls()


function ResetCamera()
	ResetPlayer:Fire()
	Camera.CameraSubject = PlayerChar
	Camera.CameraType = Enum.CameraType.Custom
	PlayerControls:Enable()
end

function FollowObject(Object)
	PlayerControls:Disable()
	Camera.CameraType = Enum.CameraType.Follow
	Camera.CameraSubject = Object
	while Object.Parent do
		wait()
	end
	ResetCamera()
end

function LookAtStatic(Position,LookAtPosition)
	Camera.CameraType = Enum.CameraType.Fixed
	Camera.CFrame = Position --  * CFrame.lookAt(Camera.CFrame.Position,LookAtPosition)
	Camera.CameraSubject = PlayerChar
end

function CameraController(Action, ActionData)
	if Action == "RESET" then
		return ResetCamera()
	elseif Action == "FOLLOW" then
		return FollowObject(ActionData)
	elseif Action == "LOOKAT_STATIC" then
		return LookAtStatic(ActionData[1],ActionData[2])
	end
end

FollowEvent.OnClientEvent:Connect(FollowObject)

CamEvent.OnClientEvent:Connect(CameraController)
CamEvent_L.Event:Connect(CameraController)