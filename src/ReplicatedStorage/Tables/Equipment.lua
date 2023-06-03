local Equipment = {}
Equipment.Items = 
	{
		["Basic Javelin"] = 
		{
			Slot = "Hand",
			SlotType = "Slot_Tool",
			ItemType = "Javelin",
			Rarity = "Common",
			EquipmentImage = "rbxassetid://12207380079",
			CurrencyType = "Medals",
			Price = 100,
			Buffs = 
			{
				{"MEDAL_MULTIPLIER",0.01}
			},
			BaseAttribute = 300
		},
		["Wind Breaker"] = 
		{
			Slot = "Hand",
			SlotType = "Slot_Tool",
			ItemType = "Javelin",
			Rarity = "Uncommon",
			EquipmentImage = "rbxassetid://12207380079",
			CurrencyType = "Medals",
			Price = 500,
			Buffs = 
			{
				{"MEDAL_MULTIPLIER",0.1},
				{"JAVELIN_POWER_MULTIPLIER",0.2}
			},
			BaseAttribute = 500
		},
		["Golden Seeker"] = 
		{
			Slot = "Hand",
			SlotType = "Slot_Tool",
			ItemType = "Javelin",
			Rarity = "Rare",
			EquipmentImage = "rbxassetid://12207380079",
			CurrencyType = "Medals",
			Price = 1500,
			Buffs = 
			{
				{"MEDAL_MULTIPLIER",0.2}
			},
			BaseAttribute = 700
		},
		["Basic Shoes"] = 
		{
			Slot = "Foot",
			SlotType = "Slot_Shoes",
			ItemType = "Shoe",
			Rarity = "Common",
			EquipmentImage = "rbxassetid://12207380079",
			CurrencyType = "Medals",
			Price = 100,
			Buffs = 
			{
				{"MEDAL_MULTIPLIER",0.2},
				{"RUN_SPEED_MULTIPLIER",0.2}
			},
			BaseAttribute = 18
		}
		,
		["Basic Flippers"] = 
		{
			Slot = "Foot",
			SlotType = "Slot_Shoes",
			ItemType = "Flippers",
			Rarity = "Common",
			EquipmentImage = "rbxassetid://12207380079",
			CurrencyType = "Medals",
			Price = 200,
			Buffs = 
			{
				{"MEDAL_MULTIPLIER",0.2}
			},
			BaseAttribute = 20
		}
		,
		["Ultra Flippers"] = 
		{
			Slot = "Foot",
			SlotType = "Slot_Shoes",
			ItemType = "Flippers",
			Rarity = "Legendary",
			EquipmentImage = "rbxassetid://12207380079",
			CurrencyType = "Medals",
			Price = 12200,
			Buffs = 
			{
				{"MEDAL_MULTIPLIER",3},
				{"SWIM_SPEED_MULTIPLIER",1.5}
			},
			BaseAttribute = 50
		}
		,
		["Basic Hat"] = 
		{
			Slot = "Head",
			SlotType = "Slot_Hat",
			ItemType = "Hat",
			Rarity = "Common",
			EquipmentImage = "rbxassetid://12207380079",
			CurrencyType = "Medals",
			Price = 100,
			Buffs = 
			{
				{"MEDAL_MULTIPLIER",3}
			},
		}
		,
		["Brainer"] = 
		{
			Slot = "Head",
			SlotType = "Slot_Hat",
			ItemType = "Hat",
			Rarity = "Epic",
			EquipmentImage = "rbxassetid://12207380079",
			CurrencyType = "Medals",
			Price = 500,
			Buffs = 
			{
				{"MEDAL_MULTIPLIER",3}
			},
		}
	}

Equipment.GetBaseAttributeName = function(ItemName)
	if Equipment.Items[ItemName] == nil then
		return ""
	end
	
	local Type = Equipment.Items[ItemName]["ItemType"]
	if Type == "Javelin" then
		return "Base Power"
	elseif Type == "Shoe" then
		return "Base Speed"
	elseif Type == "Flippers" then
		return "Base Swim Speed"
	end
	return ""
end

return Equipment
