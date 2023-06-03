AnimateEvent = game.ReplicatedStorage.Events.Animate
AnimateEvent_L = game.ReplicatedStorage.Events.Animate_L
Player = game.Players.LocalPlayer
PlayerChar = Player.CharacterAdded:Wait() or Player.Character

Animation,NewAnimClip = nil

function Animate(AnimationID)
	NewAnimClip = PlayerChar:FindFirstChild("Animation")
	if NewAnimClip then

		NewAnimClip:Destroy()
	end

	if(Animation) then
		Animation:Stop()
	end

	if(AnimationID == "NONE") then
		return
	end

	NewAnimClip = Instance.new("Animation",PlayerChar)
	NewAnimClip.AnimationId = AnimationID

	local humanoid = PlayerChar:FindFirstChildOfClass("Humanoid")
	if humanoid then
		Animation = humanoid.Animator:LoadAnimation(NewAnimClip)
		Animation:Play()
	end
end

AnimateEvent_L.Event:Connect(Animate)
AnimateEvent.OnClientEvent:Connect(Animate)
