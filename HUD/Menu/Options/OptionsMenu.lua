OptionsMenu =
{
	bgStartFrame = { 120, 243, 268 },
	bgEndFrame   = { 180, 267, 291 },

	firstTimeShowItems = 80,

	backAction = "PainMenu:ActivateScreen(MainMenu)",
	
	textColor	= R3D.RGBA( 200, 200, 170, 255 ),
	disabledColor = R3D.RGBA( 155, 155, 155, 255 ),
	
	fontBigTex  = "../CPLGui/font_texturka_alpha",
	fontSmallTex  = "../CPLGui/font_texturka_alpha",
	descColor	= R3D.RGB( 255, 255, 255 ),
	
	useItemBG = false,

	items =
	{
		ConfigureControls =
		{
			text = TXT.Menu.Controls,
			desc = TXT.MenuDesc.Controls,
			x	 = 950,
			y	 = 260,
			action = "PainMenu:ActivateScreen(ControlsConfig)",
			align = MenuAlign.Right,
		},
		
		ConfigureHUD =
		{
			text = TXT.Menu.HUD,
			desc = TXT.MenuDesc.HUD,
			x	 = 950,
			y	 = 320,
			action = "PainMenu:ActivateScreen(HUDConfig)",
			align = MenuAlign.Right,
		},

		SoundOptions =
		{
			text = TXT.Menu.Sound,
			desc = TXT.MenuDesc.Sound,
			x	 = 950,
			y	 = 380,
			action = "PainMenu:ActivateScreen(SoundOptions)",
			align = MenuAlign.Right,
		},

		VideoOptions =
		{
			text = TXT.Menu.Video,
			desc = TXT.MenuDesc.Video,
			x	 = 950,
			y	 = 440,
			action = "PainMenu:ActivateScreen(VideoOptions)",
			align = MenuAlign.Right,
		},
		CPLGui =
		{
			text = TXT.Menu.CPL,
			desc = TXT.MenuDesc.CPL,
			x	 = 950,
			y	 = 500,
			action = "PainMenu:ActivateScreen(CPLGui)",
			align = MenuAlign.Right,
		},
--[[		
		AdvancedOptions =
		{
			text = TXT.Menu.AdvancedVideo,
			desc = TXT.MenuDesc.AdvancedVideo,
			x	 = 950,
			y	 = 550,
			action = "PainMenu:ActivateScreen(AdvancedVideoOptions)",
			align = MenuAlign.Right,
		},]]--
	}
}
