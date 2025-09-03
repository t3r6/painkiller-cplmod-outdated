CfgFile = "config.ini"
--============================================================================
-- Configuration
--============================================================================
Cfg = 
{
    AllowBrightskins = true,
    AllowBunnyhopping = true,
    AllowForwardRJ = true,
    AmbientSounds = true,
    AmbientVolume = 77,
    AutoChangeWeapon = true,
    BestExplosives = {0,41,32,},
    BestNonExplosives = {51,52,42,31,22,21,12,11,0,},
    BestWeapons1 = {32,0,51,52,41,42,31,22,21,12,11,},
    BestWeapons2 = {12,0,51,52,41,42,32,31,22,21,11,},
    Brightness = 0.5,
    BrightskinEnemy = "Red",
    BrightskinTeam = "White",
    CharacterShadow = "Off",
    ClipPlane = 100,
    ConnectionSpeed = 4,
    Contrast = 0.5,
    Coronas = true,
    Credits = false,
    Crosshair = 1,
    CrosshairR = 255,
    CrosshairG = 255,
    CrosshairB = 255,
    CrosshairSize = 1,
    CrosshairTrans = 100,
    Decals = false,
    DecalsStayTime = 0.4,
    DedicatedServer = false,
    DetailTextures = true,
    DisturbSound3DFreq = 0.1,
    DynamicLights = true,
    EAXAcoustics = true,
    FOV = 95,
    FragLimit = 20,
    Fullscreen = true,
    GameMode = "Free For All",
    Gamma = 1,
    GraphicsQuality = 0, -- Custom
    HeadBob = 100,
    HUDSize = 1,
    HUDTransparency = 25,
    InvertMouse = false,
    KeyAlternativeAlternativeFire = "Right Ctrl",
    KeyAlternativeBulletTime = "Return",
    KeyAlternativeFire = "None",
    KeyAlternativeFireBestWeapon1 = "None",
    KeyAlternativeFireBestWeapon2 = "None",
    KeyAlternativeFireSwitch = "None",
    KeyAlternativeFireSwitchToggle = "None",
    KeyAlternativeFlashlight = "None",
    KeyAlternativeForwardRocketJump = "None",
    KeyAlternativeJump = "None",
    KeyAlternativeMenu = "None",
    KeyAlternativeMoveBackward = "Cursor Down",
    KeyAlternativeMoveForward = "Cursor Up",
    KeyAlternativeNextWeapon = "None",
    KeyAlternativePause = "P",
    KeyAlternativePreviousWeapon = "None",
    KeyAlternativeQuickLoad = "None",
    KeyAlternativeQuickSave = "None",
    KeyAlternativeRocketJump = "None",
    KeyAlternativeSayToAll = "None",
    KeyAlternativeSayToTeam = "None",
    KeyAlternativeScoreboard = "None",
    KeyAlternativeScreenshot = "None",
    KeyAlternativeSelectBestWeapon1 = "None",
    KeyAlternativeSelectBestWeapon2 = "None",
    KeyAlternativeStrafeLeft = "Cursor Left",
    KeyAlternativeStrafeRight = "Cursor Right",
    KeyAlternativeWeapon1 = "Delete",
    KeyAlternativeWeapon2 = "None",
    KeyAlternativeWeapon3 = "End",
    KeyAlternativeWeapon4 = "Page Down",
    KeyAlternativeWeapon5 = "None",
    KeyAlternativeWeapon6 = "None",
    KeyAlternativeWeapon7 = "None",
    KeyAlternativeWeapon8 = "None",
    KeyAlternativeWeapon9 = "None",
    KeyAlternativeWeapon10 = "None",
    KeyAlternativeUseCards = "None",
    KeyPrimaryAlternativeFire = "Right Mouse Button",
    KeyPrimaryBulletTime = "None",
    KeyPrimaryFire = "Left Mouse Button",
    KeyPrimaryFireBestWeapon1 = "Left Shift",
    KeyPrimaryFireBestWeapon2 = "Left Ctrl",
    KeyPrimaryFireSwitch = "R",
    KeyPrimaryFireSwitchToggle = "T",
    KeyPrimaryFlashlight = "L",
    KeyPrimaryForwardRocketJump = "None",
    KeyPrimaryJump = "Space",
    KeyPrimaryMenu = "None",
    KeyPrimaryMoveBackward = "S",
    KeyPrimaryMoveForward = "W",
    KeyPrimaryNextWeapon = "Mouse Wheel Forward",
    KeyPrimaryPause = "P",
    KeyPrimaryPreviousWeapon = "Mouse Wheel Back",
    KeyPrimaryQuickLoad = "F9",
    KeyPrimaryQuickSave = "F5",
    KeyPrimaryRocketJump = "None",
    KeyPrimarySayToAll = "None",
    KeyPrimarySayToTeam = "None",
    KeyPrimaryScoreboard = "Tab",
    KeyPrimaryScreenshot = "F12",
    KeyPrimarySelectBestWeapon1 = "None",
    KeyPrimarySelectBestWeapon2 = "None",
    KeyPrimaryStrafeLeft = "A",
    KeyPrimaryStrafeRight = "D",
    KeyPrimaryWeapon1 = "1",
    KeyPrimaryWeapon2 = "2",
    KeyPrimaryWeapon3 = "3",
    KeyPrimaryWeapon4 = "4",
    KeyPrimaryWeapon5 = "5",
    KeyPrimaryWeapon6 = "6",
    KeyPrimaryWeapon7 = "7",
    KeyPrimaryWeapon8 = "8",
    KeyPrimaryWeapon9 = "9",
    KeyPrimaryWeapon10 = "0",
    KeyPrimaryUseCards = "E",
    Language = "english",
    ManualIP = "127.0.0.1",
    MasterVolume = 100,
    MaxPlayers = 8,
    MaxSpectators = 4,
    MessagesKeys = {"None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None",},
    MessagesSayAll = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    MouseSensitivity = 40,
    Multisample = "x0",
    MusicVolume = 33,
                    -- delay, linear vel, angular vel, pos    
    NetUpdateClass00 = { 1/45, 0.02, 0.02, 0.03 }, -- default (other players and objects)
    NetUpdateClass01 = { 1/15, 0.20, 0.20, 0.20 }, -- physics items (barrel, urn..)
    NetUpdateClass02 = { 1/10, 0.01, 0.01, 0.02 }, -- rocket, stake, grenade
    NetUpdateClass03 = { 0.01, 0.01, 0.01, 0.01 }, -- my player
    NetUpdateMaxPacketSize = 500,
    NetUpdateSendPeriod = 10, -- miliseconds

    ParticlesDetail = 2,
    PlayerModel = 2,
    PlayerName = "Unnamed",
    PowerupDrop = false,
    Powerups = true,
    PrecacheData = 0,
    Projectors = false,
    RenderSky = 2,
    Resolution = "1024X768",
    ReverseStereo = false,
    ServerMaps = {},
    ServerMapsFFA = {},
    ServerMapsTDM = {},
    ServerMapsTLB = {},
    ServerMapsPCF = {},
    ServerMapsVSH = {},
    ServerName = "Painkiller v1.2",
    ServerPassword = "",
    ServerPort = 3455,
    SfxVolume = 100,
    Shadows = 0,
    ShowDaydreamWarning = true,
    SmoothMouse = true,
    SoundFalloffSpeed = 6,
    SoundPan = 50,
    SoundProvider3D = "Miles Fast 2D Positional Audio",
    SoundQuality = "High",
    SpeakersSetup = "Two Speakers",
    SwitchFire = { false, false, false, false, false },
    Team = 0,
    TeamDamage = false,
    TextureFiltering = "Bilinear",
    TextureQuality = 0,
    TextureQualityArchitecture = 0,
    TextureQualityCharacters = 0,
    TextureQualitySkies = 0,
    TextureQualityWeapons = 0,
    TimeLimit = 20,
    LimitServerFPS = false,
    ServerFPS = 45,
    UserKick = true,
    UserBankick = true,
    UserMaxPlayers = true,
    UserMaxSpectators = true,
    UserPowerupDrop = true,
    UserPowerups = true,
    UserWeaponsStay = true,
    UserTeamDamage = true,
    UserAllowBunnyhopping = true,
    UserAllowBrightskins = true,
    UserAllowForwardRJ = true,
    UserReloadMap = true,
    UserGameMode = true,
    UserMapChange = true,
    UserTimeLimit = true,
    UserFragLimit = true,
    ViewWeaponModel = true,
    WeaponBob = 0,
    WeaponNormalMap = true,
    WeaponPriority = { 51, 52, 41, 42, 32, 31, 22, 21, 12, 11, 0 },
    WeaponSpecular = true,
    WeaponsStay = true,
    WeaponRespawnTime = 30,
    NoAmmoSwitch = false,
    LowQualityMultiplayerSFX = false,
    WeatherEffects = true,
    WheelSensitivity = 2,
    WarmUpTime = 14.99,
    StoreFrames = 0,
    CameraInterpolation = true, -- only for MP client
    MaxFpsMP = 0,
--    MBStats = {0,0,0,0,0,12495}, -- (fury,endurance,double haste,blessing,forgiveness)
}
--============================================================================
function Cfg:Save()    
    local f = io.open (CfgFile,"w")
    if not f then
        if Game then
            Game:Print("WARNING: "..CfgFile.."is read-only. Configuration not saved.")
        else
            MsgBox("WARNING: "..CfgFile.." is read-only. Configuration not saved.")
        end
		return
    end
       
    local sorted = {}
    for i,o in self do  table.insert(sorted,{i,o}) end
    table.sort(sorted,function (a,b) return a[1] < b[1] end)
          
              
    for i,v in sorted do
        if string.sub(v[1],1,1) ~= '_' and (type(v[2]) == "string" or type(v[2]) == "number" or type(v[2]) == "boolean") then                
            local val = v[2]
            if type(v[2]) == "string" then 
                --val = '"'..v[2]..'"' 
                val = string.format('%q', v[2])
            end                
            if type(v[2]) == "boolean" then 
                if v[2] == true then val = "true" else val = "false" end
            end
            f:write("Cfg."..v[1].." = "..val..'\n')
        end
        if type(v[2]) == "table" then
			local tab = v[2]
			f:write( "Cfg."..v[1].." = {" )
			for i=1,table.getn(tab) do
				local val = tab[i]
				if type(val) == "string" or type(val) == "number" or type(val) == "boolean" then
					if type(val) == "string" then 
                        --val = '"'..val..'"' 
                        val = string.format('%q', val)
                    end
					if type(val) == "boolean" then 
						if val == true then val = "true" else val = "false" end
					end
					f:write( val.."," )
				end
			end
			f:write( "}"..'\n' )
        end
    end
    io.close(f)
end
--============================================================================
function Cfg:Load()
	local label = GetCDLabel()
	local lang = Cfg.Language
	if label then label = string.lower(label) end
	if label == "pk_fr_3" then
		lang = "french"
	elseif label == "pk_de_3" then
		lang = "german"
	elseif label == "pk_it_3" then
		lang = "italian"
	elseif label == "pk_sp_3" then
		lang = "spanish"
	elseif label == "pk_pl_1" then
		lang = "polish"
	elseif label == "pk_ru_3" then
		lang = "russian"
	elseif label == "pk_cz_3" then
		lang = "czech"
	elseif label == "pk_3" then
		lang = "english"
	end

	if lang == "french" then
		Cfg.KeyPrimaryStrafeLeft = "Q"
		Cfg.KeyPrimaryMoveForward = "Z"
	end

	if IsMPDemo() then
		Cfg.ServerName = "Painkiller Demo"
	end

    DoFile(CfgFile,false)
    if type(Cfg.TextureQuality) == "string" then Cfg.TextureQuality = 0 end
    if type(Cfg.TimeLimit) == "string" then Cfg.TimeLimit = 10 end
    if type(Cfg.FragLimit) == "string" then Cfg.FragLimit = 15 end
    if type(Cfg.MaxPlayers) == "string" then 
        Cfg.MaxPlayers = 8 
        Cfg.MaxSpectators = 0
    end

	Cfg.Language = lang
--	Cfg.Language = "polish"

	if type(Cfg.PlayerModel) == "string" then
		Cfg.PlayerModel = Cfg:FindMPModel(Cfg.PlayerModel)
	end
    
    if Cfg.PlayerModel < 1 or Cfg.PlayerModel > 5 then
        Cfg.PlayerModel = 1
    end

	if IsMPDemo() then
		Cfg.Credits = false
		if Cfg.PlayerModel > 4 then Cfg.PlayerModel = 1 end
	end

    if Cfg.MaxPlayers < 1 or Cfg.MaxPlayers > 16 then Cfg.MaxPlayers = 8 end
    if Cfg.MaxSpectators < 0 or Cfg.MaxSpectators > 8 then Cfg.MaxSpectators = 0 end
    if Cfg.ServerFPS < 30 then
        Cfg.ServerFPS = 30
    end
    if Cfg.ServerFPS > 120 then
        Cfg.ServerFPS = 120
    end
    if type(Cfg.BestExplosives[1]) == "string" then
		Cfg.BestExplosives = { 41, 32, 0 }
		Cfg.BestNonExplosives = { 51, 52, 42, 31, 22, 21, 12, 11, 0 }
		Cfg.BestWeapons = { 51, 52, 41, 42, 32, 31, 22, 21, 12, 11, 0 }
		Cfg.WeaponPriority = { 51, 52, 41, 42, 32, 31, 22, 21, 12, 11, 0 }
    end

	if type(Cfg.ConnectionSpeed) == "string" then Cfg.ConnectionSpeed = 5 end
	if Cfg.ConnectionSpeed < 1 or Cfg.ConnectionSpeed > 5 then Cfg.ConnectionSpeed = 5 end

	if Cfg.WheelSensitivity < 0 then Cfg.WheelSensitivity = 0 end
	if Cfg.WheelSensitivity > 4 then Cfg.WheelSensitivity = 4 end

	if Cfg.MouseSensitivity < 1 then Cfg.MouseSensitivity = Cfg.MouseSensitivity * 400 end
	
	if Cfg.DecalsStayTime > 1 then Cfg.DecalsStayTime = 2 end
	
	if type(Cfg.RenderSky) == "boolean" then
		Cfg.RenderSky = 2
	end
	
	for i=1,table.getn(Cfg.MessagesSayAll) do
		if Cfg.MessagesSayAll[i] ~= 0 then
			Cfg.MessagesSayAll[i] = 1
		end
	end
	
	if Cfg.GraphicsQuality > 6 then
		Cfg.GraphicsQuality = 6
	elseif Cfg.GraphicsQuality < 0 then
		Cfg.GraphicsQuality = 0
	end

	Cfg.PlayerName = HUD.ColorSubstr(tostring(Cfg.PlayerName),16)

	if Cfg.CrosshairSize > 3 then Cfg.CrosshairSize = 3 end
	if Cfg.CrosshairSize < 0.2 then Cfg.CrosshairSize = 0.2 end

--	Cfg.Shadows = 0

	-- Removal of obsolete variables from the config.ini
	Cfg.NewPrediction = nil
	Cfg.FramerateLock = nil
	Cfg.UseGamespy = nil
	Cfg.PushLatency = nil
	Cfg.PlayerPrediction = nil

end
--============================================================================
function Cfg:FindMPModel(name)
	for i=1,table.getn(MPModels) do
		if MPModels[i] == name then return i end
	end

	return 2
end
--============================================================================
function Cfg_ClearKeyBinding( key )
	local name, o = next( Cfg, nil )
	while name do
		if string.find( name, "KeyAlternative" ) or string.find( name, "KeyPrimary" ) then
			if( Cfg[name] == key ) then Cfg[name] = "None" end
		end
		name,o = next( Cfg, name )
	end
	
	for i=1,table.getn(Cfg.MessagesKeys) do
		if Cfg.MessagesKeys[i] == key then
			Cfg.MessagesKeys[i] = "None"
		end
	end
	
	local short = INP.GetShortNameByEngName( key )
	if short and Cfg["Bind_"..string.upper(short)] then
		Cfg["Bind_"..string.upper(short)] = nil
	end
	
	Cfg:Save()
end
--============================================================================
function Cfg_BindKeyCommands()
	local name, o = next( Cfg, nil )
	while name do
		if string.find( name, "Bind_" ) then
			Console:Cmd_BIND(string.sub(name,6).." "..Cfg[name],true)
		end
		name,o = next( Cfg, name )
	end
end
