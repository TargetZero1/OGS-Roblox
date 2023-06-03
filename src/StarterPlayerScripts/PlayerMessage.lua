wait(0.5)
local Player = game.Players.LocalPlayer
local MessagePanel = game.Players[Player.Name]:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("MessagePanel")

local MessagePrefab = game.ReplicatedStorage.Prefabs.UI.MessagePrefab
local MessageEvent = game.ReplicatedStorage.Events.PlayerMessage
local MessageEvent_L = game.ReplicatedStorage.Events.PlayerMessage_L

Sounds = 
	{
		Bag = "rbxassetid://9114741612",
		Coins = "rbxassetid://607662191",
		LevelUp = "rbxassetid://3120909354",
		XP = "rbxassetid://1517459587",
		ToolBreak = "rbxassetid://315912428",
		Error = "rbxassetid://3932627155",
		LostItems = "rbxassetid://8452018962",
		Success = "rbxassetid://1347153667",
		QuestReceive = "rbxassetid://1453100688",
		SubQuestDone = "rbxassetid://3270235822",
		QuestHandIn = "rbxassetid://4612373756",
	}

function _Message(Message,MessageColor,LifeTime,SoundID)
	
	local NewMessage = MessagePrefab:Clone()
	NewMessage.Parent = MessagePanel
	NewMessage.Text = Message
	
	if(typeof(MessageColor) == "ColorSequence") then
		NewMessage.UIGradient.Enabled = true
		NewMessage.UIGradient.Color = MessageColor
	else
		NewMessage.BackgroundColor3 = MessageColor
	end

	local NewSound = Instance.new("Sound")	
	if game.Workspace[Player.Name] and SoundID ~= nil then
		NewSound.Parent = game.Workspace[Player.Name]
		
		if(Sounds[SoundID]) then
			NewSound.SoundId = Sounds[SoundID]
		else
			NewSound.SoundId = SoundID
		end
		
		
		NewSound:Play()
	end
	local willTween = NewMessage:TweenSizeAndPosition(UDim2.new(1.1,0,1.1,0),UDim2.new(1,0,1,0),Enum.EasingDirection.Out,Enum.EasingStyle.Elastic,.5)
	wait(LifeTime)
	NewSound:Destroy()
	NewMessage:Destroy()
end

MessageEvent.OnClientEvent:Connect(function(Message,MessageColor,LifeTime,SoundID)
	_Message(Message,MessageColor,LifeTime,SoundID)
end)

MessageEvent_L.Event:Connect(function(Message,MessageColor,LifeTime,SoundID)
	_Message(Message,MessageColor,LifeTime,SoundID)
end)