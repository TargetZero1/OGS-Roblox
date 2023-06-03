EquipItemEvent = game.ReplicatedStorage.Events.EquipItem

RequestDataEvent = game.ServerStorage.Events.RequestPlayerData
ModifyDataEvent = game.ServerStorage.Events.ModifyPlayerData

CalculateBuffsEvent = game.ServerStorage.Events.CalculatePlayerBuffs
EquipmentConfigerationEvent = game.ServerStorage.Events.EquipmentConfiguration

LoadEquipments = game.ServerStorage.Events.LoadEquipments
EquipmentData = require(game.ReplicatedStorage.Tables.Equipment)
RarityData = require(game.ReplicatedStorage.Tables.Rarities)

MessageEvent = game.ReplicatedStorage.Events.PlayerMessage

EquipmentFolder = game.ReplicatedStorage.Prefabs.Equipment

SlotDataPattern = {"Slot_Tool","Slot_Hat","Slot_Shoes","Slot_Other"}

function UnEquipItem(Player,ItemName,TargetSlot,Message)
	if TargetSlot then
		local SlotData = RequestDataEvent:Invoke(Player,TargetSlot)
		if SlotData == "NONE" then
			MessageEvent:FireClient(Player ,"Nothing To Unequip!" ,Color3.new(1, 0, 0),2,"Error")
			return
		end

		local Success =	ModifyDataEvent:Invoke(Player,"UPDATE",TargetSlot,"NONE")
		if Success then
			
			local CurrentPlace = Player:FindFirstChild("CurrentPlace")
			if CurrentPlace then
				ModifyDataEvent:Invoke(Player,"UPDATE",CurrentPlace.Value.."_"..TargetSlot,"NONE")
			end
			CalculateBuffsEvent:Invoke(Player,nil)
			local PlayerInventory = Player.PlayerGui:WaitForChild("Main"):WaitForChild("Inventory")
			local EquipmentHolder = PlayerInventory:WaitForChild("Equipment"):WaitForChild("EquipmentHolder")
			local Slots = EquipmentHolder.Parent:WaitForChild("SlotDisplay")
			local SlotUI = Slots:WaitForChild(TargetSlot)

			SlotUI:WaitForChild("ItemImage").Image = "http://www.roblox.com/asset/?id=6023565916"
			SlotUI:WaitForChild("ItemName").Text = "None"
			SlotUI.BackgroundColor3 = Color3.fromRGB(26, 105, 208)
			if Message == true then
			MessageEvent:FireClient(Player ,"Unequipped "..SlotData.." !" ,Color3.new(0.0666667, 0.0666667, 0.0666667),2,"Bag")
			end	
			EquipItemEvent:FireClient(Player,"",TargetSlot)
			EquipToChar(Player,false,nil,TargetSlot)
		end
	else
		local SlotData = RequestDataEvent:Invoke(Player,SlotDataPattern)
		local AlreadyEquipped = table.find(SlotData,ItemName)

		if AlreadyEquipped then
			UnEquipItem(Player,ItemName,SlotDataPattern[AlreadyEquipped])
			CalculateBuffsEvent:Invoke(Player,nil)
			MessageEvent:FireClient(Player ,"Unequipped "..ItemName.." !" ,Color3.new(0, 0, 0),2,"Bag")
			EquipItemEvent:FireClient(Player,"",TargetSlot)
			EquipToChar(Player,false,nil,TargetSlot)
			return
		end
	end
end

function EquipItem(Player,ItemName,Message)

	local Equipment = RequestDataEvent:Invoke(Player,"Equipment")
	if table.find(Equipment,ItemName) == nil then
		MessageEvent:FireClient(Player ,"You Dont Own That Item To Equip!" ,Color3.new(1, 0, 0),2,"Error")
		return
	end

	local SlotData = RequestDataEvent:Invoke(Player,SlotDataPattern)

	local AlreadyEquipped = table.find(SlotData,ItemName)

	if AlreadyEquipped then
		UnEquipItem(Player,ItemName,SlotDataPattern[AlreadyEquipped],Message)
		return
	end

	local TargetSlot = EquipmentData.Items[ItemName]["SlotType"]

	local CurrentItem = SlotData[table.find(SlotDataPattern,TargetSlot)]
	if CurrentItem ~= "NONE" then
		UnEquipItem(Player,CurrentItem,TargetSlot,Message)
	end

	local Success =	ModifyDataEvent:Invoke(Player,"UPDATE",TargetSlot,ItemName)
	if Success then
		
		local CurrentPlace = Player:FindFirstChild("CurrentPlace")
		if CurrentPlace then
			ModifyDataEvent:Invoke(Player,"UPDATE",CurrentPlace.Value.."_"..TargetSlot,ItemName)
		end
		
		CalculateBuffsEvent:Invoke(Player,nil)
		local PlayerInventory = Player.PlayerGui:WaitForChild("Main"):WaitForChild("Inventory")
		local EquipmentHolder = PlayerInventory:WaitForChild("Equipment"):WaitForChild("EquipmentHolder")
		local Slots = EquipmentHolder.Parent:WaitForChild("SlotDisplay")
		local SlotUI = Slots:WaitForChild(TargetSlot)

		SlotUI:WaitForChild("ItemImage").Image = EquipmentData.Items[ItemName]["EquipmentImage"]
		SlotUI:WaitForChild("ItemName").Text = ItemName
		SlotUI.BackgroundColor3 = RarityData[EquipmentData.Items[ItemName]["Rarity"]]["Color"]
		if Message == true then
			MessageEvent:FireClient(Player ,"Equipped "..ItemName.." !" ,Color3.new(0.219608, 0.219608, 0.219608),2,"Bag")
		end
		EquipItemEvent:FireClient(Player,ItemName,TargetSlot)
		EquipToChar(Player,true,ItemName,TargetSlot)
	end
end

function EquipToChar(Player,IsEquip,ItemName,Slot)

	local PlayerChar = workspace:WaitForChild(Player.Name)

	local CurrentItem = PlayerChar:FindFirstChild(Slot)
	if CurrentItem then
		CurrentItem:Destroy()
	end

	if IsEquip == false then return end

	local Equipment = EquipmentFolder:FindFirstChild(ItemName)

	if not Equipment then return end

	local NewEquipment  = Equipment:Clone()
	NewEquipment.Parent = PlayerChar
	NewEquipment.Name = Slot

	if Equipment:IsA("Tool") then
		local Humanoid = PlayerChar:WaitForChild("Humanoid")
		Humanoid:EquipTool(NewEquipment)
	end
end

function ChangePlayerSlotConfig(Player,CurrentPlace)
	local AllowedConfigs = {"Javelin","Swimming","Running","Other"}

	if CurrentPlace == "Lobby" then
		ModifyDataEvent:Invoke(Player,"UPDATE",SlotDataPattern,{"NONE","NONE","NONE","NONE"})
		
		CalculateBuffsEvent:Invoke(Player,nil)
		
		local PlayerInventory = Player.PlayerGui:WaitForChild("Main"):WaitForChild("Inventory")
		local EquipmentHolder = PlayerInventory:WaitForChild("Equipment"):WaitForChild("EquipmentHolder")
		local Slots = EquipmentHolder.Parent:WaitForChild("SlotDisplay")
		for _,TargetSlot in ipairs(SlotDataPattern) do
			local SlotUI = Slots:WaitForChild(TargetSlot)
			SlotUI:WaitForChild("ItemImage").Image = "http://www.roblox.com/asset/?id=6023565916"
			SlotUI:WaitForChild("ItemName").Text = "None"
			SlotUI.BackgroundColor3 = Color3.fromRGB(26, 105, 208)
			EquipItemEvent:FireClient(Player,"",TargetSlot)
			EquipToChar(Player,false,nil,TargetSlot)
		end
		MessageEvent:FireClient(Player ,"Equipment Configuration Changed To None" ,Color3.new(0.552941, 0.552941, 0.552941),2,"")
		
	elseif table.find(AllowedConfigs,CurrentPlace) then
		local ConfigData = RequestDataEvent:Invoke(Player,{
			CurrentPlace.."_"..SlotDataPattern[1],
			CurrentPlace.."_"..SlotDataPattern[2],
			CurrentPlace.."_"..SlotDataPattern[3],
			CurrentPlace.."_"..SlotDataPattern[4],
		})
		
		for _, ItemName in ipairs(ConfigData) do
			if ItemName == nil or ItemName == "NONE" then
				continue
			end
			EquipItem(Player,ItemName,false)	
		end
		MessageEvent:FireClient(Player ,"Equipment Configuration Changed To "..CurrentPlace ,Color3.new(0.552941, 0.552941, 0.552941),2,"")
	end
end

function CharAdded(Char)

	local Player = game.Players:FindFirstChild(Char.Name)
	if not Player then return end

	local SlotData = RequestDataEvent:Invoke(Player,SlotDataPattern)

	for i, ItemName in SlotData do
		EquipToChar(Player,true,ItemName,SlotDataPattern[i])
	end
end

LoadEquipments.Event:Connect(function(Player,SlotData)
	for i, ItemName in SlotData do
		EquipToChar(Player,true,ItemName,SlotDataPattern[i])
	end
	Player.CharacterAdded:Connect(CharAdded)
end)

EquipItemEvent.OnServerEvent:Connect(function(Player,ItemName)
	
	local CurrentPlace = Player:FindFirstChild("CurrentPlace")
	if CurrentPlace and CurrentPlace.Value == "Lobby" then
		MessageEvent:FireClient(Player ,"You Can't Equip Items In The Lobby!" ,Color3.new(1, 0, 0.0156863),2,"Error")
		return
	end
	
	EquipItem(Player,ItemName,true)
end)
EquipmentConfigerationEvent.Event:Connect(ChangePlayerSlotConfig)