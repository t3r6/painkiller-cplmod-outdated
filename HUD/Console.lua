--=======================================================================
Console = 
{
}
--=======================================================================
function Console:Cmd_SHOWTIMER(show)
	show = tonumber(show)
	if show == nil then
		CONSOLE.AddMessage("enables timer display [1/0]")
		return
	end

	if show == 1 then 
	Hud._showTimer = true 
	Cfg.ShowTimer = true
	end
	if show == 0 then 
	Hud._showTimer = false 
	Cfg.ShowTimer = false
	end
end
--=======================================================================
function Console:Cmd_SHOWWEAPON(enable)    
   enable = tonumber(enable)    
    if enable == nil then 
        CONSOLE.AddMessage("showweapon 0/1  (disables/enables weapon rendering)") 
    end            
    if enable == 1 then Cfg.ViewWeaponModel = true  end    
    if enable == 0 then Cfg.ViewWeaponModel = false end        
end

--=======================================================================
function Console:Cmd_STRESSTEST()    
    if IsFinalBuild() then return end
    
    local n = table.getn(PKLevels)
    GOD = true
    Game:LoadLevel(PKLevels[math.random(1,n)])
    Game:OnPlay(true)
    Game:SwitchPlayerToPhysics()
    AddAction({{"Wait:30"},{"L:StringToDo = 'Console:Cmd_STRESSTEST()'"}})    
end
--=======================================================================
function Console:Cmd_SERVERINFO()
	if Game.GMode == GModes.SingleGame then return end
	Game.ServerInfoRequest(NET.GetClientID())
end
--=======================================================================
function Console:Cmd_BIND(params,silent)
	if not params or params == "" then
		if not silent then CONSOLE.AddMessage("usage: bind key command") end
		return
	end
	local i = string.find(params," ",1,true)
	if not i then i = string.len(params) + 1 end
	local key = string.sub(params,1,i-1)
	params = Trim( string.sub(params,i) )
	i = string.find(params," ",1,true)
	if not i then i = string.len(params) + 1 end
	local cmd = string.sub(params,1,i-1)

	if not params or params == "" or not key or key == "" then
		if not silent then CONSOLE.AddMessage("usage: bind key command") end
		return
	end

	if not Console["Cmd_"..string.upper(cmd)] then
		if not silent then CONSOLE.AddMessage("Unknown command: ".. cmd) end
		return
	end

	local keyOrig = key
	if key == "[" then key = "LBracket"
	elseif key == "]" then key = "RBracket"
	elseif key == ";" then key = "Semicolon"
	elseif key == "'" then key = "Quote"
	elseif key == "-" then key = "Minus"
	elseif key == "=" then key = "Plus"
	elseif key == "\\" then key = "BSlash"
	elseif key == "~" then key = "Tilde"
	elseif key == "," then key = "Comma"
	elseif key == "." then key = "Period"
	elseif key == "/" then key = "Slash"
	elseif string.upper(key) == "NUMPAD*" then key = "NumpadMulti"
	elseif string.upper(key) == "NUMPAD+" then key = "NumpadAdd"
	elseif string.upper(key) == "NUMPAD-" then key = "NumpadSub"
	elseif string.upper(key) == "NUMPAD." then key = "NumpadDec"
	elseif string.upper(key) == "NUMPAD/" then key = "NumpadDiv"
	end

	local engName = INP.GetEngNameByShortName( key )
	if engName == "None" then
		if not silent then CONSOLE.AddMessage("Unknown key: "..keyOrig) end
		return
	end
	Cfg_ClearKeyBinding( engName )
	INP.BindKeyCommand(string.upper(key),"Console:OnCommand('"..params.."')")
	Cfg["Bind_"..string.upper(key)] = params
end
--=======================================================================
-- MAP
--=======================================================================
function Console:Cmd_MAP(name)
    if name == nil then 
        CONSOLE.AddMessage('map "name"  (loads map)') 
    else
		name = string.lower(name)
		if string.sub(name,1,2) ~= "dm" then
			CONSOLE.AddMessage( "Bad map name '"..name.."'" )
			return
		end

		local path = "../Data/Levels/"
		local files = FS.FindFiles(path.."*",0,1)
		local found = false
		for i=1,table.getn(files) do
			if string.lower(files[i]) == name then
				found = true
			end
		end

		if not found then
			CONSOLE.AddMessage( "Bad map name '"..name.."'" )
			return
		end

        if Game:IsServer() then
            NET.LoadMapOnServer(name)
        else
            if IsFinalBuild() then return end
            Game:LoadLevel(name)        
        end
    end
    
    CONSOLE.AddMessage("current map:  "..Lev._Name) 
end
--=======================================================================
function Console:Cmd_RELOADMAP()
	if Game.GMode == GModes.SingleGame then return end
	if not Game:IsServer() then return end
	if Lev._Name then
		Console:Cmd_MAP(Lev._Name)
	end
end
--=======================================================================
function Console:Cmd_TEAM(nr)
    if nr then
        nr = tonumber(nr)
        if nr and (nr == 1 or nr == 2) and Cfg.Team ~= nr - 1 then
            Cfg.Team = nr - 1
            if Game.GMode ~= GModes.SingleGame then 
                Game.NewPlayerTeamRequest(NET.GetClientID(),Cfg.Team)
                return
            end
        end
    end

    CONSOLE.AddMessage("current team:  "..(Cfg.Team+1))
end
--=======================================================================
function Console:Cmd_KILL()
	if Game.GMode == GModes.SingleGame then return end
	Game.PlayerKill(NET.GetClientID())
end
--=======================================================================
function Console:Cmd_SPECTATOR(nr)
    if nr then
        nr = tonumber(nr)
        if nr and (nr == 0 or nr == 1)then
            if Game.GMode ~= GModes.SingleGame then
                local spec = true
                if nr == 0 then spec = false end
                if spec ~= NET.IsSpectator(NET.GetClientID()) then
                    if NET.IsPlayingRecording() then
                        if nr == 0 then
                            GObjects:ToKill(Game._procSpec)
                            Game._procSpec = nil
                            Player = Game._spectatorRecordingPlayer
                        else
                            GObjects:ToKill(Game._procStats)
                            Game._procStats = nil
                            Game._procSpec = GObjects:Add(TempObjName(),PSpectatorControler:New())
                            Game._procSpec:Init()
                            Game._spectatorRecordingPlayer = Player
                            Player = nil
                        end
                        NET.SetSpectator(NET.GetClientID(),nr)
                    else
                        Game.PlayerSpectatorRequest(NET.GetClientID(),nr)
                    end
                end
            end
        end
    end
end
--=======================================================================
function Console:Cmd_READY()
	if Game.GMode == GModes.SingleGame then return end
    Game.SetStateRequest(NET.GetClientID(),1)
end
--=======================================================================
function Console:Cmd_NOTREADY()
	if Game.GMode == GModes.SingleGame then return end
    Game.SetStateRequest(NET.GetClientID(),0)
end
--=======================================================================
function Console:Cmd_BREAK()
	if Game.GMode == GModes.SingleGame then return end
    Game.SetStateRequest(NET.GetClientID(),2)
end
--=======================================================================
function Console:Cmd_BANKICK(name)
	if Game.GMode == GModes.SingleGame then return end
	if not Game:IsServer() then return end
	if name == nil then
        CONSOLE.AddMessage('bankick "name"  (disconnect and ban player from the server)')
        return
    end
    name = string.lower(name)
	for i,o in Game.PlayerStats do
		if string.lower(HUD.StripColorInfo(o.Name)) == name then
			NET.BanClient( o.ClientID )
			NET.DisconnectClient( o.ClientID )
		end
	end
end
--=======================================================================
function Console:Cmd_KICK(name)
	if Game.GMode == GModes.SingleGame then return end
	if not Game:IsServer() then return end
	if name == nil then
        CONSOLE.AddMessage('kick "name"  (disconnect player from the server)')
        return
    end
    name = string.lower(name)
	for i,o in Game.PlayerStats do
		if string.lower(HUD.StripColorInfo(o.Name)) == name then
			NET.DisconnectClient( o.ClientID )
		end
	end
end
--=======================================================================
function Console:Cmd_BANKICKID(id)
	if Game.GMode == GModes.SingleGame then return end
	if not Game:IsServer() then return end
	if id == nil then
        CONSOLE.AddMessage('kickid id  (disconnect player from the server)')
        return
    end
    id = tonumber(id)
    if id then
		NET.BanClient( id )
		NET.DisconnectClient( id )
	end
end
--=======================================================================
function Console:Cmd_KICKID(id)
	if Game.GMode == GModes.SingleGame then return end
	if not Game:IsServer() then return end
	if id == nil then
        CONSOLE.AddMessage('kickid id  (disconnect player from the server)')
        return
    end
    id = tonumber(id)
    if id then NET.DisconnectClient( id ) end
end
--=======================================================================
function Console:Cmd_MAXPLAYERS(val)
	if Game.GMode == GModes.SingleGame then return end
	if not Game:IsServer() then return end
	
	if val == nil then
		CONSOLE.AddMessage("maxplayers value (sets max number of players on server)")
	end
	
	val = tonumber(val)
	if val and val > 1 then
		Cfg.MaxPlayers = val
		GAMESPY.SetServerInfo(
			PK_VERSION,
            Cfg.ServerName,
            Cfg.ServerPassword,
            Lev._Name,
            Cfg.GameMode,
            Cfg.MaxPlayers,
            Cfg.MaxSpectators,
            Cfg.FragLimit,
            Cfg.TimeLimit,
            Cfg.TimeLimit * 60
        )
        
        Game.ConsoleMessageAll( "Max number of players is now "..val )
    else
		CONSOLE.AddMessage("Max number of players cannot be lower than 2")
    end
end
--=======================================================================
function Console:Cmd_MAXSPECTATORS(val)
	if Game.GMode == GModes.SingleGame then return end
	if not Game:IsServer() then return end

	if val == nil then
		CONSOLE.AddMessage("maxplayers value (sets max number of players on server)")
	end
	
	val = tonumber(val)
	if val then
		Cfg.MaxSpectators = val
		GAMESPY.SetServerInfo(
			PK_VERSION,
            Cfg.ServerName,
            Cfg.ServerPassword,
            Lev._Name,
            Cfg.GameMode,
            Cfg.MaxPlayers,
            Cfg.MaxSpectators,
            Cfg.FragLimit,
            Cfg.TimeLimit,
            Cfg.TimeLimit * 60
        )
        
        Game.ConsoleMessageAll( "Max number of spectators is now "..val )
    end
end
--=======================================================================
function Console:Cmd_STOREFRAMES(val)

    if not IsConstPhysicsTick() then return end

	if Game.GMode == GModes.SingleGame then
        CONSOLE.AddMessage( "This command has no meaning in Single Player Mode" )
        return
    end

	if Game:IsServer() then
        CONSOLE.AddMessage( "This command has no effect when issued on server" )
        return
    end

	if val == nil then
		CONSOLE.AddMessage( "Current storeframes value: "..NET.GetPushLatency() )
        CONSOLE.AddMessage( "Give a new value after this command to change it" )
        CONSOLE.AddMessage( "Valid values are from 0 up. Bigger values = better resistance to jumpy ping = more processor usage = less fps = less exact" )
        return
	end

	val = tonumber(val)
	if val then
        if val < 0 then
            CONSOLE.AddMessage( "Valid values are from 0 up! Not set." )
        else
            NET.SetPushLatency(val)
            Cfg.StoreFrames = val
            CONSOLE.AddMessage( "Storeframes value set to: "..NET.GetPushLatency() )
        end
    end
end
--=======================================================================
function Console:Cmd_SIMLATENCY(val)
    if IsFinalBuild() then return end
	if Game.GMode == GModes.SingleGame then return end
    
    if IsConstPhysicsTick() then
        CONSOLE.AddMessage( "Latency simulator doesn't work in const physics step mode" )
        return
    end
    

	if val == nil then
		CONSOLE.AddMessage( "Current simlatency value: "..NET.GetSimulatedLatency() )
        CONSOLE.AddMessage( "Give a new value after this command to change it" )
	end
	
	val = tonumber(val)
	if val then
        NET.SetSimulatedLatency(val)
        CONSOLE.AddMessage( "Simlatency value set to: "..NET.GetSimulatedLatency() )
    end
end
--=======================================================================
function Console:Cmd_SETMAXFPS(val)
	if val == nil then
        CONSOLE.AddMessage( "Give a new value after this command to change maxfps." )
        CONSOLE.AddMessage( "Give a 0 to remove the limit." )
        return
    end
	val = tonumber(val)
    if val then
        WORLD.SetMaxFPS(val)
		if Game.GMode == GModes.MultiplayerClient then
            Cfg.MaxFpsMP = val
        end
	end
end
--=======================================================================
function Console:Cmd_POWERUPDROP(enable)
	if Game.GMode == GModes.SingleGame then return end
	if not Game:IsServer() then return end
	
	enable = tonumber(enable)
    if enable == nil then
        CONSOLE.AddMessage("powerupdrop 0/1  (disables/enables powerup drop)")
    end
    if enable == 1 then
		Cfg.PowerupDrop = true
		Game.ConsoleMessageAll("Powerup dropping enabled")
    elseif enable == 0 then
		Cfg.PowerupDrop = false
		Game.ConsoleMessageAll("Powerup dropping disabled")
	end
end
--=======================================================================
function Console:Cmd_POWERUPS(enable)
	if Game.GMode == GModes.SingleGame then return end
	if not Game:IsServer() then return end

	enable = tonumber(enable)
    if enable == nil then
        CONSOLE.AddMessage("powerups 0/1  (disables/enables powerups)")
    end
    if enable == 1 then
		Cfg.Powerups = true
		Game.ConsoleMessageAll("Powerups will be enabled after map reload")
    elseif enable == 0 then
		Cfg.Powerups = false
		Game.ConsoleMessageAll("Powerups will be disabled after map reload")
	end
end
--=======================================================================
function Console:Cmd_WEAPONSSTAY(enable)
	if Game.GMode == GModes.SingleGame then return end
	if not Game:IsServer() then return end

	enable = tonumber(enable)
    if enable == nil then
        CONSOLE.AddMessage("weaponsstay 0/1  (disables/enables weapons stay)")
    end
    if enable == 1 then
		Cfg.WeaponsStay = true
		Game.ConsoleMessageAll("Weapons stay enabled")
    elseif enable == 0 then
		Cfg.WeaponsStay = false
		Game.ConsoleMessageAll("Weapons stay disabled")
	end
end
--=======================================================================
function Console:Cmd_TEAMDAMAGE(enable)
	if Game.GMode == GModes.SingleGame then return end
	if not Game:IsServer() then return end

	enable = tonumber(enable)
    if enable == nil then
        CONSOLE.AddMessage("teamdamage 0/1  (disables/enables team damage)")
    end
    if enable == 1 then
		Cfg.TeamDamage = true
		Game.ConsoleMessageAll("Team damage is now enabled")
    elseif enable == 0 then
		Cfg.TeamDamage = false
		Game.ConsoleMessageAll("Team damage is now disabled")
	end

	Game.SetConfiguration(Cfg.AllowBrightskins,Cfg.GameMode,Cfg.TeamDamage,MPCfg.GameState)
end
--=======================================================================
function Console:Cmd_ALLOWBUNNYHOPPING(enable)
	if Game.GMode == GModes.SingleGame then return end
	if not Game:IsServer() then return end

	enable = tonumber(enable)
    if enable == nil then
        CONSOLE.AddMessage("allowbunnyhopping 0/1  (disables/enables bunnyhopping)")
    end
    if enable == 1 then
		Cfg.AllowBunnyhopping = true
    elseif enable == 0 then
		Cfg.AllowBunnyhopping = false
    end

    Game.EnableBunnyhopping(Cfg.AllowBunnyhopping)
end
--=======================================================================
function Console:Cmd_ALLOWBRIGHTSKINS(enable)
	if Game.GMode == GModes.SingleGame then return end
	if not Game:IsServer() then return end

	enable = tonumber(enable)
    if enable == nil then
        CONSOLE.AddMessage("allowbrightskins 0/1  (disables/enables brightskins)")
    end
    if enable == 1 then
		Cfg.AllowBrightskins = true
	elseif enable == 0 then
		Cfg.AllowBrightskins = false
	end

	MPCfg.GameMode         = Cfg.GameMode
    MPCfg.TeamDamage       = Cfg.TeamDamage
    MPCfg.AllowBrightskins = Cfg.AllowBrightskins

    Game.SetConfiguration(Cfg.AllowBrightskins,Cfg.GameMode,Cfg.TeamDamage,MPCfg.GameState)
    Game.ReloadBrightskins()
end
--=======================================================================
function Console:Cmd_ALLOWFORWARDRJ(enable)
	if Game.GMode == GModes.SingleGame then return end
	if not Game:IsServer() then return end

	enable = tonumber(enable)
    if enable == nil then
        CONSOLE.AddMessage("allowforwardrj 0/1  (disables/enables forward rocket jumps)")
    end
    if enable == 1 then
		Cfg.AllowForwardRJ = true
		Game.ConsoleMessageAll( "Forward Rocket Jumps enabled" )
	elseif enable == 0 then
		Cfg.AllowForwardRJ = false
		Game.ConsoleMessageAll( "Forward Rocket Jumps disabled" )
	end
end

--=======================================================================
function Console:Cmd_GAMEMODE(mode)
	if Game.GMode == GModes.SingleGame then return end
	if not Game:IsServer() then return end

	if IsMPDemo() then
		CONSOLE.AddMessage( "Command 'gamemode' not available in demo version" )
		return
	end

	local toPCF = false
	local fromPCF = false
	if Cfg.GameMode == "People Can Fly" then
		fromPCF = true
	elseif mode == "pcf" then
		toPCF = true
	end

	local newMap = nil

	if mode == "ffa" then
		if Cfg.GameMode == "Free For All" then return end
		Cfg.GameMode = "Free For All"
		if fromPCF then
			if Cfg.ServerMapsFFA[1] then
				newMap = Cfg.ServerMapsFFA[1]
			else
				newMap = "DM_Sacred"
			end
		end
	elseif mode == "tdm" then
		if Cfg.GameMode == "Team Deathmatch" then return end
		Cfg.GameMode = "Team Deathmatch"
		if fromPCF then
			if Cfg.ServerMapsTDM[1] then
				newMap = Cfg.ServerMapsTDM[1]
			else
				newMap = "DM_Sacred"
			end
		end
	elseif mode == "voosh" then
		if Cfg.GameMode == "Voosh" then return end
		Cfg.GameMode = "Voosh"
		if fromPCF then
			if Cfg.ServerMapsVSH[1] then
				newMap = Cfg.ServerMapsVSH[1]
			else
				newMap = "DM_Sacred"
			end
		end
	elseif mode == "tlb" then
		if Cfg.GameMode == "The Light Bearer" then return end
		Cfg.GameMode = "The Light Bearer"
		if fromPCF then
			if Cfg.ServerMapsTLB[1] then
				newMap = Cfg.ServerMapsTLB[1]
			else
				newMap = "DM_Sacred"
			end
		end
	elseif mode == "pcf" then
		if Cfg.GameMode == "People Can Fly" then return end
		Cfg.GameMode = "People Can Fly"
		if Cfg.ServerMapsPCF[1] then
			newMap = Cfg.ServerMapsPCF[1]
		else
			newMap = "DMPCF_Tower"
		end
	else
		CONSOLE.AddMessage("Available modes: ffa, tdm, voosh, tlb, pcf")
		return
	end

	Game.SetConfiguration(Cfg.AllowBrightskins,Cfg.GameMode,Cfg.TeamDamage,MPCfg.GameState)

	if fromPCF or toPCF then
		Console:Cmd_MAP(newMap)
	else
		Console:Cmd_RELOADMAP()
	end
end
--=======================================================================
function Console:CheckVotingParams(cmd,params)
	if cmd == "map" then
		name = string.lower(params)
		if string.sub(name,1,2) ~= "dm" then
			CONSOLE.AddMessage( "Bad map name '"..name.."'" )
			return false
		end

		local path = "../Data/Levels/"
		local files = FS.FindFiles(path.."*",0,1)
		local found = false
		for i=1,table.getn(files) do
			if string.lower(files[i]) == name then
				found = true
			end
		end

		if not found then
			CONSOLE.AddMessage( "Bad map name '"..name.."'" )
			return false
		end

		return true
	elseif cmd == "timelimit" or cmd == "fraglimit" or cmd == "maxplayers" or cmd == "maxspectators" or cmd == "bankickid" or cmd == "kickid" or cmd == "weaponrespawntime" then
		local val = tonumber(params)
		if not val or type(val) ~= "number" then
			CONSOLE.AddMessage( "Wrong params for "..cmd )
			return false
		end
		return true
	elseif cmd == "kick" or cmd == "gamemode" or cmd == "bankick" then
		if params and type(params) == "string" then
			return true
		else
			CONSOLE.AddMessage( "Wrong params for "..cmd )
			return false
		end
	elseif cmd == "powerupdrop" or cmd == "powerups" or cmd == "weaponsstay" or cmd == "teamdamage"
		or cmd == "allowbunnyhopping" or cmd == "allowbrightskins" or cmd == "allowforwardrj" then
		local val = tonumber(params)
		if val ~= 0 and val ~= 1 then
			CONSOLE.AddMessage( "Wrong params for "..cmd )
			return false
		end
		return true
	elseif cmd == "reloadmap" then
		return true
	end

	CONSOLE.AddMessage( "Command '"..cmd.."' cannot be used for voting" )
	return false
end
--=======================================================================
function Console:Cmd_CALLVOTE(params)
	if Game.GMode == GModes.SingleGame then return end
	if NET.IsSpectator(NET.GetClientID()) then return end
	if not params or params == "" then return end
	local i = string.find(params," ",1,true)
	if not i then i = string.len(params) + 1 end
	local cmd = string.sub(params,1,i-1)
	params = Trim( string.sub(params,i) )

	if not Console["Cmd_"..string.upper(cmd)] then
		CONSOLE.AddMessage("Unknown command: ".. cmd)
		return
	end

	if not self:CheckVotingParams(cmd,params) then
		return
	end

	local numPlayers = 0
	for i,o in Game.PlayerStats do
		numPlayers = numPlayers + 1
	end
	if numPlayers < 2 then
		CONSOLE.AddMessage( "Not enough players for voting" )
		return
	end

	if Game._voteCmd == "" then
		Game.StartVotingRequest(NET.GetClientID(),cmd,params)
	else
		CONSOLE.AddMessage("Please wait till current voting is over")
	end
end
--=======================================================================
function Console:Cmd_VOTE(yesno)
	if Game.GMode == GModes.SingleGame then return end
	if NET.IsSpectator(NET.GetClientID()) then
		CONSOLE.AddMessage( "Spectators cannot vote." )
		return
	end
	if not yesno or (yesno ~= "no" and yesno ~= "yes") then
		CONSOLE.AddMessage( "Usage: vote yes/no" )
		return
	end

	local val = 0
	if yesno == "yes" then val = 1 end

	if Game._voteCmd ~= "" then
		Game.PlayerVoteRequest(NET.GetClientID(),val)
	else
		CONSOLE.AddMessage( "No voting in progress" )
	end
end
--=======================================================================
function Console:Cmd_PLAYERS()
	if Game.GMode == GModes.SingleGame then
        CONSOLE.AddMessage( 'Command not available in Single Player mode' )
        return
    end
    
    for i,o in Game.PlayerStats do
		CONSOLE.AddMessage( o.ClientID.."  "..o.Name )
	end
end
--=======================================================================
function Console:Cmd_NETSTATS(cmd)
	if Game.GMode == GModes.SingleGame then
        CONSOLE.AddMessage( 'Command not available in Single Player mode' )
        return
    end
    if cmd == nil then
        CONSOLE.AddMessage(NET.GetClientStats(255,true)) 
    else
        if cmd == 'overall' then
            CONSOLE.AddMessage(NET.GetClientStats(255,false)) 
        else
            if cmd == 'help' then
                CONSOLE.AddMessage( 'Usage:' )
                CONSOLE.AddMessage( ' netstats         - to get stats for last 5 seconds' )
                CONSOLE.AddMessage( ' netstats overall - to get stats for the whole connection' )
                CONSOLE.AddMessage( ' netstats help    - for this message' )
            end
        end
    end
end
--=======================================================================
function Console:Cmd_MAXPACKETSIZE(size)
	if Game.GMode == GModes.SingleGame then
        CONSOLE.AddMessage( 'Command not available in Single Player mode' )
        return
    end

    if Game:IsServer() then
        CONSOLE.AddMessage( 'Server cannot use this command' )
        return
    end

    if size == nil then
        CONSOLE.AddMessage( 'Current max UDP packet size: '..NET.GetMaxUdpPacketSize() )
    else
        if size == 'help' then
            CONSOLE.AddMessage( 'usage: maxpacketsize <size>, where size is between 32 and 1400' )
        else
            size = tonumber(size)
            if size then
                NET.SetMaxUdpPacketSize(size)
                Cfg.NetUpdateMaxPacketSize = NET.GetMaxUdpPacketSize()
                Cfg.ConnectionSpeed = 5 -- custom
                PainMenu:UpdateConnSpeedControl(5)
                CONSOLE.AddMessage( 'Current max UDP packet size: '..Cfg.NetUpdateMaxPacketSize )
            else
                CONSOLE.AddMessage( "Enter number of bytes you want your max packet to have, or 'help'" )
            end
        end
    end
end
--=======================================================================
function Console:Cmd_UPDATEPARAMS_MYPLAYER(delay,linvel,angvel,pos)
	if Game.GMode == GModes.SingleGame then
        CONSOLE.AddMessage( 'Command not available in Single Player mode' )
        return
    end

    if Game:IsServer() then
        CONSOLE.AddMessage( 'Server cannot use this command' )
        return
    end

    if delay == nil then
        CONSOLE.AddMessage( 'Current settings for my player synchro: ' )
        CONSOLE.AddMessage( 'Min time between updates: '..Cfg.NetUpdateClass03[1]..' sec' )
        CONSOLE.AddMessage( 'Min linear velocity difference to update: '..Cfg.NetUpdateClass03[2] )
        CONSOLE.AddMessage( 'Min angular velocity difference to update: '..Cfg.NetUpdateClass03[3] )
        CONSOLE.AddMessage( 'Min position difference to update: '..Cfg.NetUpdateClass03[4] )
    else
        if delay == 'help' then
            CONSOLE.AddMessage( 'usage: updateparams_myplayer updates_delay min_lin_vel min_ang_vel min_pos' )
            CONSOLE.AddMessage( 'usage: updateparams_myplayer updates_delay min_lin_vel min_ang_vel' )
            CONSOLE.AddMessage( 'usage: updateparams_myplayer updates_delay min_lin_vel' )
            CONSOLE.AddMessage( 'usage: updateparams_myplayer updates_delay' )
            CONSOLE.AddMessage( 'usage: updateparams_myplayer' )
            CONSOLE.AddMessage( 'usage: updateparams_myplayer help' )
        else
            delay = tonumber(delay)
            linvel = tonumber(linvel)
            angvel = tonumber(angvel)
            pos = tonumber(pos)
            if delay then Cfg.NetUpdateClass03[1] = delay end
            if linvel then Cfg.NetUpdateClass03[2] = linvel end
            if angvel then Cfg.NetUpdateClass03[3] = angvel end
            if pos then Cfg.NetUpdateClass03[4] = pos end
            NET.SetUpdateClassData( 3, delay, linvel, angvel, pos )
            NET.SendUpdateClassData()
            Cfg.ConnectionSpeed = 5 -- custom
            PainMenu:UpdateConnSpeedControl(5)
            CONSOLE.AddMessage( 'Updateparams for my player sent to server' )
        end
    end
end
--=======================================================================
function Console:Cmd_UPDATEPARAMS_PHYSICSITEMS(delay,linvel,angvel,pos)
	if Game.GMode == GModes.SingleGame then
        CONSOLE.AddMessage( 'Command not available in Single Player mode' )
        return
    end

    if Game:IsServer() then
        CONSOLE.AddMessage( 'Server cannot use this command' )
        return
    end

    if delay == nil then
        CONSOLE.AddMessage( 'Current settings for physics items synchro: ' )
        CONSOLE.AddMessage( 'Min time between updates: '..Cfg.NetUpdateClass01[1]..' sec' )
        CONSOLE.AddMessage( 'Min linear velocity difference to update: '..Cfg.NetUpdateClass01[2] )
        CONSOLE.AddMessage( 'Min angular velocity difference to update: '..Cfg.NetUpdateClass01[3] )
        CONSOLE.AddMessage( 'Min position difference to update: '..Cfg.NetUpdateClass01[4] )
    else
        if delay == 'help' then
            CONSOLE.AddMessage( 'usage: updateparams_physicsitems updates_delay min_lin_vel min_ang_vel min_pos' )
            CONSOLE.AddMessage( 'usage: updateparams_physicsitems updates_delay min_lin_vel min_ang_vel' )
            CONSOLE.AddMessage( 'usage: updateparams_physicsitems updates_delay min_lin_vel' )
            CONSOLE.AddMessage( 'usage: updateparams_physicsitems updates_delay' )
            CONSOLE.AddMessage( 'usage: updateparams_physicsitems' )
            CONSOLE.AddMessage( 'usage: updateparams_physicsitems help' )
        else
            delay = tonumber(delay)
            linvel = tonumber(linvel)
            angvel = tonumber(angvel)
            pos = tonumber(pos)
            if delay then Cfg.NetUpdateClass01[1] = delay end
            if linvel then Cfg.NetUpdateClass01[2] = linvel end
            if angvel then Cfg.NetUpdateClass01[3] = angvel end
            if pos then Cfg.NetUpdateClass01[4] = pos end
            NET.SetUpdateClassData( 1, delay, linvel, angvel, pos )
            NET.SendUpdateClassData()
            Cfg.ConnectionSpeed = 5 -- custom
            PainMenu:UpdateConnSpeedControl(5)
            CONSOLE.AddMessage( 'Updateparams for physics items sent to server' )
        end
    end
end
--=======================================================================
function Console:Cmd_UPDATEPARAMS_PLAYERS(delay,linvel,angvel,pos)
	if Game.GMode == GModes.SingleGame then
        CONSOLE.AddMessage( 'Command not available in Single Player mode' )
        return
    end

    if Game:IsServer() then
        CONSOLE.AddMessage( 'Server cannot use this command' )
        return
    end

    if delay == nil then
        CONSOLE.AddMessage( 'Current settings for players synchro: ' )
        CONSOLE.AddMessage( 'Min time between updates: '..Cfg.NetUpdateClass00[1]..' sec' )
        CONSOLE.AddMessage( 'Min linear velocity difference to update: '..Cfg.NetUpdateClass00[2] )
        CONSOLE.AddMessage( 'Min angular velocity difference to update: '..Cfg.NetUpdateClass00[3] )
        CONSOLE.AddMessage( 'Min position difference to update: '..Cfg.NetUpdateClass00[4] )
    else
        if delay == 'help' then
            CONSOLE.AddMessage( 'usage: updateparams_players updates_delay min_lin_vel min_ang_vel min_pos' )
            CONSOLE.AddMessage( 'usage: updateparams_players updates_delay min_lin_vel min_ang_vel' )
            CONSOLE.AddMessage( 'usage: updateparams_players updates_delay min_lin_vel' )
            CONSOLE.AddMessage( 'usage: updateparams_players updates_delay' )
            CONSOLE.AddMessage( 'usage: updateparams_players' )
            CONSOLE.AddMessage( 'usage: updateparams_players help' )
        else
            delay = tonumber(delay)
            linvel = tonumber(linvel)
            angvel = tonumber(angvel)
            pos = tonumber(pos)
            if delay then Cfg.NetUpdateClass00[1] = delay end
            if linvel then Cfg.NetUpdateClass00[2] = linvel end
            if angvel then Cfg.NetUpdateClass00[3] = angvel end
            if pos then Cfg.NetUpdateClass00[4] = pos end
            NET.SetUpdateClassData( 0, delay, linvel, angvel, pos )
            NET.SendUpdateClassData()
            Cfg.ConnectionSpeed = 5 -- custom
            PainMenu:UpdateConnSpeedControl(5)
            CONSOLE.AddMessage( 'Updateparams for players sent to server' )
        end
    end
end
--=======================================================================
function Console:Cmd_UPDATEPARAMS_PROJECTILES(delay,linvel,angvel,pos)
	if Game.GMode == GModes.SingleGame then
        CONSOLE.AddMessage( 'Command not available in Single Player mode' )
        return
    end

    if Game:IsServer() then
        CONSOLE.AddMessage( 'Server cannot use this command' )
        return
    end

    if delay == nil then
        CONSOLE.AddMessage( 'Current settings for projectiles synchro: ' )
        CONSOLE.AddMessage( 'Min time between updates: '..Cfg.NetUpdateClass02[1]..' sec' )
        CONSOLE.AddMessage( 'Min linear velocity difference to update: '..Cfg.NetUpdateClass02[2] )
        CONSOLE.AddMessage( 'Min angular velocity difference to update: '..Cfg.NetUpdateClass02[3] )
        CONSOLE.AddMessage( 'Min position difference to update: '..Cfg.NetUpdateClass02[4] )
    else
        if delay == 'help' then
            CONSOLE.AddMessage( 'usage: updateparams_projectiles updates_delay min_lin_vel min_ang_vel min_pos' )
            CONSOLE.AddMessage( 'usage: updateparams_projectiles updates_delay min_lin_vel min_ang_vel' )
            CONSOLE.AddMessage( 'usage: updateparams_projectiles updates_delay min_lin_vel' )
            CONSOLE.AddMessage( 'usage: updateparams_projectiles updates_delay' )
            CONSOLE.AddMessage( 'usage: updateparams_projectiles' )
            CONSOLE.AddMessage( 'usage: updateparams_projectiles help' )
        else
            delay = tonumber(delay)
            linvel = tonumber(linvel)
            angvel = tonumber(angvel)
            pos = tonumber(pos)
            if delay then Cfg.NetUpdateClass02[1] = delay end
            if linvel then Cfg.NetUpdateClass02[2] = linvel end
            if angvel then Cfg.NetUpdateClass02[3] = angvel end
            if pos then Cfg.NetUpdateClass02[4] = pos end
            NET.SetUpdateClassData( 2, delay, linvel, angvel, pos )
            NET.SendUpdateClassData()
            Cfg.ConnectionSpeed = 5 -- custom
            PainMenu:UpdateConnSpeedControl(5)
            CONSOLE.AddMessage( 'Updateparams for projectiles sent to server' )
        end
    end
end
--=======================================================================
function Console:Cmd_DISCONNECT()
	if Game.GMode == GModes.SingleGame or Game:IsServer() then
        CONSOLE.AddMessage( 'Command not available in Single Player or Server mode' )
        return
    end
	NET.Disconnect()
	Game.GameInProgress = false
	Game.LevelStarted = false
	PMENU.ShowMenu()
	PainMenu:BackToLastScreen()
end
--=======================================================================
function Console:Cmd_RECONNECT()
	if Game.GMode == GModes.SingleGame then
        CONSOLE.AddMessage( 'Command not available in Single Player mode' )
        return
    end
	PMENU.Activate(false)
	local res = PMENU.JoinServer( PainMenu.playerName, PainMenu.passwd, PainMenu.speed, PainMenu.host, PainMenu.port, PainMenu.public, PainMenu.spectator )
	if res == false then
		Game:Print( "Cannot join server "..self.host )
		PainMenu:ShowInfo( "Cannot connect to server "..self.host, "PainMenu:BackToLastScreen()" )
	end
end
--=======================================================================
function Console:Cmd_SAY(txt)
	if not txt then return end
	if Game.GMode == GModes.SingleGame then
        CONSOLE.AddMessage( 'Command not available in Single Player mode' )
        return
    end
    Game.SayToAll(NET.GetClientID(), txt)
end
--=======================================================================
function Console:Cmd_TEAMSAY(txt)
	if not txt then return end
	if Game.GMode == GModes.SingleGame then
        CONSOLE.AddMessage( 'Command not available in Single Player mode' )
        return
    end
    Game.SayToTeam(NET.GetClientID(), txt)
end
--=======================================================================
-- TIMEDEMO
--=======================================================================
function Console:Cmd_BENCHMARK(name)
    if name == nil then 
        CONSOLE.AddMessage('benchmark "name"') 
    else
        if not Game:IsServer() then
            Game:LoadLevel(name.."_Benchmark")        
			Game:OnPlay(true)
			CONSOLE.Activate(false)
        end
    end
end
--=======================================================================
-- CHEATS
--=======================================================================
-- pkammo [gives full ammo]
function Console:Cmd_PKAMMO()
	if Game.GMode ~= GModes.SingleGame then return end
	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly) end
	if Player then
		Player.Ammo = Clone(CPlayer.s_SubClass.Ammo)
		CONSOLE.AddMessage(TXT.Cheats.PKAmmo)
	end
end
--=======================================================================
-- pkweapons [gives all weapons]
function Console:Cmd_PKWEAPONS()
	if Game.GMode ~= GModes.SingleGame then return end
	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly) end
	if Player then
        Player.EnabledWeapons = Clone(CPlayer.EnabledWeapons)
        Player.Ammo = Clone(CPlayer.s_SubClass.Ammo)
        CONSOLE.AddMessage(TXT.Cheats.PKWeapons)
    end
end
--=======================================================================
-- pkhealth [current armor regenerates, if health < 100 then health = 100]
function Console:Cmd_PKHEALTH()
	if Game.GMode ~= GModes.SingleGame then return end
	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly) end
	if Player then
		if Player.Health < Game.HealthCapacity then
			Player.Health = Game.HealthCapacity
		end

		local t = nil
		local atype = Player.ArmorType
		if atype == ArmorTypes.Weak then t = Templates["ArmorWeak.CItem"] end
		if atype == ArmorTypes.Medium then t = Templates["ArmorMedium.CItem"]  end
		if atype == ArmorTypes.Strong then t = Templates["ArmorStrong.CItem"]  end

		if t then Player.Armor = t.ArmorAdd end

		CONSOLE.AddMessage(TXT.Cheats.PKHealth)
	end
end
--=======================================================================
-- pkpower [pkammo + pkhealth together]
function Console:Cmd_PKPOWER()
	if Game.GMode ~= GModes.SingleGame then return end
	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly) end
	self:Cmd_PKAMMO()
	self:Cmd_PKHEALTH()
end
--=======================================================================
-- pkgod [monsters can't hurt you - on/off toggle]
function Console:Cmd_PKGOD()
	if Game.GMode ~= GModes.SingleGame then return end
	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly); return end
	if GOD == true then
		GOD = false
		CONSOLE.AddMessage(TXT.Cheats.PKGodOff)
	else
		GOD = true
		CONSOLE.AddMessage(TXT.Cheats.PKGodOn)
	end
end
--=======================================================================
-- pkalwaysgib [always gib the enemy - on/off toggle]
function Console:Cmd_PKALWAYSGIB()
	if Game.GMode ~= GModes.SingleGame then return end
	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly); return end
	
	if not Game.Cheat_AlwaysGib then
		Game.Cheat_AlwaysGib = true
		CONSOLE.AddMessage(TXT.Cheats.PKGibOn)
	else
		Game.Cheat_AlwaysGib = false
		CONSOLE.AddMessage(TXT.Cheats.PKGibOff)
	end
end
--=======================================================================
-- pkweakenemies [all monsters have 1 HP - on/off toggle]
function Console:Cmd_PKWEAKENEMIES()
	if Game.GMode ~= GModes.SingleGame then return end
	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly); return end

	if not Game.Cheat_WeakEnemies then
		Game.Cheat_WeakEnemies = true
		CONSOLE.AddMessage(TXT.Cheats.PKWeakOn)
	else
		Game.Cheat_WeakEnemies = false
		CONSOLE.AddMessage(TXT.Cheats.PKWeakOff)
	end
end
--=======================================================================
-- pkcards [unlimited Golden Cards use]
function Console:Cmd_PKCARDS()
	if IsFinalBuild() then return end
	if Game.GMode ~= GModes.SingleGame then return end
	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly); return end
	Game.GoldenCardsUseUnlimited = true
	CONSOLE.AddMessage(TXT.Cheats.PKCards)
end
--=======================================================================
-- pkgold [99999 gold]
function Console:Cmd_PKGOLD()
	if Game.GMode ~= GModes.SingleGame then return end
	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly); return end
	if Game then Game.PlayerMoney = 99999 end
	MBOARD.SetCashCheat(99999)
	CONSOLE.AddMessage(TXT.Cheats.PKGold)
end
--=======================================================================
-- pkhaste [Haste x 8 - on/off toggle]
function Console:Cmd_PKHASTE()
	if Game.GMode ~= GModes.SingleGame then return end
	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly); return end

	if Game.BulletTime == true then
		Game:EnableBulletTime(false)
		CONSOLE.AddMessage(TXT.Cheats.PKHasteOff)
	else
		local slow = Game.BulletTimeSlowdown
		Game.BulletTimeSlowdown = 1/8
		Game:EnableBulletTime(true)
		Game.BulletTimeSlowdown = slow
		CONSOLE.AddMessage(TXT.Cheats.PKHasteOn)
	end
end
--=======================================================================
-- pkdemon [Demon Morph - on/off toggle]
function Console:Cmd_PKDEMON()
	if Game.GMode ~= GModes.SingleGame then return end
	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly); return end
	if Game.IsDemon then
		Game:EnableDemon(false)
		CONSOLE.AddMessage(TXT.Cheats.PKDemonOff)
	else
		Game:EnableDemon(true)
		CONSOLE.AddMessage(TXT.Cheats.PKDemonOn)
	end
end
--=======================================================================
-- pkweaponmodifier [enables weapon modifier]
function Console:Cmd_PKWEAPONMODIFIER()
	if Game.GMode ~= GModes.SingleGame then return end
	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly); return end
	if Player then
		if Player.HasWeaponModifier == false then
			Player.HasWeaponModifier = true
			Player._WeaponModifierCounter = 9999999
			CONSOLE.AddMessage(TXT.Cheats.PKWeapModOn)
		else
			Player.HasWeaponModifier = false
			Player._WeaponModifierCounter = 0
			CONSOLE.AddMessage(TXT.Cheats.PKWeapModOff)
		end
    end
end
--=======================================================================
-- pkalllevels [enables all levels]
--function Console:Cmd_PKALLLEVELS()
--	if IsFinalBuild() then return end
--	if Game.GMode ~= GModes.SingleGame then return end
--	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly); return end
--	for i=1,table.getn(Levels) do
--		for j=1,table.getn(Levels[i]) do
--			Game:MakeEmptyLevelStats(Levels[i][j][1])
--			Game.LevelsStats[Levels[i][j][1]].Finished = true
--		end
--	end
--	CONSOLE.AddMessage(TXT.Cheats.PKAllLevels)
--	PMENU.SwitchToMenu()
--	PMENU.SwitchToMap()
--end
--=======================================================================
-- pkallcards [gives all black tarot cards]
--function Console:Cmd_PKALLCARDS()
--	if IsFinalBuild() then return end
--	if Game.GMode ~= GModes.SingleGame then return end
--	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly); return end
--	for i=1,table.getn(Game.CardsAvailable) do
--		Game.CardsAvailable[i] = true
--	end
--	CONSOLE.AddMessage(TXT.Cheats.PKAllCards)
--	PMENU.SwitchToMap()
--	PMENU.SwitchToBoard()
--end
--=======================================================================
-- pkkeepbodies [bodies never disappear - on/off toggle]
function Console:Cmd_PKKEEPBODIES()
	if Game.GMode ~= GModes.SingleGame then return end
	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly); return end
	if Game.Cheat_KeepBodies then
		Game.Cheat_KeepBodies = false
		CONSOLE.AddMessage(TXT.Cheats.PKKeepBodiesOff)
	else
		Game.Cheat_KeepBodies = true
		CONSOLE.AddMessage(TXT.Cheats.PKKeepBodiesOn)
	end
end
--=======================================================================
-- pkkeepdecals [decals never wear off - on/off toggle]
function Console:Cmd_PKKEEPDECALS()
	if Game.GMode ~= GModes.SingleGame then return end
	if Game.Difficulty > 1 then CONSOLE.AddMessage(TXT.Cheats.LowLevelOnly); return end
	if Game.Cheat_KeepDecals then
		Game.Cheat_KeepDecals = false
		CONSOLE.AddMessage(TXT.Cheats.PKKeepDecalsOff)
	else
		Game.Cheat_KeepDecals = true
		CONSOLE.AddMessage(TXT.Cheats.PKKeepDecalsOn)
	end
	
	R3D.KeepDecals(Game.Cheat_KeepDecals)
end
--=======================================================================
-- pkperfect [finish level with perfect score]
--[[
function Console:Cmd_PKPERFECT()
	if IsFinalBuild() then return end
	if Game.GMode ~= GModes.SingleGame then return end
	Player.ArmorFound = Game.TotalArmor
	Player.HolyItems = Game.TotalHolyItems
	Game.PlayerAmmoFound = Game.TotalAmmo
	Game.PlayerDestroyedItems = Game.TotalDestroyed
	Player.SecretsFound = Game.TotalSecrets
	GObjects:Add(TempObjName(),CloneTemplate("EndLevel.CProcess"))
end
]]--
--=======================================================================
-- MP Server
--=======================================================================
--asd = 1
function Console:Cmd_SERVER(name)

    if IsFinalBuild() then return end
    if name == nil then 
        CONSOLE.AddMessage('server map_name') 
    else
        if PMENU.StartServer( Cfg.PlayerName, "", name, 1, 3455 ) then
            NET.LoadMapOnServer(name)
        end
    end
    CONSOLE.AddMessage("server started on map:  "..Lev._Name) 

    --CONSOLE.AddMessage(asd) 
    --Game:Print(asd)
    --asd = asd +1
end
--=======================================================================
function Console:Cmd_CONNECT(ip)
--  if IsFinalBuild() then return end
	if ip == nil then
		CONSOLE.AddMessage('connect ip:port')
	else
		local host = nil
		local port = nil

		for h,p in string.gfind( ip, "(.+):(.+)" ) do
			host = h
			port = p
		end

		if host == nil and port == nil then
			host = ip
			port = 3455
		end

		if host ~= nil and port ~= nil then
			PMENU.JoinServer( Cfg["PlayerName"], "", 1, host, port, true )
			CONSOLE.Activate( false )
		end
	end
end
--=======================================================================
-- MOUSE
--=======================================================================
function Console:Cmd_MSENSITIVITY(val)
    val = tonumber(val)    
    if val == nil then 
        CONSOLE.AddMessage('msensitivity value  (sets mouse sensitivity)') 
    elseif type(val) == "number" then
        if val < 201 and val >= 0 then
			Cfg.MouseSensitivity = val
			MOUSE.SetSensitivity(Cfg.MouseSensitivity)
		end
    end
    
    CONSOLE.AddMessage("current mouse sensitivity:  "..Cfg.MouseSensitivity) 
end
--=======================================================================
function Console:Cmd_MSMOOTH(enable)
    enable = tonumber(enable)    
    if enable == nil then 
        CONSOLE.AddMessage('msmooth value  (enables smooth mouse)') 
    end
    
    if enable == 1 then  Cfg.SmoothMouse = true  end
    if enable == 0 then  Cfg.SmoothMouse = false end
    
    MOUSE.SetSmooth(Cfg.SmoothMouse)            
    
    if Cfg.SmoothMouse then
        CONSOLE.AddMessage("smooth mouse is enabled") 
    else
        CONSOLE.AddMessage("smooth mouse is disabled") 
    end
end
--=======================================================================
function Console:Cmd_FOV(val)
    
    val = tonumber(val)    
    if val == nil then 
        CONSOLE.AddMessage("fov value  (sets camera's FOV)") 
    elseif type(val) == "number" then
        Cfg.FOV = val
        PainMenu.cameraFOV = val
    end
    
    R3D.SetCameraFOV(Cfg.FOV)
    
    CONSOLE.AddMessage("current fov:  "..Cfg.FOV)     	
end
--=======================================================================
function Console:Cmd_CAMERAINTERPOLATION(enable)
    enable = tonumber(enable)    
    if enable == nil then 
        CONSOLE.AddMessage("camerainterpolation 0/1  (disables/enables camera interpolation for MP clients)") 
    end    
    
    if enable == 1 then Cfg.CameraInterpolation = true  end    
    if enable == 0 then Cfg.CameraInterpolation = false end

    CAM.EnableInterpolation(Cfg.CameraInterpolation)
    
    if Cfg.CameraInterpolation then
        CONSOLE.AddMessage("camera interpolation is enabled") 
    else
        CONSOLE.AddMessage("camera interpolation is disabled") 
    end
end
--=======================================================================
function Console:Cmd_EXIT()
    Exit()
end
--=======================================================================
function Console:Cmd_QUIT()
    Exit()
end
--=======================================================================
function Console:Cmd_TPP(enable,view)
    if IsFinalBuild() then return end
    enable = tonumber(enable)    
    view = tonumber(view)    

    if enable == nil then 
        CONSOLE.AddMessage("third person view [1/0]") 
    end

    if enable == 1 then Game.TPP = true end
    if enable == 0 then Game.TPP = false end
    if view == 1 then Game.TPPView = true end
    if view == 0 then Game.TPPView = false end

    if Player and Player._Entity then ENTITY.EnableDraw(Player._Entity,Game.TPP) end
    
    if Game.TPP then
        CONSOLE.AddMessage("current state: on") 
    else
        CONSOLE.AddMessage("current state: off") 
    end
end
--=======================================================================
function Console:Cmd_TIMELIMIT(val)
    val = tonumber(val)    
    if val == nil then 
        CONSOLE.AddMessage('timelimit value  (sets time limit)') 
    elseif type(val) == "number" then
        Cfg.TimeLimit = val
        if Game:IsServer() then
            Game.SetFragAndTimeLimit(Cfg.FragLimit,Cfg.TimeLimit,Game._TimeLimitOut) 
        end
    end
    
    CONSOLE.AddMessage("current time limit:  "..Cfg.TimeLimit) 
end
--=======================================================================
function Console:Cmd_FRAGLIMIT(val)
    val = tonumber(val)    
    if val == nil then 
        CONSOLE.AddMessage('fraglimit value  (sets frag limit)') 
    elseif type(val) == "number" then        
        Cfg.FragLimit = val
        if Game:IsServer() then
            Game.SetFragAndTimeLimit(Cfg.FragLimit,Cfg.TimeLimit,Game._TimeLimitOut) 
        end
    end
    
    CONSOLE.AddMessage("current frag limit:  "..Cfg.FragLimit) 
end
--=======================================================================
function Console:Cmd_WEAPONRESPAWNTIME(val)
    val = tonumber(val)    
    if val == nil then 
        CONSOLE.AddMessage('weaponrespawntime value  (sets weapon respawn time)') 
    elseif type(val) == "number" then
        Cfg.WeaponRespawnTime = val
    end
    
    CONSOLE.AddMessage("current weapon respawn time:  "..Cfg.WeaponRespawnTime)
end
--=======================================================================
function Console:Cmd_CROSSHAIR(val)
    val = tonumber(val)    
	if val == nil then 
		CONSOLE.AddMessage('crosshair value [1-32] (changes crosshair)')
    elseif type(val) == "number" then
		if val <= 32 and val > 0 then
			Cfg.Crosshair = val
			Cfg:Save()
		end
    end

    CONSOLE.AddMessage("current crosshair:  "..Cfg.Crosshair)
end
--=======================================================================
function Console:Cmd_HUDSIZE(val)
    
    val = tonumber(val)    
    if val == nil then
        CONSOLE.AddMessage("hudsize value  (sets HUD size)") 
    elseif type(val) == "number" then
		if val > 3.0 then
			Cfg.HUDSize = 3.0
		elseif val <= 0 then
			Cfg.HUDSize = 0.1
		else
			Cfg.HUDSize = val
		end
    end
    
    CONSOLE.AddMessage("current HUD size:  "..Cfg.HUDSize)     	
end
--=======================================================================
function Console:Cmd_SPEEDMETER(enable)
    enable = tonumber(enable)    
    if enable == nil then 
        CONSOLE.AddMessage("shows speed meter [1/0]") 
    end
   
    if enable == 1 then Tweak.PlayerMove.ShowSpeedmeter = true  end
    if enable == 0 then Tweak.PlayerMove.ShowSpeedmeter = false end

    if Tweak.PlayerMove.ShowSpeedmeter then
        CONSOLE.AddMessage("current state: on") 
    else
        CONSOLE.AddMessage("current state: off") 
    end
end
--=======================================================================
--[[
function Console:Cmd_BULLETTIME(enable)
    if IsFinalBuild() then return end
    enable = tonumber(enable)    
    if enable == nil then 
        CONSOLE.AddMessage("enables bullet time [1/0]") 
    end

    if enable == 1 then Game:EnableBulletTime(true) end
    if enable == 0 then Game:EnableBulletTime(false) end
end
]]--
--=======================================================================
function Console:Cmd_NAME(name)
    if name == nil then 
        CONSOLE.AddMessage('name "nick" (changes player name)') 
    else
        Cfg.PlayerName = HUD.ColorSubstr(tostring(name),16)
        Cfg.PlayerName = string.gsub(Cfg.PlayerName, "$KILLER", "KILLER")
        Cfg.PlayerName = string.gsub(Cfg.PlayerName, "$PLAYER", "PLAYER")
        if Player and Game.GMode ~= GModes.SingleGame then        
            Game.NewPlayerNameRequest(Player.ClientID,Cfg.PlayerName)
        end
    end
    
    if Game.GMode == GModes.SingleGame and CONSOLE.IsActive() then        
        CONSOLE.AddMessage("current player name:  "..Cfg.PlayerName) 
    end
end
--=======================================================================
function Console:Cmd_POS(x,y,z)
    x = tonumber(x)    
    y = tonumber(y)    
    z = tonumber(z)    
    if x then GX = x end
    if y then GY = y end
    if z then GZ = z end
    CONSOLE.AddMessage(GX.." "..GY.." "..GZ)
end
--=======================================================================
function Console:Cmd_ROT(x,y,z)
    x = tonumber(x)    
    y = tonumber(y)    
    z = tonumber(z)    
    if x then GAX = x end
    if y then GAY = y end
    if z then GAZ = z end
    CONSOLE.AddMessage(GAX.." "..GAY.." "..GAZ)
end
--=======================================================================
function Console:Cmd_WEAPONSPECULAR(enable)
	enable = tonumber(enable)    
    if enable == nil then 
        CONSOLE.AddMessage("enables weapon specular [1/0]") 
    end

    if enable == 1 then Cfg.WeaponSpecular = true end
    if enable == 0 then Cfg.WeaponSpecular = false end
    
    PainMenu:ReloadWeaponsTextures()
end
--=======================================================================
function Console:Cmd_DEMOPLAY(filename)
    if filename == nil then
        CONSOLE.AddMessage("Usage: demoplay <filename_to_play_from>") 
    else
        NET.DemoPlay(filename)
    end
end
--=======================================================================
function Console:Cmd_DEMORECORD(filename)
    if filename == nil then
        CONSOLE.AddMessage("Usage: demorecord <filename_to_record_in>") 
    else
        NET.DemoRecord(filename)
        CONSOLE.AddMessage("Demo recording scheduled") 
    end
end
--=======================================================================
function Console:Cmd_DEMOSTOP()
    if Game.GMode ~= GModes.SingleGame then
        NET.DemoStop(filename)
        CONSOLE.AddMessage("Demo stopped")
    end
end
--=======================================================================
function Console:Cmd_SHOWFPS(show)
	show = tonumber(show)
	if show == nil then
		CONSOLE.AddMessage("enables FPS display [1/0]")
		return
	end

	if show == 1 then 
	Hud._showFPS = true 
	Cfg.ShowFPS = true
	end
	if show == 0 then 
	Hud._showFPS = false 
	Cfg.ShowFPS = false
	end
end
--=======================================================================
--[[
function Console:Cmd_USEDINPUT(enable)
	if IsFinalBuild() then return end
    enable = tonumber(enable)    
    if enable == nil then 
        CONSOLE.AddMessage("enable/disable DirectInput usage [1/0]") 
    end

    if enable == 1 then INP.SetUseDInput(true)  end
    if enable == 0 then INP.SetUseDInput(false) end

    if INP.GetUseDInput() then
        CONSOLE.AddMessage("current state: on") 
    else
        CONSOLE.AddMessage("current state: off") 
    end
end
--=======================================================================
function Console:Cmd_DIDELTASCALE(scale)
	if IsFinalBuild() then return end
    scale = tonumber(scale)
    if scale == nil then 
        CONSOLE.AddMessage("set DInput delta scale") 
    else
		INP.SetDIDeltaScale(scale)
    end

	scale = INP.GetDIDeltaScale()
    CONSOLE.AddMessage("current scale: "..scale) 
end
]]--
--=======================================================================
function Console:OnCommand(cmd)
    local exist = false
    local dontshowerror = false -- cubik's variable
    cmd = Trim(cmd)
    if cmd == "" then return end
    local i = string.find(cmd," ",1,true)
    if not i then i = string.len(cmd) + 1 end
    if i > 2 then
        local func = string.sub(cmd,1,i-1)
        func = string.upper(func)
        if Console["Cmd_"..func] then
        --dontshowerror = true
        -- cubik: still testing, disables most of the commands
        --if func == "MAP" or func == "RELOADMAP" or func == "TEAM" or func == "SPECTATOR" or func == "READY" or func == "NOTREADY" or func == "BREAK" or func == "KICK" or func == "BANKICK" or func == "KICKID" or func == "BANKICKID" or func == "CALLVOTE" or func == "VOTE" or func == "DISCONNECT" or func == "RECONNECT" or func == "CONNECT" or func == "QUIT" or func == "DEMOPLAY" or func == "DEMOSTOP" or func == "DEMORECORD" then
		------------------------------------------------------
        	local params = string.sub(cmd,i+1)

			local semicolon = string.find(params,";")
			if semicolon and func ~= "BIND" then
				local part = string.sub(params,1,semicolon)
				local second = string.sub(params,semicolon+1)
				params = string.sub(params,1,semicolon-1)
				Console:OnCommand(func.." "..params)
				Console:OnCommand(second)
				return
			end

			local args = {}
			params = Trim(params)
			for w in string.gfind(params, "[%w~`!@#$%%^&*()%-\" _=%.%+\\|{}%[%]<>?/]+") do
				table.insert(args,w)
			end

			if func ~= "CALLVOTE" and func ~= "BIND" then
				Console["Cmd_"..func](self,unpack(args))
			else
				Console["Cmd_"..func](self,params)
			end
            Cfg:Save()
            return
        ------------------------------------------------------
        --else
        --	CONSOLE.AddMessage("This command is disabled.")
        --end
        -- cubik: ends here
        end
    end
    -- I added a check for this, dunno why it didnt work without :/
    --if dontshowerror == false then
    	if Game.GMode == GModes.SingleGame then
    		CONSOLE.AddMessage("Unknown command: ".. cmd)
		else        
        	cmd = string.sub(cmd,1,200)    
        	Game.SayToAll(NET.GetClientID(), cmd) 
    	end
    --end
end
--=======================================================================
function Console:OnPrompt(txt)
    txt = Trim(txt)
    if txt == "" then return end
    
    txt = string.upper(txt)
    for a,o in self do
        if type(o) == "function" then
            local i = string.find(a,"Cmd_",1,true)
            if i and string.find(a,txt,5,true) == 5 then
                CONSOLE.SetCurrentText(string.lower(string.sub(a,5)).." ") 
                break
            end
        end
    end
end
--=======================================================================