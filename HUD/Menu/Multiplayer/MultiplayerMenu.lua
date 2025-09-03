MultiplayerMenu =
{
	bgStartFrame = { 120, 243, 268 },
	bgEndFrame   = { 180, 267, 291 },

	firstTimeShowItems = 80,

	backAction = "PainMenu:ActivateScreen(MainMenu)",
	
	textColor	= R3D.RGBA( 100, 100, 100, 255 ),
	disabledColor = R3D.RGBA( 155, 155, 155, 255 ),
	
	fontBigTex  = "HUD/font_texturka_alpha",
	fontSmallTex  = "HUD/font_texturka_alpha",
	descColor	= R3D.RGB( 255, 255, 255 ),
	
	useItemBG = true,

	items =
	{
		JoinGame =
		{
			text = TXT.Menu.JoinGame,
			desc = TXT.MenuDesc.JoinGame,
			x	 = -1,
			y	 = 264,
			action = "PainMenu:ActivateScreen(LANGameMenu)",
		},

		StartGame =
		{
			text = TXT.Menu.StartGame,
			desc = TXT.MenuDesc.StartGame,
			x	 = -1,
			y	 = 344,
			action = "PainMenu:ActivateScreen(CreateServerMenu)",
		},

		PlayerSettings =
		{
			text = TXT.Menu.PlayerSettings,
			desc = TXT.MenuDesc.PlayerSettings,
			x	 = -1,
			y	 = 424,
			action = "PainMenu:ActivateScreen(PlayerOptions)",
		},
	}
}
