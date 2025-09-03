--============================================================================
PSpectatorControler = {
    player = -1,
    angX = 0,
    angY = 0,
    mode = 0,
    _entCam = nil,
    _Class = "CProcess",
}
Inherit(PSpectatorControler,CProcess)
--============================================================================
function PSpectatorControler:New()
    local p = Clone(PSpectatorControler)
    p.BaseObj = "PSpectatorControler"
    return p
end
--============================================================================
function PSpectatorControler:SetPlayerVisibility(e,enable,state)
     
    ENTITY.EnableDraw(e,enable,true)    
    
    --[[
    MDL.SetMeshVisibility(e,"-all-",true)
    
    if enable then
        MDL.SetMeshVisibility(e,"PKW_korpusShape",false)
        MDL.SetMeshVisibility(e,"PKW_HeadShape",false)
        MDL.SetMeshVisibility(e,"ASG_bodyShape",false)
        MDL.SetMeshVisibility(e,"stake",false)
        MDL.SetMeshVisibility(e,"rl",false)
        MDL.SetMeshVisibility(e,"pCylinderShape1",false)
        MDL.SetMeshVisibility(e,"pCylinderShape2",false)
        MDL.SetMeshVisibility(e,"polySurfaceShape450",false)
        MDL.SetMeshVisibility(e,"polySurfaceShape455",false)
    end
    
    if state then
        -- painkiller
        if state == 1 or state == 11 or state == 12 or state == 13 then
            MDL.SetMeshVisibility(e,"PKW_korpusShape",enable)
        end
        -- shotgun
        if state == 2 or state == 21 then
            MDL.SetMeshVisibility(e,"ASG_bodyShape",enable)
        end
        -- stakegun
        if state == 3 or state == 31 then
            MDL.SetMeshVisibility(e,"stake",enable)
        end            
        -- minigun
        if state == 4 or state == 41 then
            MDL.SetMeshVisibility(e,"rl",enable)
        end
        -- spawara
        if state == 5 or state == 51 then
            MDL.SetMeshVisibility(e,"pCylinderShape1",enable)
            MDL.SetMeshVisibility(e,"pCylinderShape2",enable)
            MDL.SetMeshVisibility(e,"polySurfaceShape450",enable)
            MDL.SetMeshVisibility(e,"polySurfaceShape455",enable)
        end
    end
    
    if not enable then
        MDL.SetMeshVisibility(e,"-invert-")
    end 
    --]]    
end
--============================================================================
function PSpectatorControler:Init()
    Hud.Enabled = false
    MOUSE.Lock(true)
    self._entCam =  ENTITY.Create(ETypes.Mesh,"../Data/Items/granat.dat","polySurfaceShape234",1)   
    ENTITY.PO_Create(self._entCam,BodyTypes.Sphere,0.3,ECollisionGroups.InsideItems)
    ENTITY.PO_EnableGravity(self._entCam,false)
    ENTITY.PO_SetMovedByExplosions(self._entCam, false) 
    ENTITY.PO_HideFromPrediction(self._entCam)
    ENTITY.SetPosition(self._entCam,Lev.Pos.X,Lev.Pos.Y,Lev.Pos.Z)
end
--============================================================================
function PSpectatorControler:Delete()
    local ps = Game.PlayerStats[self.player]
    if ps and ps._Entity and ps._Entity ~=0 and ps.Spectator == 0 then            
        self:SetPlayerVisibility(ps._Entity,true)
    end
end
--============================================================================
function PSpectatorControler:NextPlayer(tab,idx)
    local getnext
    for i,o in tab do
		self:SetPlayerVisibility(o._Entity,true)
        if getnext and o.Spectator == 0 then
            -- next
            return i,o
        end
        if idx == i then
          getnext = true  
        end
    end
    -- first
    for i,o in tab do
        if o.Spectator == 0 then
            return i,o
        end
    end    
end
--============================================================================
function PSpectatorControler:Tick2(delta)        
    if not MOUSE.IsLocked() then return end
    
    local dx,dy = MOUSE.GetDelta()
    if Cfg.InvertMouse then dy = - dy end
    if self.player  == -1 then
        local ax,ay,az = CAM.GetAng()
        ax = ax + dx        
        ay = ay + dy
        
        if ay > 80  then  ay = 80 end
        if ay < -80 then  ay = -80 end
    
        CAM.SetAng(ax,ay,az)
    
        local ox,oy,oz = CAM.GetPos()
        local move = Vector:New(0,0,0)
        -- Camera movement
        if INP.Action(Actions.Forward) then 
            local x,y,z = CAM.GetForwardVector() 
            move:Add(x,y,z)
        end
        if INP.Action(Actions.Backward) then 
            local x,y,z = CAM.GetForwardVector()
            move:Sub(x,y,z)
        end
        if INP.Action(Actions.Right) then 
            local x,y,z = CAM.GetRightVector() 
            move:Add(x,y,z)
        end
        if INP.Action(Actions.Left) then 
            local x,y,z = CAM.GetRightVector() 
            move:Sub(x,y,z)
        end                    
        move:Normalize()
        ENTITY.SetVelocity(self._entCam,move.X*15,move.Y*15,move.Z*15)
        
        local x,y,z = ENTITY.GetWorldPosition(self._entCam)    
        CAM.SetPos(x,y,z)        
    else    
        local ps = Game.PlayerStats[self.player]
        if ps and ps._Entity and ps._Entity ~=0 and ps.Spectator == 0 then            
            if self.mode == 1 and ps._animproc then
				self:SetPlayerVisibility(ps._Entity,false,ps._animproc.State)
                local ap = ps._animproc                
                local x,y,z = ENTITY.PO_GetPawnHeadPos(ps._Entity) 
                local a = ENTITY.GetOrientation(ps._Entity)
                CAM.SetAng(-a / (math.pi/180) - 180, ap._LastYaw / (math.pi/180), 0)
                CAM.SetPos(x,y,z)
            else
				self:SetPlayerVisibility(ps._Entity,true,ps._animproc.State)
                local v = Vector:New(0,0,8)
                self.angX = self.angX + dy/40
                self.angY = self.angY + dx/40
                v:Rotate(self.angX,self.angY,0)
                
                local px,py,pz = ENTITY.GetPosition(ps._Entity)
                py = py + 0.8
                local b,d,x,y,z = WORLD.LineTraceFixedGeom(px,py,pz,px+v.X, py+v.Y, pz+v.Z)
                if not b then
                    x,y,z = px+v.X, py+v.Y, pz+v.Z
                else
                    v:Normalize()
                    x,y,z = x-v.X*0.3,y-v.Y*0.3,z-v.Z*0.3
                end
                CAM.SetPos(x,y,z)
                CAM.SetAngRad(-self.angY,-self.angX,0)
            end
            
            --CAM.LookAt(px-0.01, py-0.01, pz-0.01)
        end
    end

    if INP.Action(Actions.Fire) then
        if not self._fire then
            Game:Print(self.player)
            self.player = self:NextPlayer(Game.PlayerStats,self.player)
            if not self.player then self.player = -1 end
            Game:Print(self.player)
        end
        self._fire = true
    else
        self._fire = nil
    end

    if INP.Action(Actions.AltFire) then
        if not self._altfire then
            self.player = -1
        end
        self._altfire = true
        for i,o in Game.PlayerStats do
			self:SetPlayerVisibility(o._Entity,true)
		end
    else
        self._altfire = nil
    end

    
    if INP.Action(Actions.NextWeapon) then
--    if INP.Key(Keys.MouseWheelForward) == 1 then
        self.mode = 0
    end
    
    if INP.Action(Actions.PrevWeapon) then
--    if INP.Key(Keys.MouseWheelBack) == 1 then
        self.mode = 1
    end    

	if INP.Action(Actions.Jump) then
        INP.Reset()
        MPSTATS.Hide()
        if Game._procStats then
			GObjects:ToKill(Game._procStats)
			Game._procStats = nil
		end
--    if INP.Key(Keys.Space) == 1 then
        Game.PlayerSpectatorRequest(NET.GetClientID(),0)
    end
end
--============================================================================
function PSpectatorControler:PostRender(delta)
	local w,h = R3D.ScreenSize()
	HUD.DrawBorder(312,20,400,60)
	HUD.PrintXY(-1,40*h/768,Languages.Texts[723],"timesbd",230,161,97,26)

    HUD.PrintXY(10*w/1024+1,h-60*h/768+1,Languages.Texts[724],"timesbd",10,10,10,26)
    HUD.PrintXY(10*w/1024,h-60*h/768,Languages.Texts[724],"timesbd",230,161,97,26)

    HUD.PrintXY(10*w/1024+1,h-30*h/768+1,Languages.Texts[732],"timesbd",10,10,10,26)
    HUD.PrintXY(10*w/1024,h-30*h/768,Languages.Texts[732],"timesbd",230,161,97,26)

    HUD.PrintXY(w-HUD.GetTextWidth(Languages.Texts[725])-10*w/1024+1,h-60*h/768+1,Languages.Texts[725],"timesbd",10,10,10,26)
    HUD.PrintXY(w-HUD.GetTextWidth(Languages.Texts[725])-10*w/1024,h-60*h/768,Languages.Texts[725],"timesbd",230,161,97,26)

    HUD.PrintXY(w-HUD.GetTextWidth(Languages.Texts[726])-10*w/1024+1,h-30*h/768+1,Languages.Texts[726],"timesbd",10,10,10,26)
    HUD.PrintXY(w-HUD.GetTextWidth(Languages.Texts[726])-10*w/1024,h-30*h/768,Languages.Texts[726],"timesbd",230,161,97,26)

    local ps = Game.PlayerStats[self.player]
    if ps then
        HUD.PrintXY((w-HUD.GetTextWidth(ps.Name))/2+1,h-30*h/768+1,ps.Name,"timesbd",10,10,10,26)
        HUD.PrintXY((w-HUD.GetTextWidth(ps.Name))/2,h-30*h/768,ps.Name,"timesbd",230,161,97,26)
    end
end
--============================================================================
function PSpectatorControler:Teleport(x,y,z,a) 
    ENTITY.SetPosition(self._entCam,x,y,z)
    ENTITY.SetOrientation(self._entCam,a)
    CAM.SetAng(-a / (math.pi/180) - 180, 0, 0)
end
--============================================================================
