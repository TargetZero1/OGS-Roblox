local CheckSlotEvent = game.ReplicatedStorage.Events.CheckSlotType
local RequestEvent = game.ServerStorage.Events.RequestPlayerData
local ItemsData = require(game.ReplicatedStorage.Tables.Equipment)

CheckSlotEvent.OnServerInvoke = function(Player,Slot,Type)
	local PlayerSlotData = RequestEvent:Invoke(Player,Slot)
	if not PlayerSlotData or PlayerSlotData == "NONE" then
		return false
	end
	
	local ItemData = ItemsData.Items[PlayerSlotData]
	if not ItemData or not ItemData["ItemType"] or ItemData["ItemType"] ~= Type then
		return false
	end
	return true
end
