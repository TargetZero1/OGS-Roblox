CalculateBuffsEvent = game.ServerStorage.Events.CalculatePlayerBuffs
RequestBuffsEvent = game.ServerStorage.Events.RequestPlayerBuffs
RequestDataEvent = game.ServerStorage.Events.RequestPlayerData

EquipmentData = require(game.ReplicatedStorage.Tables.Equipment)
BuffData = require(game.ReplicatedStorage.Tables.Buffs)

SlotDataPattern = {"Slot_Tool","Slot_Hat","Slot_Shoes","Slot_Other"}
PlayerBuffs = {}

function Calculate(Player,SlotData)
	
	if SlotData == nil then
		SlotData = RequestDataEvent:Invoke(Player,SlotDataPattern)
	end
	
	PlayerBuffs[Player.Name] = {}
	
	for _,ItemName in ipairs(SlotData) do
		if ItemName == "NONE" then
			continue
		end
		
		local ItemInfo = EquipmentData.Items[ItemName]
		if not ItemInfo then continue end
		
		local BaseAttribute = EquipmentData.GetBaseAttributeName(ItemName)
		if BaseAttribute ~= "" then
			PlayerBuffs[Player.Name][BaseAttribute] = ItemInfo["BaseAttribute"]
		end
		
		local Buffs = ItemInfo["Buffs"]
		if not Buffs or #Buffs == 0 then continue end
		
		for _, BuffData in ipairs(Buffs) do
			if PlayerBuffs[Player.Name][BuffData[1]] then
				PlayerBuffs[Player.Name][BuffData[1]] += BuffData[2]
				continue
			end
			PlayerBuffs[Player.Name][BuffData[1]] = BuffData[2]
		end
		
	end
	print(PlayerBuffs)
end

function Request(Player, Buffs)
	if PlayerBuffs[Player.Name] == nil then
		return
	end
	
	local Out = {}
	
	for _,Buff in ipairs(Buffs) do
		if PlayerBuffs[Player.Name][Buff] then
			table.insert(Out,PlayerBuffs[Player.Name][Buff])
		else
			table.insert(Out,nil)
		end
	end
	return Out
end


RequestBuffsEvent.OnInvoke = Request
CalculateBuffsEvent.OnInvoke = Calculate
