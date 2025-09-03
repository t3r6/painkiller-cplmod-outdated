CPLGui =
{
	bgStartFrame = { 120, 243, 268 },
	bgEndFrame   = { 180, 267, 291 },

	fontBigSize = 36,

	backAction = "PainMenu:ApplySettings(false); PainMenu:ActivateScreen(OptionsMenu)",
	applyAction = "PainMenu:ApplySettings(true); PainMenu:ReloadFOV(); WORLD.SetMaxFPS(Cfg.MaxFpsMP); PainMenu:ApplyVideoSettings(); PainMenu:ReloadBrightskins(); PMENU.SetItemVisibility('ApplyButton',false)",

	items =
	{	
	
		FpsBorder =
		{
			type = MenuItemTypes.Border,
			x = 100,
			y = 75,
			width = 824,
			height = 400,
		},

		SetCameraFOV =
				{
					type = MenuItemTypes.Slider,
					text = TXT.Menu.CPLFov,
					desc = TXT.MenuDesc.CPLFov,
					option = "FOV",
					minValue = 60,
					maxValue = 120,
					x	 = 160,
					y	 = 110,
					action = "",
					applyRequired = true,
                },

		SetMaxFps =
				{
					type = MenuItemTypes.Slider,
					text = TXT.Menu.CPLMaxFps,
					desc = TXT.MenuDesc.CPLMaxFps,
					option = "MaxFpsMP",
					minValue = 0,
					maxValue = 300,
					x	 = 160,
					y	 = 150,
					action = "",
					applyRequired = true,
				},

		
		ShowTimer =
		{
			type = MenuItemTypes.Checkbox,
			text = TXT.Menu.CPLShowTimer,
			desc = TXT.MenuDesc.CPLShowTimer,
			option = "ShowTimer",
			valueOn = true,
			valueOff = false,
			x	 = 160,
			y	 = 210,
			action = "",
			fontBigSize = 26,
			applyRequired = true,
		},
		
		ShowFPS =
		{
			type = MenuItemTypes.Checkbox,
			text = TXT.Menu.CPLShowFPS,
			desc = TXT.MenuDesc.CPLShowFPS,
			option = "HUD_FPS_Show",
			valueOn = true,
			valueOff = false,
			x	 = 400,
			y	 = 210,
			action = "",
			fontBigSize = 26,
			applyRequired = true,
		},
		
		ShowAmmolist =
		{
			type = MenuItemTypes.Checkbox,
			text = "Show Ammolist",
			desc = "Use in-game ammunition list",
			option = "HUD_AmmoList_Show",
			valueOn = true,
			valueOff = false,
			x	 = 600,
			y	 = 210,
			action = "",
			fontBigSize = 26,
			applyRequired = true,
		},
		
		Ammolistpos =
		{
			type = MenuItemTypes.TextButtonEx,
			text = "AmmolistPos",
			desc = "Place your ammolist to the left or right",
			option = "HUD_AmmoList_Pos",
			values = { 1, 2},
			visible = { TXT.Menu.CPLLeft, TXT.Menu.CPLRight},
			x	 = 160,
			y	 = 290,
			action = "",
			align = MenuAlign.Left,
			applyRequired = true,
		},

		Timerpos =
		{
			type = MenuItemTypes.TextButtonEx,
			text = "TimerPos",
			desc = "Place your timer to left, right or to the center of the screen",
			option = "HUD_Timer_Minutes_Pos_X",
			values = { 10, 480, 915},
			visible = { TXT.Menu.CPLLeft, TXT.Menu.CPLCenter, TXT.Menu.CPLRight},
			x	 = 560,
			y	 = 290,
			action = "",
			align = MenuAlign.Left,
			applyRequired = true,
		},

		BrightskinEnemy =
		{
			type = MenuItemTypes.TextButtonEx,
			text = TXT.Menu.CPLBrightskinEnemy,
			desc = TXT.MenuDesc.CPLBrightskinEnemy,
			option = "BrightskinEnemy",
			values = { "Red", "Green", "Blue", "White" },
			visible = { TXT.Menu.CPLBrightskinRed, TXT.Menu.CPLBrightskinGreen, TXT.Menu.CPLBrightskinBlue, TXT.Menu.CPLBrightskinWhite },
			x	 = 160,
			y	 = 365,
			action = "",
			align = MenuAlign.Left,
			applyRequired = true,
		},
		BrightskinTeam =
		{
			type = MenuItemTypes.TextButtonEx,
			text = TXT.Menu.CPLBrightskinTeam,
			desc = TXT.MenuDesc.CPLBrightskinTeam,
			option = "BrightskinTeam",
			values = { "White", "Green", "Blue", "Red" },
			visible = { TXT.Menu.CPLBrightskinWhite, TXT.Menu.CPLBrightskinGreen, TXT.Menu.CPLBrightskinBlue, TXT.Menu.CPLBrightskinRed },
			x	 = 560,
			y	 = 365,
			action = "",
			align = MenuAlign.Left,
			applyRequired = true,
		},
	}
}
