local HurdleHitEvent = game.ServerStorage.Events.Running.TouchedHurdle
local FinishedEvent = game.ServerStorage.Events.Running.Finished
local JumpEvent = game.ReplicatedStorage.Events.Running.Jump

local StartEvent = game.ReplicatedStorage.Events.Running.Start
local UIText = game.ReplicatedStorage.Events.Running.UIText
local UIEvent = game.ReplicatedStorage.Events.Running.UIVisibility
local PlayerControls = game.ReplicatedStorage.Events.PlayerControls
local AnimateEvent = game.ReplicatedStorage.Events.Animate
local AnimationIDS = require(game.ReplicatedStorage.Tables.AnimationIDS)

--local WinnerBonusPrecentage = 50

local WaitingArea = workspace.Running.StartArea
local TrackPoints = workspace.Running.StartPoints:GetChildren()
local ScorePoint = workspace.Running.ScorePoint.Position
local StartTpPoint = workspace.Running.StartTeleport


local RequestBuffsEvent = game.ServerStorage.Events.RequestPlayerBuffs
local ModifyDataEvent = game.ServerStorage.Events.ModifyPlayerData

local MessageEvent = game.ReplicatedStorage.Events.PlayerMessage

local PlayerDefaultSpeed = 16
local RunMultiplier = 0.5

script.Move.Event:Connect(function(Char)
	for i=0, 3,1 do
		Char.Humanoid:Move(Vector3.new(1,0,0))
		wait(0.2)
	end
end)

function GetFreeSlot()
	for _,v in ipairs(TrackPoints) do
		if v.Name ~= "OC" then
			return v
		end
	end
	return nil
end

function Start(Player)
	
	local FreeSlot = GetFreeSlot()
	if  not FreeSlot then
		MessageEvent:FireClient(Player ,"All Tracks Are Taken, Please Wait For A Bit" ,Color3.new(1, 0, 0.0156863),2,"Error")
		return
	end
	
	UIEvent:FireClient(Player,"HIDE_START_BUTTON")
	local Char = Player.Character
	local ScorePart = Char:FindFirstChild("ScorePart")
	if not ScorePart then
		local New = Instance.new("Part",Char)
		New.CanCollide = false

		local Weld = Instance.new("Weld",New)
		Weld.Part0 = Char.HumanoidRootPart
		Weld.Part1 = New

		New.Name = "ScorePart"
		New.Transparency = 1
		New.CanTouch = false
	end
	TeleportToTrack(Player,FreeSlot)
end

StartEvent.OnServerEvent:Connect(Start)



function TeleportToTrack(Player,Track)
	print("tp")
	local Char = Player.Character
	if Char then
		PlayerControls:FireClient(Player,false)
		Track.Name = "OC"
		Char:PivotTo(Track:GetPivot())
		print(Char.Humanoid.WalkSpeed)
		Char.Humanoid.WalkSpeed = PlayerDefaultSpeed * (1 + RunMultiplier + (RequestBuffsEvent:Invoke(Player,{"RUN_SPEED_MULTIPLIER"})[1] or 0))
		Char.Humanoid.JumpHeight = 30
		Char.Humanoid:Move(Vector3.new(1,0,0))
	end

	AnimateEvent:FireClient(Player,AnimationIDS.RunStart)

	UIText:FireAllClients("Ready,")
	wait(1)
	UIText:FireAllClients("SET,")
	wait(1)
	UIText:FireAllClients("GO!!")
	wait(1)
	UIEvent:FireClient(Player,"SHOW_BUTTON")
	AnimateEvent:FireClient(Player,AnimationIDS.Run)		
	--wait animation

	local Char = Player.Character
	if Char then
		Char.Humanoid:Move(Vector3.new(1,0,0))
		print("Moving")
		script.Move:Fire(Char)
	end
	wait(1)
	Track.Name = "Part"
	
	for i=10,0,-1 do
		if not Char or not Char:FindFirstChild("ScorePart") then
			return
		end
		UIText:FireClient(Player,i)
		wait(1)
	end
	UIText:FireClient(Player,nil)
	Done(Player)
end

function RewardPlayer(Player)
	local Score = math.round(CalculateDistance(Player))
	ModifyDataEvent:Invoke(Player,"ADD","Running Coins",Score)
	MessageEvent:FireClient(Player ,"Distance : "..Score.." Studs" ,Color3.new(0.054902, 0.517647, 0.827451),2,"LostItems")
	MessageEvent:FireClient(Player ,"+"..Score.." Running Coins" ,Color3.new(1, 0.784314, 0.0117647),2,"Coins")
end

JumpEvent.OnServerEvent:Connect(function(Player)

	local Char = Player.Character
	if not Char then
		return
	end

	local Hum:Humanoid = Char.Humanoid
	Hum.Jump = true
end)

function Done(Player)
	RewardPlayer(Player)
	local Character = Player.Character
	if Character then
		PlayerControls:FireClient(Player,true)
		Character.Humanoid.WalkSpeed = PlayerDefaultSpeed
		Character.Humanoid.JumpHeight = 7.2
		Character:PivotTo(StartTpPoint:GetPivot())
		Character.Humanoid:Move(Vector3.new(0, 0, 0))

		UIEvent:FireClient(Player,"HIDE_BUTTON")
		PlayerControls:FireClient(Player,true)
	end
	UIText:FireClient(Player,nil)
	UIEvent:FireClient(Player,"SHOW_START_BUTTON")
end

function CalculateDistance(Player:Player)
	
	local Char = Player.Character
	if not Char then
		return 0
	end

	local ScorePart = Char:FindFirstChild("ScorePart")
	if not ScorePart then
		return 0
	end

	local Pos = ScorePart.Position
	
	print(Pos)
	
	local Z  = Pos.Z
	local MagToPoint = (ScorePoint - Vector3.new(Pos.X,Pos.Y,math.abs(ScorePoint.Z-Pos.Z))).Magnitude

	if ScorePart then
		ScorePart:Destroy()
	end

	return MagToPoint
end

local Debounces = {}

function HurdleHit(Player)
	
	if Debounces[Player] then
		return
	end
	
	Debounces[Player] = 1
	Done(Player)
	wait(1)
	Debounces[Player] = nil
end

HurdleHitEvent.Event:Connect(HurdleHit)

function Finished(Player)
	if Debounces[Player] then
		return
	end
	Debounces[Player] = 1
	Done(Player)
	wait(1)
	Debounces[Player] = nil
end

FinishedEvent.Event:Connect(Finished)