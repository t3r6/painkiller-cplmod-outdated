MainMenu =
{
	firstTimeShowItems = 80,

	--bgStartFrame = { 120, 243, 267 },
	--bgEndFrame   = { 180, 266, 291 },

	textColor	= R3D.RGBA( 200, 200, 170, 255 ),
	disabledColor = R3D.RGBA( 155, 155, 155, 255 ),
	
	fontBigTex  = "../CPLGui/font_texturka_alpha",
	fontSmallTex  = "../CPLGui/font_texturka_alpha",
	descColor	= R3D.RGB( 200, 200, 170 ),

	useItemBG = false,

	items		=
	{
		
		modcredits =
		{
			text = "CPL Mod Credits",
			desc = "CPL Mod Credits",
			x	 = 400,
			y	 = 50,
			action = "PainMenu:ActivateScreen(CPLModCredits)",
			align = MenuAlign.Center,
			sndLightOn = "menu/menu/option-light-on_main4",
			textColor	= R3D.RGBA( 200, 200, 170, 255 ),
			fontBigSize = 26,
		},
	
		SignAPact =
		{
			text = TXT.Menu.SignAPact,
			desc = TXT.MenuDesc.SignAPact,
			x	 = 950,
			y	 = 260,
			action = "PainMenu:SignAPact()",
--			action = "PMENU:SwitchToMap()",
			sndLightOn = "menu/menu/option-light-on_main",
			align = MenuAlign.Right,
			disabled = 1,
		},
		
		LoadGame =
		{
			text = TXT.Menu.LoadGame,
			desc = TXT.MenuDesc.LoadGame,
			x	 = 950,
			y	 = 320,
			action = "PainMenu:ActivateScreen(LoadSaveMenu)",
			disabled = 1,
			sndLightOn = "menu/menu/option-light-on_main2",
			align = MenuAlign.Right,
		},

		Multiplayer =
		{
			text = TXT.Menu.Multiplayer,
			desc = TXT.MenuDesc.Multiplayer,
			x	 = 950,
			y	 = 380,
			action = "PainMenu:ActivateScreen(MultiplayerMenu)",
			align = MenuAlign.Right,
			sndLightOn = "menu/menu/option-light-on_main3",
			--disabled = 1,
			textColor	= R3D.RGBA( 200, 200, 170, 255 ),
		},

		Options =
		{
			text = TXT.Menu.Options,
			desc = TXT.MenuDesc.Options,
			x	 = 950,
			y	 = 440,
			action = "PainMenu:ActivateScreen(OptionsMenu)",
			align = MenuAlign.Right,
			sndLightOn = "menu/menu/option-light-on_main4",
			textColor	= R3D.RGBA( 200, 200, 170, 255 ),
		},
		
		Quit =
		{
			text = TXT.Menu.Quit,
			desc = TXT.MenuDesc.Quit,
			x	 = 950,
			y	 = 500,
			action = "PainMenu:AskYesNo( Languages.Texts[469], 'Exit()', 'PainMenu:ActivateScreen(MainMenu)' )",
--			action = "PainMenu:AskYesNo( Languages.Texts[469], 'PainMenu:ActivateScreen(DemoEnd)', 'PainMenu:ActivateScreen(MainMenu)' )",
			sndLightOn = "menu/menu/option-light-on_main5",
			align = MenuAlign.Right,
			textColor	= R3D.RGBA( 200, 200, 170, 255 ),
		},
		
		BackButton =
		{
			text = TXT.Menu.Return,
			desc = TXT.MenuDesc.Return,
			textColor	= R3D.RGBA( 200, 200, 170, 255 ),
			x	 = 72,
			y	 = 660,
			fontBigSize = 36,
			align = MenuAlign.Left,
			inGameOnly = 1,
			action = "PMENU.ResumeSounds(); PMENU.ReturnToGame(); PainMenu:ReloadBrightskins(); PainMenu:ReloadFOV();",
			useItemBG = false,
		},
		
		BackToMap =
		{
			text = TXT.Menu.ReturnToMap,
			desc = TXT.MenuDesc.ReturnToMap,
			textColor	= R3D.RGBA( 200, 200, 170, 255 ),
			x	 = 952,
			y	 = 660,
			fontBigSize = 36,
			align = MenuAlign.Right,
			inGameOnly = 1,
			action = "PainMenu:AskReturnToMap()",
			useItemBG = false,
		},
		
		Disconnect =
		{
			text = TXT.Menu.Disconnect,
			desc = TXT.MenuDesc.Disconnect,
			textColor = R3D.RGBA( 255, 255, 255, 255 ),
			x	 = 952,
			y	 = 660,
			fontBigSize = 36,
			align = MenuAlign.Right,
			inGameOnly = 1,
			action = "PainMenu:Disconnect()",
			useItemBG = false,
		},

		Credits =
		{
			text = TXT.Menu.Credits,
			desc = TXT.MenuDesc.Credits,
			textColor	= R3D.RGBA( 255, 255, 255, 255 ),
			x	 = -1,
			y	 = 660,
			fontBigSize = 36,
			action = "PainMenu:Disconnect(); PMENU.ShowCredits()",
			useItemBG = false,
		},
--[[
		Quit =
		{
			text = TXT.Menu.Quit,
			desc = TXT.MenuDesc.Quit,
			textColor	= R3D.RGBA( 255, 255, 255, 255 ),
			x	 = 952,
			y	 = 660,
			fontBigSize = 36,
--			exitStart = 170,
--			exitEnd = 240,
			align = MenuAlign.Right,
--			action = "Exit()",
			action = "PainMenu:AskYesNo( Languages.Texts[469], 'Exit()', 'PainMenu:ActivateScreen(MainMenu)' )",
--			action = "PainMenu:AskYesNo( 'Are you sure you want to quit Painkiller?\\nPeople Can Fly', 'Exit()', 'PainMenu:ActivateScreen(MainMenu)' )",
			useItemBG = false,
			sndAccept   = "menu/menu/quit-accept",
			sndLightOn  = "menu/menu/quit-light-on",
		},

		Image =
		{
			type = MenuItemTypes.ImageButton,
			text = "",
			desc = "ImageButton test",
			image = "HUD/Map/karta_swiec",
			imageUnder = "HUD/Map/karta_wcisnieta",
			x	 = 10,
			y	 = 520,
			action = "",
		},

		Weapons =
		{
			text		= "Weapons",
			desc		= "Go to weapon configuration screen",
			action		= "PainMenu:ActivateScreen(WeaponsConfig)",
			x			= 492,
			y			= 660,
			fontBigSize = 36,
			align		= MenuAlign.Right,
			useItemBG	= false,
			textColor	= R3D.RGBA( 255, 255, 255, 255 ),
			descColor	= R3D.RGB( 255, 255, 255 ),
			sndAccept   = "menu/menu/apply-accept",
			sndLightOn  = "menu/menu/back-light-on",
			fontBigTex  = "../CPLGui/font_texturka_alpha",
			fontSmallTex= "../CPLGui/font_texturka_alpha",
		}
]]--
	}
}
