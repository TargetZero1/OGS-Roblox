local Pets = 
	{
		["Olympic Cat"] = 
		{
			Rarity = "Common",
			Image = "rbxassetid://12948715197",
			CurrencyType = "Medals",
			Price = 200,
			Buffs = 
			{
				{"MEDAL_MULTIPLIER",0.01},
				{"JAVELIN_RANGE_MULTIPLIER",0.5}
			}
		},
		["Swift Dog"] = 
		{
			Rarity = "Rare",
			Image = "rbxassetid://12948715197",
			CurrencyType = "Medals",
			Price = 500,
			Buffs = 
			{
				{"MEDAL_MULTIPLIER",0.1},
				{"SPEED_MULTIPLIER",0.5},
				{"JAVELIN_POWER_MULTIPLIER",0.5}
			}
		}
		,
		["Ultra Kitty"] = 
		{
			Rarity = "Legendary",
			Image = "rbxassetid://12948715197",
			CurrencyType = "Medals",
			Price = 15000,
			Buffs = 
			{
				{"MEDAL_MULTIPLIER",1},
				{"SPEED_MULTIPLIER",2},
				{"SWIM_SPEED_MULTIPLIER",2},
				{"JAVELIN_POWER_MULTIPLIER",1.5}
			}
		}
	}
return Pets
