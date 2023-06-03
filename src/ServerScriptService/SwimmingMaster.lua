local StartEvent = game.ReplicatedStorage.Events.Swimming.Start
local ResetMinigame = game.ReplicatedStorage.Events.Swimming.Reset
local GaugeEvent = game.ReplicatedStorage.Events.Swimming.Gauge

local RequestBuffsEvent = game.ServerStorage.Events.RequestPlayerBuffs
local ModifyDataEvent = game.ServerStorage.Events.ModifyPlayerData

local MessageEvent = game.ReplicatedStorage.Events.PlayerMessage
local PlayerControls = game.ReplicatedStorage.Events.PlayerControls

local TeleportPart = workspace.Swimming.TeleportPart
local ScorePoint = game.Workspace.Swimming.Start.Position

local AnimateEvent = game.ReplicatedStorage.Events.Animate
local AnimationIDS = require(game.ReplicatedStorage.Tables.AnimationIDS)

local PlayerSwimBonus = {}

local PlayerDefaultSpeed = 16

local TimeLimit = 15

local SwimPoints = workspace.Swimming.SwimPoints:GetChildren()

function CalculateScore(Char)

	local Pos = Char.ScorePart.Position
	print(Pos)
	return (ScorePoint - Vector3.new(Pos.X,Pos.Y,math.abs(ScorePoint.Z-Pos.Z))).Magnitude
end

function Finished (Player)
	if(Player == nil) then
		return
	end

	local Score = 0
	local Char = Player.Character

	if Char then
		Score = math.round(CalculateScore(Char))
		Char.Humanoid.WalkSpeed = PlayerDefaultSpeed
		Char:PivotTo(TeleportPart:GetPivot())
		local ScorePart = Char:FindFirstChild("ScorePart")
		if ScorePart then
			ScorePart:Destroy()
		end
	end

	PlayerSwimBonus[Player.Name]["Bonus"] = 0
	ResetMinigame:FireClient(Player)
	PlayerControls:FireClient(Player,true)

	ModifyDataEvent:Invoke(Player,"ADD","Swimming Coins",Score)
	MessageEvent:FireClient(Player ,"Distance : "..Score.." Studs" ,Color3.new(0.054902, 0.517647, 0.827451),2,"LostItems")
	wait(1)
	MessageEvent:FireClient(Player ,"+"..Score.." Swimming Coins" ,Color3.new(1, 0.784314, 0.0117647),2,"Coins")

end

function ReduceGauge(Player)
	if PlayerSwimBonus[Player.Name] then
		return
	end
end

function AddGauge(Player)
	if not PlayerSwimBonus[Player.Name] then
		return
	end

	if PlayerSwimBonus[Player.Name]["Bonus"] + 10 < 100 then
		PlayerSwimBonus[Player.Name]["Bonus"] += 10
	else
		PlayerSwimBonus[Player.Name]["Bonus"] = 100
	end
	GaugeEvent:FireClient(Player,PlayerSwimBonus[Player.Name]["Bonus"])
end

function MovePlayer(Player)
	local Char = Player.Character
	if not Char then
		return
	end

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

	PlayerControls:FireClient(Player,false)

	Player.Character:PivotTo(SwimPoints[math.random(1,#SwimPoints)]:GetPivot())

	AnimateEvent:FireClient(Player,AnimationIDS.JumpIn)
	wait(1)
	AnimateEvent:FireClient(Player,AnimationIDS.Swim)

	StartEvent:FireClient(Player,TimeLimit)
	GaugeEvent:FireClient(Player,0)

	for i=0 , TimeLimit, 1 do
		local Speed = PlayerDefaultSpeed + PlayerSwimBonus[Player.Name]["BasePower"] + PlayerSwimBonus[Player.Name]["BasePower"] * 
			(PlayerSwimBonus[Player.Name]["Bonus"] + PlayerSwimBonus[Player.Name]["Multiplier"])

		print("Speed ", Speed)
		Char.Humanoid.WalkSpeed = Speed
		Char.Humanoid:Move(Vector3.new(0,0,-1))

		PlayerSwimBonus[Player.Name]["Bonus"] -= 10
		if PlayerSwimBonus[Player.Name]["Bonus"] < 0 then
			PlayerSwimBonus[Player.Name]["Bonus"] = 0
		end
		GaugeEvent:FireClient(Player,PlayerSwimBonus[Player.Name]["Bonus"])

		wait(1)
	end
	Finished(Player)
end

StartEvent.OnServerEvent:Connect(function(Player)

	if not PlayerSwimBonus[Player.Name] then
		PlayerSwimBonus[Player.Name] = {
			Bonus = 0,
			BasePower = 1,
			Multiplier = 1
		}
	end

	local Buffs = RequestBuffsEvent:Invoke(Player,{"Base Swim Speed","SWIM_SPEED_MULTIPLIER"})
	if Buffs == nil then
		return
	end

	if Buffs[1] ~= nil then PlayerSwimBonus[Player.Name]["BasePower"] = Buffs[1] end
	if Buffs[2] ~= nil then PlayerSwimBonus[Player.Name]["Multiplier"] = Buffs[2] end

	MovePlayer(Player)
end)

GaugeEvent.OnServerEvent:Connect(function(Player)
	AddGauge(Player)
end)