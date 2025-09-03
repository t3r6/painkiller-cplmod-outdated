BoardSlots =
{
	PermAll =
	{
		type = BoardSlotsTypes.PermAll,
		numSlots = 12,
		x = { 56, 135, 214, 292, 369, 447, 525, 604, 681, 759, 835, 913 },
		y = 55,
		size = { 55, 92 },
		spaceWidth = 78,
	},

	TimeAll =
	{
		type = BoardSlotsTypes.TimeAll,
		numSlots = 12,
		x = { 56, 135, 214, 292, 369, 447, 525, 604, 681, 759, 835, 913 },
		y = 617,
		size = { 55, 92 },
		spaceWidth = 78,
	},

	PermSel =
	{
		type = BoardSlotsTypes.PermSel,
		numSlots = 2,
		x = { 59, 231 },
		y = 179,
		size = { 137, 227 },
		spaceWidth = 173,
	},
	
	TimeSel =
	{
		type = BoardSlotsTypes.TimeSel,
		numSlots = 3,
		x = { 489, 660, 828 },
		y = 364,
		size = { 138, 228 },
		spaceWidth = 173,
	},
}

MagicCards =
{
	timeCards =
	{
		{
			texture = "HUD/Board/Cards/TC_Speed",
			bigImage = "HUD/Board/Cards/Big/TC_Speed",
			name = Languages.Texts[338],
			desc = Languages.Texts[362],
			cost = 100,
			index = 1,
		},

		{
			texture = "HUD/Board/Cards/TC_Dexterity",
			bigImage = "HUD/Board/Cards/Big/TC_Dexterity",
			name = Languages.Texts[339],
			desc = Languages.Texts[363],
			cost = 300,
			index = 2,
		},
		
		{
			texture = "HUD/Board/Cards/TC_Fury",
			bigImage = "HUD/Board/Cards/Big/TC_Fury",
			name = Languages.Texts[340],
			desc = Languages.Texts[364],
			cost = 200,
			index = 3,
		},

		{
			texture = "HUD/Board/Cards/TC_Rage",
			bigImage = "HUD/Board/Cards/Big/TC_Rage",
			name = Languages.Texts[341],
			desc = Languages.Texts[365],
			cost = 500,
			index = 4,
		},
		
		{
			texture = "HUD/Board/Cards/TC_Confusion",
			bigImage = "HUD/Board/Cards/Big/TC_Confusion",
			name = Languages.Texts[342],
			desc = Languages.Texts[366],
			cost = 200,
			index = 5,
		},

		{
			texture = "HUD/Board/Cards/TC_Endurance",
			bigImage = "HUD/Board/Cards/Big/TC_Endurance",
			name = Languages.Texts[343],
			desc = Languages.Texts[367],
			cost = 100,
			index = 6,
		},
		
		{
			texture = "HUD/Board/Cards/TC_Immunity",
			bigImage = "HUD/Board/Cards/Big/TC_Immunity",
			name = Languages.Texts[344],
			desc = Languages.Texts[368],
			cost = 666,
			index = 7,
		},

		{
			texture = "HUD/Board/Cards/TC_Haste",
			bigImage = "HUD/Board/Cards/Big/TC_Haste",
			name = Languages.Texts[345],
			desc = Languages.Texts[369],
			cost = 100,
			index = 8,
		},
		
		{
			texture = "HUD/Board/Cards/TC_Double_Haste",
			bigImage = "HUD/Board/Cards/Big/TC_Double_Haste",
			name = Languages.Texts[346],
			desc = Languages.Texts[370],
			cost = 300,
			index = 9,
		},

		{
			texture = "HUD/Board/Cards/TC_Triple_Haste",
			bigImage = "HUD/Board/Cards/Big/TC_Triple_Haste",
			name = Languages.Texts[347],
			desc = Languages.Texts[371],
			cost = 500,
			index = 10,
		},
		
		{
			texture = "HUD/Board/Cards/TC_Time_Bonus",
			bigImage = "HUD/Board/Cards/Big/TC_Time_Bonus",
			name = Languages.Texts[348],
			desc = Languages.Texts[372],
			cost = 100,
			index = 11,
		},

		{
			texture = "HUD/Board/Cards/TC_Double_Time_Bonus",
			bigImage = "HUD/Board/Cards/Big/TC_Double_Time_Bonus",
			name = Languages.Texts[349],
			desc = Languages.Texts[373],
			cost = 300,
			index = 12,
		},
	},
	
	permCards =
	{
		{
			texture = "HUD/Board/Cards/PC_Soul_Catcher",
			bigImage = "HUD/Board/Cards/Big/PC_Soul_Catcher",
			name = Languages.Texts[350],
			desc = Languages.Texts[374],
			cost = 500,
			index = 13,
		},

		{
			texture = "HUD/Board/Cards/PC_Soul_Keeper",
			bigImage = "HUD/Board/Cards/Big/PC_Soul_Keeper",
			name = Languages.Texts[351],
			desc = Languages.Texts[375],
			cost = 500,
			index = 14,
		},
		
		{
			texture = "HUD/Board/Cards/PC_Soul_Power",
			bigImage = "HUD/Board/Cards/Big/PC_Soul_Power",
			name = Languages.Texts[352],
			desc = Languages.Texts[376],
			cost = 1000,
			index = 15,
		},

		{
			texture = "HUD/Board/Cards/PC_Dark_Soul",
			bigImage = "HUD/Board/Cards/Big/PC_Dark_Soul",
			name = Languages.Texts[353],
			desc = Languages.Texts[377],
			cost = 400,
			index = 16,
		},
		
		{
			texture = "HUD/Board/Cards/PC_Blessing",
			bigImage = "HUD/Board/Cards/Big/PC_Blessing",
			name = Languages.Texts[354],
			desc = Languages.Texts[378],
			cost = 200,
			index = 17,
		},

		{
			texture = "HUD/Board/Cards/PC_Vitality",
			bigImage = "HUD/Board/Cards/Big/PC_Vitality",
			name = Languages.Texts[355],
			desc = Languages.Texts[379],
			cost = 100,
			index = 18,
		},
		
		{
			texture = "HUD/Board/Cards/PC_Double_Ammo",
			bigImage = "HUD/Board/Cards/Big/PC_Double_Ammo",
			name = Languages.Texts[356],
			desc = Languages.Texts[380],
			cost = 500,
			index = 19,
		},

		{
			texture = "HUD/Board/Cards/PC_Double_Treasure",
			bigImage = "HUD/Board/Cards/Big/PC_Double_Treasure",
			name = Languages.Texts[357],
			desc = Languages.Texts[381],
			cost = 2000,
			index = 20,
		},
		
		{
			texture = "HUD/Board/Cards/PC_Forgiveness",
			bigImage = "HUD/Board/Cards/Big/PC_Forgiveness",
			name = Languages.Texts[358],
			desc = Languages.Texts[382],
			cost = 1000,
			index = 21,
		},

		{
			texture = "HUD/Board/Cards/PC_Mercy",
			bigImage = "HUD/Board/Cards/Big/PC_Mercy",
			name = Languages.Texts[359],
			desc = Languages.Texts[383],
			cost = 2000,
			index = 22,
		},
		
		{
			texture = "HUD/Board/Cards/PC_Divine_Intervention",
			bigImage = "HUD/Board/Cards/Big/PC_Divine_Intervention",
			name = Languages.Texts[360],
			desc = Languages.Texts[384],
			cost = 0,
			index = 23,
		},

		{
			texture = "HUD/Board/Cards/PC_Last_Breath",
			bigImage = "HUD/Board/Cards/Big/PC_Last_Breath",
			name = Languages.Texts[361],
			desc = Languages.Texts[385],
			cost = 500,
			index = 24,
		},
	}
}

MagicBoard =
{
}

function MagicBoard:Setup()
	MagicBoard_LoadStatus()

	-- Slots
	local i, o = next( BoardSlots, nil )
	while i do
		local y2 = -1
		if o.y2 then
			y2 = o.y2
		end
		MBOARD.SetupSlots( o.type, o.numSlots, o.y, o.size[1], o.size[2], o.spaceWidth, y2 )
		for n, m in o.x do
			MBOARD.SetSlotPosition( o.type, n - 1, o.x[n] )
		end

		i,o = next( BoardSlots, i )
	end

	-- Cards
	for i, o in MagicCards.timeCards do
		MBOARD.AddCard( MagicCardsTypes.Time, o.name, o.texture, o.desc, o.cost, Game.CardsAvailable[o.index], Game.CardsSelected[o.index] )
	end

	for i, o in MagicCards.permCards do
		MBOARD.AddCard( MagicCardsTypes.Perm, o.name, o.texture, o.desc, o.cost, Game.CardsAvailable[o.index], Game.CardsSelected[o.index] )
	end
end


function MagicBoard_UpdateCardsStatus()
	for i, o in MagicCards.timeCards do
		if Game.CardsAvailable[o.index] then
			Game.CardsSelected[o.index] = not MBOARD.IsCardInSlot( BoardSlotsTypes.TimeAll, i - 1 )
		end
	end

	for i, o in MagicCards.permCards do
		if Game.CardsAvailable[o.index] then
			Game.CardsSelected[o.index] = not MBOARD.IsCardInSlot( BoardSlotsTypes.PermAll, i - 1 )
		end
	end
	
	MagicBoard_SaveStatus()
end

function MagicBoard_SaveStatus()
end

function MagicBoard_LoadStatus()
end
