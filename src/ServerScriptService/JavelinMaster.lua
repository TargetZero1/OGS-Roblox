HitEvent = game.ServerStorage.Events.Javelin.JavHit
StartEvent = game.ServerStorage.Events.Javelin.JavStart
StartEvent_L = game.ReplicatedStorage.Events.StartThrowing
RequestBuffsEvent = game.ServerStorage.Events.RequestPlayerBuffs

RequestDataEvent = game.ServerStorage.Events.RequestPlayerData
ModifyDataEvent = game.ServerStorage.Events.ModifyPlayerData

MessageEvent = game.ReplicatedStorage.Events.PlayerMessage

ItemData = require(game.ReplicatedStorage.Tables.Equipment)

HitEvent.Event:Connect(function(PlayerName,Distance)
	local Player = game.Players:FindFirstChild(PlayerName)
	if(Player == nil) then
		return
	end

	local Score = math.round(Distance)
	ModifyDataEvent:Invoke(Player,"ADD","Javelin Coins",Score)
	MessageEvent:FireClient(Player ,"Distance : "..Score.." Studs" ,Color3.new(0.054902, 0.517647, 0.827451),2,"LostItems")
	wait(1)
	MessageEvent:FireClient(Player ,"+"..Score.." Javelin Coins" ,Color3.new(1, 0.784314, 0.0117647),2,"Coins")
end)

StartEvent_L.OnServerEvent:Connect(function(Player,Bonus)

	local PlayerWeapon = RequestDataEvent:Invoke(Player,"Slot_Tool")

	if not PlayerWeapon or not ItemData.Items[PlayerWeapon] or ItemData.Items[PlayerWeapon]["ItemType"] ~= "Javelin" then
		MessageEvent:FireClient(Player ,"Equip A Javelin To Participate!" ,Color3.new(1, 0, 0.0156863),2,"Error")
		return
	end

	local BasePower = 0
	local PowerMultiplier = 0

	local Buffs = RequestBuffsEvent:Invoke(Player,{"Base Power","JAVELIN_POWER_MULTIPLIER"})
	if Buffs == nil then
		return
	end

	if Buffs[1] ~= nil then BasePower = Buffs[1] end
	if Buffs[2] ~= nil then PowerMultiplier = Buffs[2] end

	local Power = BasePower + BasePower * (Bonus + PowerMultiplier)
	print("Server Received : " .. Bonus*100 .. "%")
	print("Base Power : "..BasePower)
	print("Power Multiplier : "..PowerMultiplier)
	print("Calculated Power : "..Power)
	print("-----------------------------------------------------")
	StartEvent:Fire(Player,Power)
end)