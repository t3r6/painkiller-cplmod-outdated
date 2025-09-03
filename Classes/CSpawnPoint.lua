--============================================================================
-- SpawnPoint class
--============================================================================
CSpawnPoint =
{
    GroupCount = 5,
    GroupDelay = 3,
    GroupSize = 1,
    EachDelay = 0.3,
    StartDelay = 0,
    SpawnTemplate = "DevilMonk.CActor",
    SpawnFX = "MonsterSpawn.CAction",
    WalkArea = "",
    NotCountable = false,
    OnFinishAction = {}, -- compatibility
    Actions = {
        OnLastMonsterDie    = {},
        OnMonsterSpawn    = {},
    },   
    Pos = Vector:New(0,0,0),    
    SpawnAngle = {
        Value = 0,
        Enabled = false,
    },
    _SpawnCount = 0,
    _IvCnt = 0,
    _Class = "CSpawnPoint", 
    _SpawnedMonsters = {},
    _SpawnedMonstersCount = 0,
    s_Editor = {
        ["SpawnTemplate"]  = { "ComboBox", "CSpawnPoint.FillSpawnTemplateBox" },
        ["SpawnFX"]  = { "ComboBox", "CSpawnPoint.FillSpawnFXBox" },
        ["WalkArea"]  = { "ComboBox", "CSpawnPoint.FillWalkAreaBox" },
        ["Actions.OnLastMonsterDie.[new]"] = { "TextEdit" },
        ["Actions.OnMonsterSpawn.[new]"] = { "TextEdit" },
        ["SpawnAngle.Value"] = { "SpinEdit" , {"%.2f", 0, 6.28, 0.05} },
    },
}
Inherit(CSpawnPoint,CObject)
--============================================================================
function CSpawnPoint:OnClone(old)
    if old == CSpawnPoint then 
        self.Pos = OppositeToCamera() 
    else 
        self.Pos.X = old.Pos.X - 0.5
        self.Pos.Z = old.Pos.Z - 0.5
    end
end
--============================================================================
function CSpawnPoint:Apply(old)            
    if self.OnFinishAction and table.getn(self.OnFinishAction) > 0 then 
        self.Actions.OnLastMonsterDie = self.OnFinishAction  
    end
    self.OnFinishAction  = nil

    self._IvCnt = self.StartDelay
    if self.EachDelay < 0.5 then self.EachDelay  = 0.5 end

    -- compatibility
    local i = string.find(self.SpawnTemplate,"^",1,true)
    if i then self.SpawnTemplate = string.sub(self.SpawnTemplate,1,i-1).."_"..string.sub(self.SpawnTemplate,i+1) end
end
--============================================================================
function CSpawnPoint:Tick(delta)
    if not self._Launched then return end
    
    if self._SpawnedMonstersCount > 0 then
        -- patrze, ktore monstery sa juz zabite
        for i,v in self._SpawnedMonsters do
            if v._ToKill or v._died then 
                table.remove(self._SpawnedMonsters,i) 
                self._SpawnedMonstersCount = self._SpawnedMonstersCount -1
            end
        end        

        if self.GroupDelay < 0 then
            if self._SpawnedMonstersCount > 0 then
                return
            else
                self._IvCnt = math.abs(self.GroupDelay)
            end
        end
                
        if self._SpawnedMonstersCount <= 0 and self._SpawnCount >= self.GroupCount then 
            self:LaunchAction(self.Actions.OnLastMonsterDie)
            GObjects:ToKill(self)
            return
        end        
    end
    
    if self._SpawnCount >= self.GroupCount then return end    

    if Game.BulletTime and self.GroupCount == 1 and self.GroupSize == 1 then
        delta = delta / INP.GetTimeMultiplier() 
    end    
    
    self._IvCnt = self._IvCnt - delta    
    if self._IvCnt < 0 then    
        
        self._SpawnedMonstersCount = self._SpawnedMonstersCount + self.GroupSize
        local t = 0
        for i=1,self.GroupSize do 
            local action = {}
            table.insert(action,{"Wait:"..tostring(t)})
            table.insert(action,{"L:p:Spawn()","monster"})			
            AddAction(action,self)
            t = t + self.EachDelay
        end
    
        self._IvCnt = self.GroupDelay
        self._SpawnCount = self._SpawnCount + 1
                
    end        
end
--============================================================================
function CSpawnPoint:Spawn()       
    if not self._FirstSpawn then 
        self._FirstSpawn = true
        if self.OnFirstSpawn then self:OnFirstSpawn() end
    end
    local obj = GObjects:Add(TempObjName(),CloneTemplate(self.SpawnTemplate))
    obj.Pos:Set(self.Pos)    
    if self.SpawnAngle.Enabled then
        obj.angle = self.SpawnAngle.Value
    else
        obj.angle = math.atan2(Player.Pos.X - obj.Pos.X,Player.Pos.Z - obj.Pos.Z) -- front to player
    end    
    obj.angleDest = obj.angle
    --obj.AIType = nil
    self:OnSpawn(obj)
    obj:Apply()
    if obj.Synchronize then obj:Synchronize() end
    
    local sfx = self.SpawnFX
    if sfx ~= "" and Game.BulletTime then
        sfx = "MonsterSpawn.CAction"
    end    
    if sfx ~= "" then
        
        ENTITY.EnableDraw(obj._Entity,false)
        local action = CloneTemplate(self.SpawnFX)            
        -- doklejam self.Actions.OnMonsterSpawn
        for i,v in self.Actions.OnMonsterSpawn do
            table.insert(action.Sequence,{v})
        end                        
        local fx = GObjects:Add(TempObjName(),action)        
        fx._ObjParent = obj
        fx:Apply()        
    else
        obj:LaunchAction(self.Actions.OnMonsterSpawn)        
    end
    
    if self._EnableDemonic then
        --Game:Print("enable demonic for "..obj._Name)
        ENTITY.EnableDemonic(obj._Entity,true,true)
        self._EnableDemonic = nil
    end

    table.insert(self._SpawnedMonsters,obj)    
    
    return obj
end
--============================================================================
function CSpawnPoint:EditTick(delta)    
    
    if not Editor.EditAreas then return end

    if Editor.SelObj ~= self and MOUSE.LB() == 1 then        
        -- picking point 
        local sx,sy,sz = R3D.VectorToScreen(self.Pos:Get())
        if Dist2D(MX,MY,sx,sy) <  15  then
            Editor.ObjEdited = true                
            Editor:SelectObject(self)
        end    
    end
    
    if Editor.SelObj == self then        
        if INP.Key(Keys.X) == 2 then
            self.SpawnAngle.Value = self.SpawnAngle.Value + 0.01
        end
        if INP.Key(Keys.Z) == 2 then
            self.SpawnAngle.Value = self.SpawnAngle.Value - 0.01
        end
        self.SpawnAngle.Value = math.mod(math.pi*2 + math.mod(self.SpawnAngle.Value, math.pi*2), math.pi*2) 
    end
end
--============================================================================
function CSpawnPoint:EditRender(delta)
    
    if not Editor.EditAreas then return end
    
    local ztest = true
    if INP.Key(Keys.LeftCtrl) == 2 then ztest = false end   

    if Editor.SelObj == self  then
        R3D.DrawSphere(0.8,R3D.RGBA(0,255,255,0),self.Pos.X,self.Pos.Y,self.Pos.Z,ztest)
    else
        R3D.DrawSphere(0.8,R3D.RGBA(200,200,200,0),self.Pos.X,self.Pos.Y,self.Pos.Z,ztest)
    end
    
    if self.SpawnAngle.Enabled then
        local p = self.Pos
        local px = p.X + math.sin(self.SpawnAngle.Value)
        local pz = p.Z + math.cos(self.SpawnAngle.Value)
        R3D.RenderLine(p.X,p.Y,p.Z,px,p.Y,pz,R3D.RGB(200,0,0))
    end
    
    R3D.RenderBox(self.Pos.X-0.15,self.Pos.Y-0.15,self.Pos.Z-0.15,self.Pos.X+0.15,self.Pos.Y+0.15,self.Pos.Z+0.15,R3D.RGBA(255,255,0,0),ztest)
end
--============================================================================
-- to override
--============================================================================
function CSpawnPoint:OnCheckStartupCondition()
end
--============================================================================
function CSpawnPoint:OnSpawn(obj)
    --obj.Scale = FRand(0.8,1.2)
    if self.WalkArea ~= "" then
        obj.AiParams.walkArea = self.WalkArea
        --obj.AiParams.WalkAreaWhenAttack = true
    end
end
--============================================================================
function CSpawnPoint:FillSpawnTemplateBox()
    tmp_tab = {}
    for i,v in Templates do 
        if string.find(i,".CActor",1,true) then
            table.insert(tmp_tab,i)
        end
    end
    table.sort(tmp_tab,function (a,b) return a<b end)
end
--============================================================================
function CSpawnPoint:FillSpawnFXBox()
    tmp_tab = {}
    for i,v in Templates do 
        if string.find(i,"MonsterSpawn",1,true) and string.find(i,".CAction",1,true) then
            table.insert(tmp_tab,i)
        end
    end
    table.sort(tmp_tab,function (a,b) return a<b end)
end
--============================================================================
function CSpawnPoint:FillWalkAreaBox()
    tmp_tab = {""}
    local boxes = GObjects:GetAllObjectsByClass("CArea")
    for i,v in boxes do
        table.insert(tmp_tab,v._Name)
    end
    table.sort(tmp_tab,function (a,b) return a<b end)
end
--============================================================================
