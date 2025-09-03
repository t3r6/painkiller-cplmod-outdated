--============================================================================
-- Complex Action Class
--============================================================================
CAction = 
{    
    Sequence = {},    

    _Processes = {},
    _CSequence = {},

    _Time = 0,
    _ObjParent = nil,
    _KillIF = nil,
    _Waiting = false,
    _Last = 0,
    _Class = "CAction",
    _BodyCountTotal, -- private counter for WaitForCorpses
}
Inherit(CAction,CObject)
--============================================================================
function CAction:New(sequence,obj)
    local a = Clone(CAction)
    a.Sequence = Clone(sequence)
    a._ObjParent = obj
    return a
end
--============================================================================
function CAction:Delete()
end
--============================================================================
function CAction:Apply(old) 
    self._Time = 0
    self._Last = 0
    self:CompileSequence()
    self._BodyCountTotal = Game.BodyCountTotal
end
--============================================================================
function CAction:RestoreFromSave()     
    self:CompileSequence()
    for i,v in self._Processes do    
        if v.RestoreFromSave then v:RestoreFromSave() end
    end
end
--============================================================================
function CAction:CompileSequence()     
    if self._KillIFStr then 
        self._KillIF = loadstring("if "..self._KillIFStr.." then return true else return false end") 
    end    
    self._CSequence = Clone(self.Sequence)
    if table.getn(self.Sequence) == 0 then self._Count = 0; return end
    if type(self._CSequence[1][1]) == "number" then 
        table.sort(self._CSequence,function(a,b) return a[1]<b[1] end)
    else
        for i,v in self._CSequence do
            table.insert(v,1,0)
        end
    end    
        
    for i,v in self._CSequence do
        local s = self._CSequence[i][2]        
        
        local fnc = ""
        if string.find(s,":",1,true) then
            fnc = "return CAction.Action_" .. s .. ")"
            fnc = string.gsub(fnc,':','('..self._Name..',')        
        else
            fnc = "return CAction.Action_" .. s .. "(" .. self._Name  .. ")"
        end        
        if string.sub(s,1,2) == "L:" then -- LUA Script
            fnc = string.gsub(s,'L:','')        
        end        
        
        self._CSequence[i][4] = loadstring(fnc)
    end
    self._Count = table.getn(self._CSequence)
end
--============================================================================
function CAction:Update()       
    if self.Frozen then return end
    for i,v in self._Processes do    
        if v.Update then v:Update() end
        -- sprawdzic jak ten remove zadziala w petli
        if v._ToKill then table.remove(self._Processes,i) end
    end

    o = self
    p = self._ObjParent
    a = self.arg
    if self._KillIF and self:_KillIF() then 
        --MsgBox("killif")
        GObjects:ToKill(self) 
    end
end
--============================================================================
--function CAction:Render()       
--    for i,v in self._Processes do 
--        if v.Render then v:Render() end
--    end
--end
--============================================================================
function CAction:Tick(delta)
  
    if self.Frozen then return end
    -- sprawdzam czy przestal oczekiwac
    self._Waiting = false
    for i,v in self._Processes do
        if v.Tick then v:Tick(delta) end
        if v.___IsWaitingProc then 
            self._Waiting = true
            break  
        end
    end    
    
    if self._Waiting then return end
       
    local ntime = self._Time + delta    
    for i = self._Last+1, self._Count do
        if self._CSequence[i][1] >= ntime then break end
        if self._CSequence[i][1] >= self._Time and self._CSequence[i][1] < ntime then            
            o = self
            p = self._ObjParent
            a = self.arg
            if self._ObjParent then
                px,py,pz = self._ObjParent.Pos:Get()
                pe = self._ObjParent._Entity 
            end
            local e = self._CSequence[i][4]() -- execute compiled code
            if self._CSequence[i][3] then 
                self[self._CSequence[i][3]] = e
            end
            self._Last = i      
            if self._Waiting then 
                ntime = self._Time
                break 
            end
        end
    end
    
    if table.getn(self._Processes) == 0 and (self._Last >= self._Count or self._Count==0) then 
        GObjects:ToKill(self) 
    end
    
    self._Time = ntime    
end
--============================================================================
-- ACTIONS
--============================================================================
function CAction:Action_Snd(x,y,z,sound,fstart,fend)
    PlaySound3D(sound,x,y,z,fstart,fend)
end
--============================================================================
function CAction:Action_OSnd(obj,sound,fstart,fend)
    PlaySound3D(sound,obj.Pos.X,obj.Pos.Y,obj.Pos.Z,fstart,fend)
end
--============================================================================
function CAction:Action_Snd2D(sound)
    PlaySound2D(sound)
end
--============================================================================
function CAction:Action_SetEnvFX(obj,fxName,sound)
    obj.ParticleFX = fxName
    if sound then
		obj.SoundLoop = sound
		if Lev._rain then
			SOUND2D.SetLoopCount(Lev._rain, 1)
			SOUND2D.Forget(Lev._rain, 1)
			SOUND2D.SetVolume(Lev._rain, 0, 1.0)
			Lev._rain = nil
		end
	end
end
--============================================================================
function CAction:Action_BindSound(entity,soundname,fstart,fend)
    if not entity then return end
    if type(entity) == "table" then 
        entity = entity._Entity        
    end
    local snd = ENTITY.Create(ETypes.Sound)
    WORLD.AddEntity(snd)
    ENTITY.RegisterChild(entity,snd,true,joint)
    if not fstart then 
        fstart = 5 
        fend = 10
    end
    SND.Setup3D(snd,soundname,fstart,fend,0)
    SND.Play(snd)
end
--============================================================================
function CAction:Action_UnbindAllSounds(entity)
    if not entity then return end
    if type(entity) == "table" then 
        entity = entity._Entity        
    end
    ENTITY.KillAllChildren(entity,ETypes.Sound)
end
--============================================================================
function CAction:Action_PSnd(sound,fstart,fend)
	if type(sound) == "table" then
		sound = sound[math.random(1,table.getn(sound))]
	end
    PlaySound3D(sound,p.Pos.X,p.Pos.Y,p.Pos.Z,fstart,fend)
end
--============================================================================
function CAction:Action_PFX(effect,scale,x,y,z)
    local v
    if x then 
        v = Vector:New(x,y,z) 
    else
        v = Clone(p.Pos)
    end
    local e = AddPFX(effect,scale,v)    
    return e
end
--============================================================================
function CAction:Action_PPFX(x,y,z,pfx,vx,vy,vz)
    local e = AddParticleFX(x,y,z,pfx)    
    ENTITY.SetScale(e,0.1)
    ENTITY.PO_Create(e,BodyTypes.Simple,0.05)
    if vx then 
        ENTITY.PO_Hit(e,0,0,0,vx/1000,vy/1000,vz/1000)  
    end
    return e
end
--============================================================================
function CAction:Action_EarthQuake(timeout,range,move,rot,x,y,z)
    if not x then
        x = PX
        y = PY
        z = PZ
    end
    Game._EarthQuakeProc:Add(x,y,z, timeout*30, range,move,rot, false) 
end
--============================================================================
function CAction:Action_Light(x,y,z,r,g,b,range1,range2,intensity,fin,fmax,fout)
    Log("Action_Light\n")
    local l = CreateLight(x,y,z,r,g,b,range1,range2,0)
    LIGHT.SetDynamicFlag(l)
    table.insert(self._Processes,PFadeInOutLight:New(l,intensity,fin,fmax,fout))
    return l
end
--============================================================================
function CAction:Action_Anim(obj,anim,loop,blend)
    if not obj then return end
    obj.Animation = ""
    obj:SetAnim(anim,loop,1,blend) 
end
--============================================================================
function CAction:Action_PAnim(anim,loop,blend)
    p.Animation = ""
    p:SetAnim(anim,loop,1,blend) 
end
--============================================================================
function CAction:Action_BindToJoint(entity,model,jointname,ox,oy,oz)
    if not entity then return end
    if type(entity) == "table" then 
        entity = entity._Entity
    end
    if type(model) == "table" then 
        model = model._Entity
    end
    local proc = PBindToJoint:New(entity,model,jointname,ox,oy,oz)
    table.insert(self._Processes,proc)
    return proc
end
--============================================================================
function CAction:Action_Kill(p)
    if not p then return end
    if type(p) == "table" then 
        GObjects:ToKill(p) 
        return
    end
    ENTITY.Release(p)
    -- to do - tu kasowac zmienna pod ktora byl przypisany obiekt
end
--============================================================================
function CAction:Action_SetImmortal(o,state)
    if not o then return end
    if state == nil then state = true end
    o.Immortal = state
end
--============================================================================
function CAction:Action_Launch(obj,...)
    if obj and obj.OnLaunch then 
        obj:OnLaunch(unpack(arg))
    end
end
--============================================================================
function CAction:Action_NewObj(template,scale,x,y,z)
    local obj = GObjects:Add(TempObjName(),CloneTemplate(template))
	obj.ObjOwner = self._ObjParent
    if x then 
        obj.Pos:Set(x,y,z)
    else
        if self._ObjParent then
            obj.Pos:Set(self._ObjParent.Pos)
        else
            obj.Pos:Set(self.Pos)        
        end
    end

    if scale then obj.Scale = obj.Scale * scale end
    
	obj:Apply()
	obj:Synchronize()
    return obj
end
--============================================================================
function CAction:Action_Pin(entity,pin)
    if not entity then return end
    if type(entity) == "table" then 
        entity = entity._Entity        
    end

    if pin == nil  then pin = true end    
    ENTITY.PO_SetPinned(entity,pin)
end
--============================================================================
function CAction:Action_Object(template,physic,x,y,z,orient,scale)
    local obj = GObjects:Add(TempObjName(),CloneTemplate(template))
	obj.ObjOwner = self._ObjParent

    if x then 
        obj.Pos:Set(x,y,z)
    else
        if self._ObjParent then
            obj.Pos:Set(self._ObjParent.Pos)
        else
            obj.Pos:Set(self.Pos)        
        end
    end

    if scale then obj.Scale = obj.Scale * scale end
    
	obj:Apply()
	obj:Synchronize()
    -- xxx ugly hack for spawn fx
    if orient then         
        local ox = x + math.sin(orient)*1.5
        local oz = z + math.cos(orient)*1.5
        ENTITY.SetOrientation(obj._Entity,orient)
        ENTITY.SetPosition(obj._Entity,ox,y,oz)
    end
    if not physic then ENTITY.PO_Enable(obj._Entity,false) end

    return obj
end
--============================================================================
function CAction:Action_Impulse(entity,vx,vy,vz,px,py,pz)
    if not entity then return end
    if type(entity) == "table" then 
        if not vx and entity.Impulse then
            vx,vy,vz = VectorRotateByQuat(0,0,entity.Impulse.Strength,entity.Impulse.Rot.W,entity.Impulse.Rot.X,entity.Impulse.Rot.Y,entity.Impulse.Rot.Z)
            px,py,pz = entity.Impulse.Pos.X, entity.Impulse.Pos.Y, entity.Impulse.Pos.Z
        end
        entity = entity._Entity        
    end
        
    ENTITY.PO_Enable(entity,true)
    ENTITY.PO_Activate(entity,true)
    if px then 
        local x,y,z  = ENTITY.GetPosition(entity)        
        px,py,pz = x+px,y+py,z+pz
        ENTITY.PO_Impulse(entity,px,py,pz,vx,vy,vz)
    else
        local x,y,z  = ENTITY.GetPosition(entity)        
        ENTITY.PO_Impulse(entity,x,y,z,vx,vy,vz)
    end
end
--============================================================================
function CAction:Action_EnableDeathZone(name,enable)
    WORLD.EnableDeathZone(name,enable)
end
--============================================================================
function CAction:Action_SetRagdollBreakablesThreshold(entity,val)
    if not entity then return end
    if type(entity) == "table" then 
        entity = entity._Entity        
    end
    MDL.SetRagdollBreakablesThreshold(entity,val)
end
--============================================================================
function CAction:Action_Velocity(entity,vx,vy,vz,avx,avy,avz)
    if not entity then return end
    if type(entity) == "table" then 
        entity = entity._Entity
    end
    ENTITY.PO_Enable(entity,true)
    ENTITY.PO_Activate(entity,true)
    ENTITY.SetVelocity(entity,vx,vy,vz)
    if avx then
        ENTITY.SetAngularVelocity(entity,avx,avy,avz)
    end
    --ENTITY.EnableCollisions(entity,false)
end
--============================================================================
function CAction:Action_Jump(entity,power,uppower)
    if not entity then return end
    if type(entity) == "table" then 
        if entity.Pinned then return end
        entity = entity._Entity        
    end
    
    local a = ENTITY.GetOrientation(entity)    
    local vx = math.cos(a)*0 - math.sin(a)*-1
    local vz = math.sin(a)*0 + math.cos(a)*1       

    --ENTITY.PO_Enable(entity,true)
    ENTITY.PO_SetFlying(entity,true)
    if not uppower then uppower = 0.7*power end
    ENTITY.SetVelocity(entity,vx*power,uppower,vz*power)
end
--============================================================================
function CAction:Action_WalkAndJump(obj,area,point,anim,pow,uppow)
    if not obj or obj._died then return end
    obj.__cg = ENTITY.PO_GetCollisionGroup(obj._Entity)
    local action = {
        {"AI:p,false"},
        {"WalkTo:p,a[1].Points[a[2]]"},
        {"WaitForWalk:p"},
        {"RotateTo:p,a[1].Points[a[2]].A"},
        {"WaitForRotate:p"},
        {"Anim:p,a[3]"},
        {"L:ENTITY.PO_SetCollisionGroup(p._Entity,7)"}, 
        {"Jump:p,a[4],a[5]"},
        {"Wait:0.6"},
        {"L:ENTITY.PO_SetCollisionGroup(p._Entity,p.__cg)"}, 
        {"Wait:0.2"},
        {"WaitForJump:p"},
        {"Wait:0.06"},			-- bo wykrywa podloge troche wczesniej i zeby pfx od walk nie odpalal sie za wysoko
        {"L:p:LaunchFullAnimEvent('walk')"}, 
        {"L:p:LaunchFullAnimEvent('walk')"}, 
        {"AI:p,true"}, 
    }
    AddAction(action,obj,"p._died",area,point,anim,pow,uppow)
end
--============================================================================
function CAction:Action_RunAndJump(obj,area,point,anim,pow,uppow)
    if not obj or obj._died then return end
    obj.__cg = ENTITY.PO_GetCollisionGroup(obj._Entity)
    local action = {
        {"AI:p,false"},
        {"RunTo:p,a[1].Points[a[2]]"},
        {"WaitForWalk:p"},
        {"RotateTo:p,a[1].Points[a[2]].A"},
        {"WaitForRotate:p"},
        {"Anim:p,a[3]"},
        {"L:ENTITY.PO_SetCollisionGroup(p._Entity,7)"}, 
        {"Jump:p,a[4],a[5]"},
        {"Wait:0.6"},
        {"L:ENTITY.PO_SetCollisionGroup(p._Entity,p.__cg)"}, 
        {"Wait:0.2"},
        {"WaitForJump:p"},
        {"Wait:0.06"},			-- bo wykrywa podloge troche wczesniej i zeby pfx od walk nie odpalal sie za wysoko
        {"L:p:LaunchFullAnimEvent('walk')"},         
        {"L:p:LaunchFullAnimEvent('walk')"}, 
        {"AI:p,true"}, 
    }
    AddAction(action,obj,"p._died",area,point,anim,pow,uppow)
end

--============================================================================
function CAction:Action_Run(obj,area,point)
    if not obj or obj._died then return end
    local action = {
        {"AI:p,false"},
        {"RunTo:p,a[1].Points[a[2]]"},
        {"WaitForWalk:p"},
        {"RotateTo:p,a[1].Points[a[2]].A"},
        {"WaitForRotate:p"},
        {"AI:p,true"}, 
    }
    AddAction(action,obj,"p._died",area,point)
end

--============================================================================
function CAction:Action_EnablePO(entity,state)
    if not entity then return end
    if type(entity) == "table" then 
        if state and entity._died then return end -- zabitych juz nie aktywuje
        entity = entity._Entity        
    end    
    ENTITY.PO_Enable(entity,state)
end
--============================================================================
function CAction:Action_EnableDraw(entity,state,alsoChildren)
    if not entity then return end
    if type(entity) == "table" then 
        entity = entity._Entity        
    end    
    ENTITY.EnableDraw(entity,state,alsoChildren)
end
--============================================================================
function CAction:Action_FinishJump(entity)
    if not entity then return end
    if type(entity) == "table" then 
        entity = entity._Entity
    end
    ENTITY.PO_SetFlying(entity,false)
    --local actor = EntityToObject[entity]
    --if actor and actor.NeverMove then
    --    ENTITY.PO_SetPinned(entity, true)
    --end
end
--============================================================================
--[[function CAction:Action_ThrowTo(entity, entityDest)
    if type(entity) == "table" then 
        entity = entity._Entity
    end

    if type(entityDest) == "table" then 
        entityDest = entity._Entity
    end

    local m = EntityToObject[entity]    
    local force = m.ThrowForce
    local rnd = 0

	local x1,y1,z1 = ENTITY.GetPosition(entity)
	local x2,y2,z2 = ENTITY.GetPosition(entityDest)
	 local dx = x2 - x1 + FRand(-rnd, rnd)
	 local dy = y2 - y1 + FRand(-rnd, rnd)
	 local dz = z2 - z1 + FRand(-rnd, rnd)

	local v = Vector:New(dx, dy, dz)
	v:Normalize()

    ENTITY.PO_Enable(entity,true)

   	ENTITY.EnableCollisions(entity, true, 0.2, 0.01, 0.2, 0.01)
    ENTITY.PO_EnableGravity(entity, false)
	
    m._velx = v.X*force
    m._vely = v.Y*force
    m._velz = v.Z*force
    ENTITY.SetVelocity(entity,m._velx,m._vely,m._velz)
    --ENTITY.PO_Rotate(entity,0,0,FRand(10,12)) 
end--]]
--============================================================================
function CAction:Action_EnableCollision(entity,vx,vy,vz)
    if not entity then return end
    if type(entity) == "table" then 
        entity = entity._Entity
    end
    ENTITY.EnableCollisions(entity,vx,vy,vz)
end
--============================================================================
function CAction:Action_AI(obj,state)
    if not obj then return end
        
    if not state and obj._hasAI ~= nil then obj._hasAI = obj.AIenabled end    
    
    if state == true then ENTITY.PO_SetFlying(obj._Entity,false) end
    if not obj._died then
        --obj:SetIdle()
        obj.AIenabled = state
    end

    if state and obj._hasAI ~= nil then
        obj.AIenabled = obj._hasAI
        obj._hasAI = nil
    end
end
--============================================================================
function CAction:Action_WalkTo(obj,x,y,z)
    if not obj then return end
    if type(x) == "table" then 
        obj:WalkTo(x.X,x.Y,x.Z)
    else
        obj:WalkTo(x,y,z)
    end
end
--============================================================================
function CAction:Action_RunTo(obj,x,y,z)
    if not obj then return end
    if type(x) == "table" then 
        obj:WalkTo(x.X,x.Y,x.Z,true)
    else
        obj:WalkTo(x,y,z,true)
    end
end
--============================================================================
function CAction:Action_Damage(obj,damage)
    if not obj then return end
    if obj and obj.OnDamage then
        if not damage then damage = obj.Health + 10 end
        obj:OnDamage(damage)
    end
end
--============================================================================
function CAction:Action_RotateTo(obj,a)
    if not obj then return end
    a = a/(math.pi/180)
    obj:RotateTo(a)
end
--============================================================================
function CAction:Action_RotateToVector(obj,x,y,z)
    if not obj then return end
	if obj then
		obj:RotateToVector(x,y,z)
	end
end
--============================================================================
function CAction:Action_Wait(sec)
    table.insert(self._Processes,TWait:New(sec))
    self._Waiting = true
end
--============================================================================
function CAction:Action_WaitForWalk(obj)
    if not obj then return end
    local p = TWait:New(nil,"not proc.Obj._isWalking")
    p.Obj = obj
    table.insert(self._Processes,p)
    self._Waiting = true
end
--============================================================================
function CAction:Action_WaitForCorpses(cnt)
    
    local p = TWait:New(nil,"Game.BodyCountTotal >= proc.Corpses") 
    self._BodyCountTotal = self._BodyCountTotal + cnt
    p.Corpses = self._BodyCountTotal        
    table.insert(self._Processes,p)
    self._Waiting = true
end
--============================================================================
function CAction:Action_WaitForRotate(obj)
    if not obj then return end
    local p = TWait:New(nil,"not proc.Obj:IsRotating()")
    p.Obj = obj
    table.insert(self._Processes,p)
    self._Waiting = true
end
--============================================================================
function CAction:Action_WaitForAnim(obj)
    if not obj then return end
    local p = TWait:New(nil,"not proc.Obj._isAnimating")
    p.Obj = obj
    table.insert(self._Processes,p)
    self._Waiting = true
end
--============================================================================
function CAction:Action_WaitForJump(obj)
    if not obj then return end
    local p = TWait:New(nil,"proc.Obj._died or ENTITY.PO_IsOnFloor(proc.Obj._Entity)")
    p.Obj = obj
    table.insert(self._Processes,p)
    self._Waiting = true
end
--============================================================================
function CAction:Action_Close(obj,cnt, showCnt, endLev)
    if not obj then return end
    if obj.Close then obj:Close(cnt, showCnt, endLev) end
end
--============================================================================
function CAction:Action_CloseAdd(obj,cnt, showCnt, endLev)
    if not obj then return end
    if obj._IsOpened then 
        obj:Close(cnt, showCnt, endLev)
    else
        if obj._OpenAfterDeadBodies then obj._OpenAfterDeadBodies = obj._OpenAfterDeadBodies + cnt end        
    end
end
--============================================================================
function CAction:Action_CheckAdd(obj,cnt)
    if not obj then return end
    if obj.MonstersToKill then 
        obj.MonstersToKill = obj.MonstersToKill + cnt
    end
end

--============================================================================
function CAction:Action_Open(obj)
    if not obj then return end
    if obj.Open then obj:Open() end
end
--============================================================================
function CAction:Action_Show(obj)
	if not obj then return end
	if obj.OnShow then obj:OnShow() end
end
--============================================================================
function CAction:Action_Hide(obj)
	if not obj then return end
	if obj.OnHide then obj:OnHide() end
end
--============================================================================
function CAction:Action_OpenAllSlabsOnly()
    for i,o in GObjects.Elements do
        if o.BaseObj == "Slab.CItem" then
            o:Open()
        end
    end
end
--============================================================================
function CAction:Action_OpenAllSlabs()
    for i,o in GObjects.Elements do
        if o.BaseObj == "Slab.CItem" then
            o:Open()
        end
    end
    
    local tmp = GObjects:GetAllObjectsByClass("CBox")
    for i,o in tmp do
        if o._IsAmbushForPlayer then
            GObjects:ToKill(o)
        end
    end    

	if Lev then Lev.AmbushesDisabled = true end
end
--============================================================================
function CAction:Action_Fire(obj,tm)
    if not obj then return end
    local p = PBurningItem:New(obj,tm) 
    p:Init()
    GObjects:Add(TempObjName(),p)
end
--============================================================================
function CAction:Action_PlaySpawnSound(obj, d1, d2)
    if not obj then return end
	if obj.s_SubClass and obj.s_SubClass.Sounds and obj.s_SubClass.Sounds.OnSpawn then
		obj:PlaySound(obj.s_SubClass.Sounds.OnSpawn, d1, d2)
	end
end
--============================================================================
function CAction:Action_KillAllActors()
    for i,v in Actors do
        if v.Health > 0 and v._AIBrain then
            v:OnDamage(9999,v,AttackTypes.Demon)
        end
    end
end
--============================================================================
function CAction:Action_ExplosionFX(x,y,z,fxscale)
    local nx,ny,nz = 0,1,0

    --local b,d,dx,dy,dz,dnx,dny,dnz,he,e = WORLD.LineTrace(x,y,z,x+vx*1,y+vy*1,z+vz*1)        
    --if b and e and not EntityToObject[e] then ENTITY.SpawnDecal(e,'rockethole',dx,dy,dz,dnx,dny,dnz) end
    
    if not fxscale then fxscale = 1 end
    -- sound
    SOUND.Play3D("weapons/machinegun/rocket_hit",x,y,z,30,200)
    
    local r = Quaternion:New_FromNormal(nx,ny,nz)
    AddObject("FX_rexplode.CActor",fxscale,Vector:New(x,y,z),r,true) 
    
    -- physical parts
    local px,py,pz = x+nx/2,y+ny/2,z+nz/2
    local n = math.random(4,6) -- how many (min,max)
    for i = 1, n do
        local scale = FRand(0.5,0.8)
        local ke = AddItem("KamykWybuchRakieta.CItem",scale,Vector:New(px+FRand(-0.2,0.2),py+FRand(-0.2,0.2),pz+FRand(-0.2,0.2)))
        vx,vy,vz  = r:TransformVector(FRand(-30,30),FRand(22,34),FRand(-30,30))
        ENTITY.SetVelocity(ke,vx,vy,vz)
        ENTITY.SetTimeToDie(ke,FRand(1,2)) -- lifetime (min,max)
    end
    
    -- light    
    --local lx,ly,lz = x+nx*2,y+ny*2,z+nz*2
    --AddAction({{"Light:a[1],a[2],a[3],200,200,100, 8, 10 , 1, 0.02,0.1,0.02"}},nil,nil,lx,ly+1.5,lz)
    --if Game._EarthQuakeProc then
    --    local g = Templates["Grenade.CItem"]
    --    Game._EarthQuakeProc:Add(x,y,z, 5, g.ExplosionCamDistance, g.ExplosionCamMove, g.ExplosionCamRotate, false)
    --end
end
--============================================================================
function CAction:Action_DemonOn()
    Game:EnableDemon(true, 9999)
end

function CAction:Action_DemonOff()
    Game:EnableDemon(false)
end

--============================================================================
function AddAction(array,parent,kill_if,...)
    if table.getn(array) == 0 then return nil end
    local a = GObjects:Add(TempObjName(),CAction:New(array,parent))
    a.arg = arg
    a._KillIFStr = kill_if
    a:Apply()
    return a
end
