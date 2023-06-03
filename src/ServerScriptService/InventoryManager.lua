EquipmentData = require(game.ReplicatedStorage.Tables.Equipment)
PetsData = require(game.ReplicatedStorage.Tables.Pets)
BuffData = require(game.ReplicatedStorage.Tables.Buffs)
RarityData = require(game.ReplicatedStorage.Tables.Rarities)

LoadInventoryEvent = game.ServerStorage.Events.LoadInventory
AddToInventoryEvent = game.ServerStorage.Events.InventoryAdd

EquipmentPrefab = game.ReplicatedStorage.Prefabs.UI.EquipmentPrefab
BuffPrefab = game.ReplicatedStorage.Prefabs.UI.BuffPrefab

PetCollectionEvent = game.ReplicatedStorage.Events.SetupPetCollection

function LoadInventory(Player,PlayerData)
	
	--Load PerCollection Locally 
	PetCollectionEvent:FireClient(Player,PlayerData["Pets"])
	--Load Equipments
	local PlayerEquipment = PlayerData["Equipment"]
	local SlotData = {PlayerData["Slot_Tool"],PlayerData["Slot_Shoes"],PlayerData["Slot_Hats"],PlayerData["Slot_Other"]}
	
	local PlayerInventory = Player.PlayerGui:WaitForChild("Main"):WaitForChild("Inventory")
	local EquipmentHolder = PlayerInventory:WaitForChild("Equipment"):WaitForChild("EquipmentHolder")
	local Slots = EquipmentHolder.Parent:WaitForChild("SlotDisplay")
	local SlotUI = {Slots:WaitForChild("Slot_Tool"),Slots:WaitForChild("Slot_Shoes"),Slots:WaitForChild("Slot_Hat"),Slots:WaitForChild("Slot_Other")}
	
	for _,ItemName in ipairs(PlayerEquipment) do
		local EquipmentInfo = EquipmentData.Items[ItemName]
		if EquipmentInfo == nil then
			print(ItemName)
			continue
		end
		AddItem(Player,ItemName,EquipmentInfo,SlotData)
		
		for i, SlotItemName in ipairs(SlotData) do
			if SlotItemName == ItemName then
				SlotUI[i]:WaitForChild("ItemImage").Image = EquipmentInfo["EquipmentImage"]
				SlotUI[i].BackgroundColor3 = RarityData[EquipmentInfo["Rarity"]]["Color"]
				SlotUI[i]:WaitForChild("ItemName").Text = ItemName
			end
		end
		
	end
end

function AddItem(Player,ItemName,EquipmentInfo,CurrentNames)

	local NewPrefab = EquipmentPrefab:Clone()
	NewPrefab.Name = ItemName
	NewPrefab.ItemImage.Image = EquipmentInfo["EquipmentImage"]
	NewPrefab.ItemType.Value = EquipmentInfo["ItemType"]
	NewPrefab.SlotType.Value = EquipmentInfo["SlotType"]

	NewPrefab.EquipButton.Text = "Equip"
	NewPrefab.EquipButton.BackgroundColor3 = Color3.new(0.00392157, 0.8, 0.0313725)
	NewPrefab.BackgroundColor3 = RarityData[EquipmentInfo["Rarity"]]["Color"]
	
	if CurrentNames and table.find(CurrentNames,ItemName) then
		NewPrefab.EquipButton.Text = "Equipped"
		NewPrefab.EquipButton.BackgroundColor3 = Color3.new(0, 0.807843, 0.85098)
	end
	
	local PlayerInventory = Player.PlayerGui:WaitForChild("Main"):WaitForChild("Inventory")
	local EquipmentHolder = PlayerInventory:WaitForChild("Equipment"):WaitForChild("EquipmentHolder")
	NewPrefab.Parent = EquipmentHolder
end

AddToInventoryEvent.Event:Connect(function(Player,ItemName)

	local Data = EquipmentData.Items[ItemName]
	local Parent = nil
	if Data == nil then
		return
	end
	AddItem(Player,ItemName,Data)
end)

LoadInventoryEvent.Event:Connect(LoadInventory)