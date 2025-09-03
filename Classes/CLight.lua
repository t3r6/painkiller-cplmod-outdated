--============================================================================
-- Light class
--============================================================================
CLight =
{
    Type = 0,    
    IsDynamic = false,    
    LitParent = false,
    Pos = Vector:New(0,0,0),
    Color = Color:New(255,255,255,0),
	Intensity = 1,
    Direction = Vector:New(0,-1,0),
    StartFalloff = 2,
    Range = 3,
    ConeAngle = 90,
    _Rot = Quaternion:New(),
	Projector = "",

    _Class = "CLight",

    s_Editor = 
    {
        Type               = { "ComboBox"  , {"None|0", "Directional|1", "Point|2","Spot|3"} },
        StartFalloff       = { "SpinEdit"  , {"%.1f", 0, 1000, 0.1} },
        Range              = { "SpinEdit"  , {"%.1f", 0, 1000, 0.1} },
		Intensity	      = { "SpinEdit"  , {"%.1f", 0, 10, 0.1} },
        ConeAngle        = { "SpinEdit"  , {"%.1f", 0, 180, 1} },
        Projector		=  { "BrowseEdit", {"*.*", "data\\textures\\", true} },
    }    
}
Inherit(CLight,CObject)
--============================================================================
function CLight:OnClone(old)
    if old == CLight then 
        self.Pos = OppositeToCamera() 
    else 
        self.Pos.X = old.Pos.X - 1
        self.Pos.Z = old.Pos.Z - 1
    end
    self._Entity = 0
end
--============================================================================
function CLight:Delete()
    WORLD.RemoveEntity(self._Entity)
    ENTITY.Release(self._Entity)
    EntityToObject[self._Entity] = nil
    self._Entity = nil
end
--============================================================================
function CLight:LoadData()
    ENTITY.Release(self._Entity)
    self._Entity = ENTITY.Create(ETypes.Light,"Script",self._Name)
    WORLD.AddEntity(self._Entity)
    EntityToObject[self._Entity] = self
end
--============================================================================
function CLight:Apply(old)
    if not old or (old.Type ~= self.Type) then 
        self:LoadData() 
    end    
    
    --- XXX compatybility mode
    if self.Radius then 
        self.Range = self.Radius 
        self.Radius = nil
    end
    
    if old and self.Range ~= old.Range then
        self.StartFalloff = self.StartFalloff*(self.Range/old.Range)
    end
    
    if self.StartFalloff > self.Range then
        self.StartFalloff = self.Range
    end
    
    LIGHT.Setup(self._Entity,self.Type,self.Color:Compose(),
                self.Direction.X,self.Direction.Y,self.Direction.Z,self.Intensity)    
    LIGHT.SetFalloff(self._Entity,self.StartFalloff,self.Range,self.ConeAngle)
    LIGHT.SetDynamicFlag(self._Entity,self.IsDynamic)       
    LIGHT.SetLitParentFlag(self._Entity,self.LitParent)
	LIGHT.SetProjector(self._Entity,self.Projector)
    ENTITY.SetPosition(self._Entity,self.Pos.X,self.Pos.Y,self.Pos.Z)

    self._Rot:FromNormal001(self.Direction.X,self.Direction.Y,self.Direction.Z)
end
--============================================================================
--function CLight:Synchronize()
    -- synchronization with  C++ object
--    ENTITY.SetPosition(self._Entity,self.Pos.X,self.Pos.Y,self.Pos.Z)
--end
--============================================================================
function CLight:EditRender(delta)
    if not Editor.EditLights then return end
    local sx,sy,sz = R3D.VectorToScreen(self.Pos:Get())
    if sz<=1 then 
        if (self.Type==1) then
            R3D.DrawDirLight(self.Color:Compose(),self.Pos.X, self.Pos.Y, self.Pos.Z,self.Direction.X,self.Direction.Y,self.Direction.Z) 
        elseif (self.Type==2) then
            R3D.DrawSphere(self.Range,self.Color:Compose(),self.Pos.X,self.Pos.Y,self.Pos.Z)
            R3D.DrawSphere(self.StartFalloff,self.Color:Compose(),self.Pos.X,self.Pos.Y,self.Pos.Z)
        elseif (self.Type==3) then
            R3D.DrawSpotLight(self.Color:Compose(),self.Pos.X, self.Pos.Y, self.Pos.Z,self.Direction.X,self.Direction.Y,self.Direction.Z,self.Range,self.StartFalloff,self.ConeAngle)
        end
        R3D.RenderBox(self.Pos.X-0.15,self.Pos.Y-0.15,self.Pos.Z-0.15,self.Pos.X+0.15,self.Pos.Y+0.15,self.Pos.Z+0.15,self.Color:Compose())
    end
end
--============================================================================
function CLight:EditTick(delta)
    if not Editor.EditLights then return end    

    -- edit
    if Editor.SelObj == self then        
        if INP.Key(Keys.NumPlus) == 2 then        
            self.Range = self.Range + 4 * delta
        end
        if INP.Key(Keys.NumMinus) == 2 then        
            self.Range = self.Range - 4 * delta
        end
        self.Direction.X,self.Direction.Y,self.Direction.Z = self._Rot:TransformVector(0,0,1)
        self:Apply(self)
    else
        -- picking point 
        if MOUSE.LB() == 1 then        
            local sx,sy,sz = R3D.VectorToScreen(self.Pos:Get())
            if Dist2D(MX,MY,sx,sy) <  15  then
                Editor.ObjEdited = true                
                if Editor.SelObj ~= self then Editor:SelectObject(self) end
            end
        end    
    end

end
--============================================================================
function CLight:Rescale(factor)
    self.Pos:MulByFloat(factor)
    self.StartFalloff = self.StartFalloff * factor
    self.Range = self.Range * factor
    self:Apply(self)
end
--============================================================================
function CreateLight(x,y,z,r,g,b,range1,range2,intensity)
    --Log("*CreateLight 1\n")
    --Log(GetCallStackInfo(2).."\n")
    --Log("*CreateLight 2\n")
    local e = ENTITY.Create(ETypes.Light)
    --Log("*CreateLight 3\n")
    ENTITY.SetPosition(e,x,y,z)
    --Log("*CreateLight 4\n")
    WORLD.AddEntity(e)
    --Log("*CreateLight 5\n")
    LIGHT.Setup(e,2,R3D.RGBA(r,g,b,255),0,0,0,intensity,"")
    LIGHT.SetFalloff(e,range1,range2)
    LIGHT.SetDynamicFlag(e,true)
    --Log("*CreateLight 6\n")
    return e
end
--============================================================================
function AddLight(template,scale,pos)
    local obj = CloneTemplate(template)
    --obj.Scale = obj.Scale * scale
    obj.Pos:Set(pos)
    obj:Apply()    
    LIGHT.SetDynamicFlag(obj._Entity,true)
    return obj._Entity
end
--============================================================================