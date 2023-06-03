DataStore= game:GetService("DataStoreService"):GetDataStore("PlayerData4")

RequestDataEvent = game.ServerStorage.Events.RequestPlayerData
ModifyDataEvent = game.ServerStorage.Events.ModifyPlayerData

LoadInventoryEvent = game.ServerStorage.Events.LoadInventory
LoadEquipments = game.ServerStorage.Events.LoadEquipments
CalculateBuffsEvent = game.ServerStorage.Events.CalculatePlayerBuffs

DataDisplayEvent = game.ReplicatedStorage.Events.DataDisplay

SaveData = false

PlayerCurrentSaveData = {}


function Load(Player)
	local PlayerUserID = "Player_"..Player.UserId
	local Data = DataStore:GetAsync(PlayerUserID)
	local DoneLoading = Player:FindFirstChild("DoneLoading")

	PlayerCurrentSaveData[Player.Name]= 
		{
			["Medals"] = 1000,
			["Javelin Coins"] = 0,
			["Swimming Coins"] = 0,
			["Running Coins"] = 0,
			["PetLimit"] = 3,

			["Equipment"] = {"Basic Javelin", "Basic Shoes", "Basic Flippers","Ultra Flippers" ,
				"Wind Breaker","Golden Seeker","Basic Hat","Brainer"},			

			["Slot_Tool"]   = "NONE",	
			["Slot_Shoes"]  = "NONE",
			["Slot_Hat"]    = "NONE",
			["Slot_Other"]  = "NONE",

			["OtherItems"] = {},

			["Javelin_Slot_Tool"] = "Basic Javelin",
			["Javelin_Slot_Shoes"]  = "NONE",
			["Javelin_Slot_Hat"]    = "NONE",
			["Javelin_Slot_Other"]  = "NONE",

			["Running_Slot_Tool"] = "NONE",
			["Running_Slot_Shoes"]  = "NONE",
			["Running_Slot_Hat"]    = "NONE",
			["Running_Slot_Other"]  = "NONE",

			["Swimming_Slot_Tool"] = "NONE",
			["Swimming_Slot_Shoes"]  = "NONE",
			["Swimming_Slot_Hat"]    = "NONE",
			["Swimming_Slot_Other"]  = "NONE",

			["Other_Slot_Tool"] = "NONE",
			["Other_Slot_Shoes"]  = "NONE",
			["Other_Slot_Hat"]    = "NONE",
			["Other_Slot_Other"]  = "NONE",

			["Pets"] = {"Swift Dog"},
			["CurrentlyEquippedPets"] = {},
		}

	if Data then
		print("DataFound")
		for  Key,Value in pairs(Data) do
			PlayerCurrentSaveData[Player.Name][Key] = Value
		end
		print(Player.Name .. " - Loading Done")
	else
		print("DataNotFound")
	end
	DoneLoading.Value = true
	DataDisplayEvent:FireClient(Player,"Medals",PlayerCurrentSaveData[Player.Name]["Medals"])
	LoadEquipments:Fire(Player,
		{PlayerCurrentSaveData[Player.Name]["Slot_Tool"],PlayerCurrentSaveData[Player.Name]["Slot_Hat"],
			PlayerCurrentSaveData[Player.Name]["Slot_Shoes"],PlayerCurrentSaveData[Player.Name]["Slot_Other"]}
	)
	CalculateBuffsEvent:Invoke(Player,
		{PlayerCurrentSaveData[Player.Name]["Slot_Tool"],PlayerCurrentSaveData[Player.Name]["Slot_Hat"],
			PlayerCurrentSaveData[Player.Name]["Slot_Shoes"],PlayerCurrentSaveData[Player.Name]["Slot_Other"]}
	)

	local NewVar = Instance.new("StringValue",Player)
	NewVar.Name = "CurrentPlace"
	NewVar.Value = "Lobby"

	LoadInventoryEvent:Fire(Player,PlayerCurrentSaveData[Player.Name])
end

function Save(Player)
	if(Player:FindFirstChild("DoneLoading") == nil or Player["DoneLoading"].Value == false) then
		print("Didn't Save, DataLoss Prevented "..Player.Name)
		return
	end

	PlayerCurrentSaveData[Player.Name]["Slot_Tool"] = ""
	PlayerCurrentSaveData[Player.Name]["Slot_Hat"] = ""
	PlayerCurrentSaveData[Player.Name]["Slot_Other"] = ""
	PlayerCurrentSaveData[Player.Name]["Slot_Shoes"] = ""

	print(PlayerCurrentSaveData[Player.Name])

	if(PlayerCurrentSaveData=={}) then
		print("Nothing To Save")
		return
	end

	--if SaveData == false then
	--	return
	--end

	--local Data = PlayerCurrentSaveData[Player.Name]

	--local success,err = pcall(function()
	--	local PlayerUserID = "Player_"..Player.UserId
	--	DataStore:UpdateAsync(PlayerUserID, function(oldvalue)			
	--		if oldvalue ~= Data then
	--			print("Saved Data")
	--			return Data
	--		else
	--			print("Data Is The Same And Did Not Save")
	--		end
	--	end)
	--end)
	--if not success then
	--	print(err)
	--	warn("Couldnt Save Data")
	--end
end

function RequestData(Player,Keys)
	if(Player:FindFirstChild("DoneLoading") == nil or Player["DoneLoading"].Value == false) then
		return nil
	end

	if type(Keys) == "table" then
		local Out = {}
		for _,Key in ipairs(Keys) do
			if PlayerCurrentSaveData[Player.Name][Key] then
				local RequestedData   = PlayerCurrentSaveData[Player.Name][Key]
				if RequestedData then
					table.insert(Out,RequestedData)
				end
			else
				table.insert(Out,nil)
			end
		end
		return Out
	end

	if PlayerCurrentSaveData[Player.Name][Keys] then
		local RequestedData   = PlayerCurrentSaveData[Player.Name][Keys]
		if RequestedData then
			return RequestedData
		end
	else
		return nil
	end
end

function ModifyValue(Player,Action,Key,Value)
	if type(PlayerCurrentSaveData[Player.Name][Key]) == "table" then
		if Action == "ADD" then
			table.insert(PlayerCurrentSaveData[Player.Name][Key], Value)
			DataDisplayEvent:FireClient(Player,Key,PlayerCurrentSaveData[Player.Name][Key])
			return true
		elseif(Action == "REMOVE") then
			local Pos = table.find(PlayerCurrentSaveData[Player.Name][Key],Value)
			if( Pos == nil) then
				print("Couldn't Find")
				return false
			end
			table.remove(PlayerCurrentSaveData[Player.Name][Key], Pos)
			DataDisplayEvent:FireClient(Player,Key,PlayerCurrentSaveData[Player.Name][Key])
			return true
		elseif(Action == "UPDATE") then
			PlayerCurrentSaveData[Player.Name][Key] = Value
			DataDisplayEvent:FireClient(Player,Key,PlayerCurrentSaveData[Player.Name][Key])
		end
	else
		if(Action == "ADD") then
			PlayerCurrentSaveData[Player.Name][Key] += Value
			DataDisplayEvent:FireClient(Player,Key,PlayerCurrentSaveData[Player.Name][Key])
			return true
		elseif(Action == "REMOVE") then
			if(PlayerCurrentSaveData[Player.Name][Key] >= Value) then
				PlayerCurrentSaveData[Player.Name][Key] -= Value
				DataDisplayEvent:FireClient(Player,Key,PlayerCurrentSaveData[Player.Name][Key])
				return true
			end
			return false
		else
			PlayerCurrentSaveData[Player.Name][Key] = Value
			DataDisplayEvent:FireClient(Player,Key,PlayerCurrentSaveData[Player.Name][Key])
			return true
		end
	end
end

function Modify(Player,Actions,Keys,Values)
	if(Player:FindFirstChild("DoneLoading") == nil or Player["DoneLoading"].Value == false) then
		return nil
	end

	if type(Keys) == "table" then
		for Index,Key in ipairs(Keys) do
			if PlayerCurrentSaveData[Player.Name][Key] == nil then
				continue
			end

			ModifyValue(Player,Actions[Index],Key,Values[Index])
		end
		return
	end

	if PlayerCurrentSaveData[Player.Name][Keys] == nil then
		print("Unknown")
		return
	end

	return ModifyValue(Player,Actions,Keys,Values)
end


ModifyDataEvent.OnInvoke = Modify
RequestDataEvent.OnInvoke = RequestData

game.Players.PlayerRemoving:Connect(Save)
game.Players.PlayerAdded:Connect(function(Player)
	local NewVar = Instance.new("BoolValue",Player)
	NewVar.Name = "DoneLoading"
	Load(Player)
end)

game:BindToClose(function()
	for i, player in pairs(game.Players:GetPlayers()) do
		if player then
			player:Kick("This game is shutting down")
		end
	end
	wait(5)	
end)