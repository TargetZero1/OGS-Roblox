OpenShopEvent = game.ServerStorage.Events.OpenShop
OpenShopEvent_Client = game.ReplicatedStorage.Events.OpenShop
BuyItemEvent = game.ReplicatedStorage.Events.BuyItem

ShopDataFolder = game.ServerStorage.Tables.Shops

RequestEvent = game.ServerStorage.Events.RequestPlayerData
ModifyEvent = game.ServerStorage.Events.ModifyPlayerData

MessageEvent = game.ReplicatedStorage.Events.PlayerMessage

ItemData = require(game.ReplicatedStorage.Tables.Equipment)
CurrencyData = require(game.ReplicatedStorage.Tables.Currency)
RarityData = require(game.ReplicatedStorage.Tables.Rarities)
BuffData = require(game.ReplicatedStorage.Tables.Buffs)

AddToInventoryEvent = game.ServerStorage.Events.InventoryAdd

OpenShopEvent.Event:Connect(function(Player,ShopName)
	local ShopData = ShopDataFolder:FindFirstChild(ShopName)
	if(ShopData == nil) then
		return
	end
	ShopData = require(ShopData)
	OpenShopEvent_Client:FireClient(Player,ShopData)
end)

OpenShopEvent_Client.OnServerEvent:Connect(function(Player,ShopName)
	local ShopData = ShopDataFolder:FindFirstChild(ShopName)
	if(ShopData == nil) then
		return
	end
	ShopData = require(ShopData)
	OpenShopEvent_Client:FireClient(Player,ShopData)
end)


BuyItemEvent.OnServerEvent:Connect(function(Player,ShopName,ItemName)
	local ShopData = ShopDataFolder:FindFirstChild(ShopName)
	if ShopData == nil then
		return
	end
	
	ShopData = require(ShopData)
	
	if table.find(ShopData.Items,ItemName) == nil then
		return
	end
	
	local PlayerItemList = RequestEvent:Invoke(Player,"Equipment")
	if table.find(PlayerItemList,ItemName) then
		MessageEvent:FireClient(Player ,"You Already Have This!!" ,Color3.new(1, 0, 0.0156863),2,"Error")
		return
	end
	
	
	local PlayerCurrency = ModifyEvent:Invoke(Player, "REMOVE",ItemData.Items[ItemName]["CurrencyType"] ,ItemData.Items[ItemName]["Price"])
	if PlayerCurrency == false or PlayerCurrency == nil then
		MessageEvent:FireClient(Player, "Not Enough "..ItemData.Items[ItemName]["CurrencyType"] .." !!" ,Color3.new(1, 0, 0.0156863),2,"Error")
		return
	end
	ModifyEvent:Invoke(Player, "ADD", "Equipment",ItemName)
	AddToInventoryEvent:Fire(Player,ItemName)
	MessageEvent:FireClient(Player,"Purchased "..ItemName.."!!" ,Color3.new(1, 0.835294, 0),2,"Success")
end)