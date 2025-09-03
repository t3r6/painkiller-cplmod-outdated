MultiplayerMenu =
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
		JoinGame =
		{
			text = TXT.Menu.JoinGame,
			desc = TXT.MenuDesc.JoinGame,
			x	 = 950,
			y	 = 320,
			action = "PainMenu:ActivateScreen(LANGameMenu)",
			align = MenuAlign.Right,
		},

		StartGame =
		{
			text = TXT.Menu.StartGame,
			desc = TXT.MenuDesc.StartGame,
			x	 = 950,
			y	 = 380,
			action = "PainMenu:ActivateScreen(CreateServerMenu)",
			align = MenuAlign.Right,
		},

		PlayerSettings =
		{
			text = TXT.Menu.PlayerSettings,
			desc = TXT.MenuDesc.PlayerSettings,
			x	 = 950,
			y	 = 440,
			action = "PainMenu:ActivateScreen(PlayerOptions)",
			align = MenuAlign.Right,
		},
	}
}
