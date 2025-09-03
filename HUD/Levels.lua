Levels =
{
	{
		-- map directory, name, sketch, card cond, card index, min. level
		{ "C1L4_Cemetery", Languages.Texts[283], "sketch_cmentarz", Languages.Texts[396], 6, 0, nil },
		{ "C1L2_Atrium_Complex", Languages.Texts[284], "sketch_atrium", Languages.Texts[397], 8, 0, nil },
		{ "C1L3_Catacombs", Languages.Texts[285], "sketch_katakumby", Languages.Texts[398], 14, 0, nil },
		{ "C1L1_Cathedral", Languages.Texts[286], "sketch_chaos", Languages.Texts[399], 11, 0, nil },
		{ "C1L5_Enclave", Languages.Texts[287], "sketch_enclave", Languages.Texts[400], 17, 0, "end_of_chapter_1.bik" },
	},

	{
		-- map directory, name, sketch
		{ "C2L2_Prison", Languages.Texts[288], "sketch_prison", Languages.Texts[401], 19, 2, nil },
		{ "C2L3_Opera", Languages.Texts[289], "sketch_opera", Languages.Texts[402], 1, 0, nil },
		{ "C2L4_Asylum", Languages.Texts[290], "sketch_asylum", Languages.Texts[403], 3, 0, nil },
		{ "C2L1_Bridge", Languages.Texts[291], "sketch_most", Languages.Texts[404], 16, 0, nil },
		{ "C2L5_Town", Languages.Texts[292], "sketch_town", Languages.Texts[405], 9, 0, nil },
		{ "C2L6_Swamp", Languages.Texts[293], "sketch_swamp_arena", Languages.Texts[406], 2, 0, "end_of_chapter_2.bik" },
	},

	{
		-- map directory, name, sketch
		{ "C3L1_Train_Station", Languages.Texts[294], "sketch_dworzec", Languages.Texts[407], 13, 0, nil },
		{ "C3L2_Factory", Languages.Texts[295], "sketch_fabryka", Languages.Texts[408], 21, 1, nil },
		{ "C3L3_Military_Base", Languages.Texts[296], "sketch_baza", Languages.Texts[409], 20, 0, nil },
		{ "C3L5_Ruins", Languages.Texts[297], "sketch_ruins", Languages.Texts[410], 7, 0, "end_of_chapter_3.bik" },
	},
	
	{
		-- map directory, name, sketch
		{ "C3L4_Castle", Languages.Texts[298], "sketch_zamek", Languages.Texts[411], 4, 0, nil },
		{ "C4L1_Oriental_Castle", Languages.Texts[299], "sketch_arabski", Languages.Texts[412], 18, 0, nil },
		{ "C4L2_Babel", Languages.Texts[300], "sketch_babel", Languages.Texts[413], 12, 0, nil },
		{ "C3L6_Forest", Languages.Texts[301], "sketch_forest", Languages.Texts[414], 23, 3, nil },
		{ "C4L4_Alastor", Languages.Texts[302], "sketch_alastor", Languages.Texts[415], 10, 0, "end_of_chapter_4.bik" },
	},

	{
		-- map directory, name, sketch
		{ "C5L1_City_On_Water", Languages.Texts[303], "sketch_wenecja", Languages.Texts[416], 24, 0, nil },
		{ "C5L2_Docks", Languages.Texts[304], "sketch_doki", Languages.Texts[417], 5, 0, nil },
		{ "C5L3_Monastery", Languages.Texts[305], "sketch_opactwo", Languages.Texts[418], 15, 0, nil },
		{ "C5L4_Hell", Languages.Texts[306], "sketch_pieklo", Languages.Texts[419], 22, 0, "end_of_chapter_5.bik" },
	},
--[[
-- Setup for demo
	{
		{ "", "", "", "", 0, 0, nil },
	},
	
	{
		{ "", "", "", "", 0, 0, nil },
	},
	
	{
		{ "", "", "", "", 0, 0, nil },
	},
	
	{
		{ "", "", "", "", 0, 0, nil },
	},

	{
		{ "C5L1_City_On_Water", Languages.Texts[303], "sketch_wenecja", Languages.Texts[416], 24, 0, nil },
	},

	{
		{ "C2L5_Town", Languages.Texts[292], "sketch_town", Languages.Texts[405] },
		{ "", "", "", "" },
		{ "C4L1_Oriental_Castle", Languages.Texts[299], "sketch_arabski", Languages.Texts[412] },
		{ "", "", "", "" },
		{ "C3L5_Ruins", Languages.Texts[297], "sketch_ruins", Languages.Texts[410] },
	},
]]--
}


function Levels_FillMap()
	if not Game then return end
	
	local current_set = false

	for i=1,table.getn(Levels) do
		for j=1,table.getn(Levels[i]) do
			if (i < 5 or Game.Difficulty < Difficulties.Trauma) and Levels[i][j][1] ~= "" then
				local dir = Levels[i][j][1]
				local diff = Levels[i][j][6]

				local status = 0 -- unavailable

				if Game.LevelsStats[Levels[i][j][1]] == nil then
					Game:MakeEmptyLevelStats(Levels[i][j][1])
				end

				if Game.LevelsStats[Levels[i][j][1]].Finished == true then
					status = 2 -- finished
				end

				if Game.Difficulty < diff then
					status = 3 -- not available
					Game.LevelsStats[Levels[i][j][1]].Finished = true
				end

				if status == 0 then
					if (i == 1 and j == 1) then
						status = 1
					elseif j > 1 and Game.LevelsStats[Levels[i][j-1][1]] and Game.LevelsStats[Levels[i][j-1][1]].Finished == true then
						status = 1
					elseif i > 1 and Game.LevelsStats[Levels[i-1][table.getn(Levels[i-1])][1]] and Game.LevelsStats[Levels[i-1][table.getn(Levels[i-1])][1]].Finished == true then
						status = 1
					end
				end

				if current_set then
					status = 0
				elseif status == 1 then
					current_set = true
				end

				-- DEMO !!!
--				status = 1

				if status == 1 or status == 2 then
					PMENU.AddLevelToMap( i, Levels[i][j][1], Levels[i][j][2], "HUD/Map/"..Levels[i][j][3], Levels[i][j][4], Levels[i][j][5], status )
				else
					if Cfg.Language ~= "polish" then
						PMENU.AddLevelToMap( i, Levels[i][j][1], TXT.SPStats.Locked, "HUD/Map/sketch_question", Levels[i][j][4], 0, status )
					else
						PMENU.AddLevelToMap( i, Levels[i][j][1], "Zablokowany", "HUD/Map/sketch_question", Levels[i][j][4], 0, status )
					end
				end
			end
		end
    end
end

function Levels_GetNextLevel(name)
	if name == nil then return nil end

	local ret = false
	for i=1,table.getn(Levels) do
		for j=1,table.getn(Levels[i]) do
			if ret == true and Game.Difficulty >= Levels[i][j][6] then
				return Levels[i][j][1]
			end
			if Levels[i][j][1] == name then
				ret = true
			end
		end
	end

	if ret then return Levels[1][1][1] end

--	if ret then return Levels[5][1][1] end
end

function Levels_GetLevelName(dir)
	if dir == nil then return nil end

	for i=1,table.getn(Levels) do
		for j=1,table.getn(Levels[i]) do
			if Levels[i][j][1] == dir then
				return "C"..string.format("%02d",i).."E"..string.format("%02d",j).." - "..Levels[i][j][2]
			end
		end
	end
end

function Levels_GetLevelByDir(dir)
	if dir == nil then return nil, nil end

	for i=1,table.getn(Levels) do
		for j=1,table.getn(Levels[i]) do
			if Levels[i][j][1] == dir then
				return j,i
			end
		end
	end
end

function Levels_GetSketchByDir(dir)
	if dir == nil then return nil end

	for i=1,table.getn(Levels) do
		for j=1,table.getn(Levels[i]) do
			if Levels[i][j][1] == dir then
				return "HUD/Map/"..Levels[i][j][3]
			end
		end
	end

	if string.find(dir,"DM_") or string.find(dir,"DMPCF_") then
		return "HUD/Map/sketch_mp"
	end
end


-- Loading screen

ProgressIcons =
{
	{ 275, 92, "HUD/loading/s_1" },
	{ 300, 98, "HUD/loading/s_2" },
	{ 323, 109, "HUD/loading/s_3" },
--	{ 307, 92, "HUD/loading/s_3" },
	{ 347, 124, "HUD/loading/s_4" },
	{ 367, 142, "HUD/loading/s_5" },

	{ 404, 202, "HUD/loading/s_6" },
	{ 411, 223, "HUD/loading/s_7" },
	{ 415, 248, "HUD/loading/s_2" },
	{ 410, 275, "HUD/loading/s_8" },
	{ 406, 300, "HUD/loading/s_9" },

	{ 373, 363, "HUD/loading/s_5" },
	{ 354, 381, "HUD/loading/s_1" },
	{ 333, 394, "HUD/loading/s_4" },
	{ 305, 408, "HUD/loading/s_6" },
	{ 279, 416, "HUD/loading/s_3" },

	{ 218, 415, "HUD/loading/s_8" },
	{ 193, 409, "HUD/loading/s_7" },
	{ 168, 396, "HUD/loading/s_9" },
	{ 142, 381, "HUD/loading/s_2" },
	{ 123, 360, "HUD/loading/s_5" },

	{ 92, 304, "HUD/loading/s_1" },
	{ 87, 280, "HUD/loading/s_4" },
	{ 85, 254, "HUD/loading/s_8" },
	{ 87, 227, "HUD/loading/s_3" },
	{ 93, 204, "HUD/loading/s_6" },

	{ 123, 148, "HUD/loading/s_9" },
	{ 142, 129, "HUD/loading/s_2" },
	{ 168, 109, "HUD/loading/s_7" },
	{ 195, 98, "HUD/loading/s_8" },
	{ 220, 92, "HUD/loading/s_5" },
}

function LoadScreen_FillIcons()
	for i=1,table.getn(ProgressIcons) do
		PMENU.SetProgressIcon( i - 1, ProgressIcons[i][1], ProgressIcons[i][2], ProgressIcons[i][3] )
	end
end
