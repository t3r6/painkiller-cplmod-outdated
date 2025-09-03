--============================================================================
-- Environment class
--============================================================================
CEnvironment =
{
    Rot = Quaternion:New(),
    Ambient = 
    {
        Overwrite = false,
        Color = Color:New(30,30,30,0),
    },
    DirLight = 
    {
        Overwrite = false,
        Dir = Vector:New(-0.7,-0.7,-0.7),
        Color = Color:New(100,100,100,0),
        Intensity = 1.0,
		FadeTime = 1.0,
    },  
    Fog = 
    {
        Overwrite	= false,
        Start		= 0,
        End		    = 90,
        Density		= 0.002,
        Color = Color:New(255,255,255,0),
    },    
    DependentLights = {},    
    Size = 
    {
        Width  = 2,
        Height = 4,
        Depth  = 1,
    },        
    Pos = Vector:New(0,0,0),
    _Class = "CEnvironment",
    s_Editor = {
        ["Size.Width"]  = { "SpinEdit", {"%.1f", 0.1, 999, 0.1} },
        ["Size.Height"] = { "SpinEdit", {"%.1f", 0.1, 999, 0.1} },
        ["Size.Depth"]  = { "SpinEdit", {"%.1f", 0.1, 999, 0.1} },
        ["DependentLights.[new]"] = { "ComboBox", "CEnvironment.FillDependentLights" },
    }    
}
Inherit(CEnvironment,CObject)
--============================================================================
function CEnvironment:OnClone(old)
    if old == CEnvironment then 
        self.Pos = OppositeToCamera() 
    else
        self.Pos.X = old.Pos.X - 0.5
        self.Pos.Z = old.Pos.Z - 0.5
    end
    self._Entity = nil
end
--============================================================================
function CEnvironment:Delete()
    WORLD.RemoveEntity(self._Entity)
    ENTITY.Release(self._Entity)
    self._Entity = nil
end
--============================================================================
function CEnvironment:Apply(old)
     if not old then 
        ENTITY.Release(self._Entity)
        self._Entity = ENTITY.Create(ETypes.Environment,"Script",self._Name)
        WORLD.AddEntity(self._Entity)
    end        
    ENVIRONMENT.SetAmbient(self._Entity,self.Ambient.Overwrite,self.Ambient.Color:Compose())
    local f = self.Fog
    ENVIRONMENT.SetFog(self._Entity,f.Overwrite,f.Start,f.End,f.Density,f.Color:Compose())
    local d = self.DirLight
    ENVIRONMENT.SetDirLight(self._Entity,d.Overwrite,d.Dir.X,d.Dir.Y,d.Dir.Z,d.Color:Compose(),d.Intensity,d.FadeTime)

    local w,h,d = self.Size.Width/2,self.Size.Height/2,self.Size.Depth/2    
    ENTITY.SetLocalBBox(self._Entity,-w,-h,-d,w,h,d)   

    ENTITY.SetPosition(self._Entity,self.Pos.X,self.Pos.Y,self.Pos.Z)
    self.Rot:ToEntity(self._Entity)
    WORLD.UpdateAllEntities()
    self:SetDependentLights()
end
--============================================================================
function CEnvironment:RestoreFromSave()
    self:Apply()
end
--============================================================================
function CEnvironment:AfterLoad()
    self:SetDependentLights()
end
--============================================================================
function CEnvironment:SetDependentLights()
    ENVIRONMENT.RemoveLights(self._Entity)
    for i,v in self.DependentLights do
        local obj = FindObj(v)
        if obj then ENVIRONMENT.AddLight(self._Entity,obj._Entity) end
    end    
end
--============================================================================
function CEnvironment:EditRender(delta)
    if not Editor.EditLights then return end

    if self.DirLight.Overwrite then
        local d = self.DirLight
        R3D.DrawDirLight(d.Color:Compose(),self.Pos.X, self.Pos.Y, self.Pos.Z,d.Dir.X,d.Dir.Y,d.Dir.Z) 
    end	
	
    local w = self.Size.Width/2
    local h = self.Size.Height/2
    local d = self.Size.Depth/2

    local scaleCol = 0.5
	
    local r,g,b = self.Ambient.Color.R,self.Ambient.Color.G,self.Ambient.Color.B
    if self.DirLight.Overwrite then
        r,g,b = r+self.DirLight.Color.R, g+self.DirLight.Color.G, b+self.DirLight.Color.B    
    end
	r =255
	g =242 
	b =242
	
    if r>255 then r = 255 end
    if g>255 then g = 255 end
    if b>255 then b = 255 end
	
      --  r,g,b = r*scaleCol, g * scaleCol, b* scaleCol  	
		
    R3D.RenderTranslucentBox(-w,-h,-d,w,h,d,r,g,b,self.Pos.X,self.Pos.Y,self.Pos.Z,self.Rot.W,self.Rot.X,self.Rot.Y,self.Rot.Z)



    local p = {}    
    p[1] = Vector:New(-w,-h,-d)
    p[2] = Vector:New(-w,-h,d)
    p[3] = Vector:New(w,-h,d)
    p[4] = Vector:New(w,-h,-d)
    p[5] = Vector:New(-w,h,-d)
    p[6] = Vector:New(-w,h,d)
    p[7] = Vector:New(w,h,d)
    p[8] = Vector:New(w,h,-d)

    for i,v in p  do
        v.X, v.Y, v.Z =  self.Rot:TransformVector(v.X, v.Y, v.Z)
        v.X = v.X + self.Pos.X
        v.Y = v.Y + self.Pos.Y
        v.Z = v.Z + self.Pos.Z
    end
    local col = R3D.RGB(255,50,70)
    R3D.RenderLine(p[1].X,p[1].Y,p[1].Z,p[2].X,p[2].Y,p[2].Z,col)
    R3D.RenderLine(p[2].X,p[2].Y,p[2].Z,p[3].X,p[3].Y,p[3].Z,col)
    R3D.RenderLine(p[3].X,p[3].Y,p[3].Z,p[4].X,p[4].Y,p[4].Z,col)
    R3D.RenderLine(p[4].X,p[4].Y,p[4].Z,p[1].X,p[1].Y,p[1].Z,col)

    R3D.RenderLine(p[5].X,p[5].Y,p[5].Z,p[6].X,p[6].Y,p[6].Z,col)
    R3D.RenderLine(p[6].X,p[6].Y,p[6].Z,p[7].X,p[7].Y,p[7].Z,col)
    R3D.RenderLine(p[7].X,p[7].Y,p[7].Z,p[8].X,p[8].Y,p[8].Z,col)
    R3D.RenderLine(p[8].X,p[8].Y,p[8].Z,p[5].X,p[5].Y,p[5].Z,col)

    R3D.RenderLine(p[1].X,p[1].Y,p[1].Z,p[5].X,p[5].Y,p[5].Z,col)
    R3D.RenderLine(p[2].X,p[2].Y,p[2].Z,p[6].X,p[6].Y,p[6].Z,col)
    R3D.RenderLine(p[3].X,p[3].Y,p[3].Z,p[7].X,p[7].Y,p[7].Z,col)
    R3D.RenderLine(p[4].X,p[4].Y,p[4].Z,p[8].X,p[8].Y,p[8].Z,col)
   
    col = R3D.RGB(50,130,130)
    for i=1,4 do
        local v = p[i]
        R3D.RenderBox(v.X-0.07,v.Y-0.07,v.Z-0.07,v.X+0.07,v.Y+0.07,v.Z+0.07,col)
    end

    col = R3D.RGB(50,200,200)
    for i=5,8 do
        local v = p[i]
        R3D.RenderBox(v.X-0.07,v.Y-0.07,v.Z-0.07,v.X+0.07,v.Y+0.07,v.Z+0.07,col)
    end

    col = R3D.RGB(200,50,50)
    R3D.RenderBox(self.Pos.X-0.15,self.Pos.Y-0.15,self.Pos.Z-0.15,self.Pos.X+0.15,self.Pos.Y+0.15,self.Pos.Z+0.15,col)   
    
    for i,v in self.DependentLights do
        local obj = FindObj(v)
        if obj then 
            R3D.RenderLine(self.Pos.X,self.Pos.Y,self.Pos.Z,obj.Pos.X,obj.Pos.Y,obj.Pos.Z,col)
        end
    end
end
--============================================================================
function MinMax(array)    
    local m = array[1]
    for i,v in array do
        if math.abs(v) > math.abs(m) then m = v end
    end
    return m
end
--============================================================================
function CEnvironment:Rescale(factor)
    self.Pos:MulByFloat(factor)
    self.Size.Width  = self.Size.Width  * factor
    self.Size.Height = self.Size.Height * factor
    self.Size.Depth  = self.Size.Depth  * factor
    self:Apply(self)
end
--============================================================================
function CEnvironment:EditTick(delta)    
    if not Editor.EditLights then return end    
    -- edit
    if Editor.SelObj == self then        
        if (INP.Key(Keys.LeftCtrl) == 1 and INP.Key(Keys.MouseButtonLeft)==2) or 
           (INP.Key(Keys.LeftCtrl) == 2 and INP.Key(Keys.MouseButtonLeft)==1) then
            self._LastPos = Clone(self.Pos)
            Editor.LMX,Editor.LMY = MX,MY
        end
        if INP.Key(Keys.MouseButtonLeft) == 3 or INP.Key(Keys.LeftCtrl) == 3 then
            if self._LastPos then self.Pos = self._LastPos end
            self._LastPos = nil
        end
        if INP.Key(Keys.LeftCtrl) == 2 and INP.Key(Keys.MouseButtonLeft)==2 then
            if self._LastPos then
                
                local ox = (self.Pos.X - self._LastPos.X) * 2
                local oy = (self.Pos.Y - self._LastPos.Y) * 2
                local oz = (self.Pos.Z - self._LastPos.Z) * 2
                
                if  MX ~= OMX or MY ~= OMY then      
                    
                    local px,py,pz = self.Rot:InverseTransformVector(ox,oy,oz)

                    if Editor.Axis == "Free" then -- homogeneous scale
                        local m = MinMax({MX-OMX,OMY-MY})/15
                        local prop = Vector:New(self.Size.Width,self.Size.Height,self.Size.Depth)
                        prop:Normalize()
                        px = m * prop.X
                        py = m * prop.Y
                        pz = m * prop.Z
                    end

                    self.Size.Width  = self.Size.Width  + px
                    self.Size.Height = self.Size.Height + py
                    self.Size.Depth  = self.Size.Depth  + pz
                    
                    if self.Size.Width  < 0.1 then self.Size.Width  = 0.1 end
                    if self.Size.Height < 0.1 then self.Size.Height = 0.1 end
                    if self.Size.Depth  < 0.1 then self.Size.Depth  = 0.1 end
                    WORLD.UpdateAllEntities()
                end
        
                local w,h,d = self.Size.Width/2,self.Size.Height/2,self.Size.Depth/2    
                ENTITY.SetLocalBBox(self._Entity,-w,-h,-d,w,h,d)
                
                self.Pos = Clone(self._LastPos)
                ENTITY.SetPosition(self._Entity,self.Pos.X,self.Pos.Y,self.Pos.Z)
                MX,MY = Editor.LMX,Editor.LMY
                MOUSE.SetPos(MX,MY) 
            end
        end    
        
        if (self._OldPos and (self._OldPos.X ~= self.Pos.X or self._OldPos.Y ~= self.Pos.Y or self._OldPos.Z ~= self.Pos.Z))
           or
           (self._OldRot and (self._OldRot.W ~= self.Rot.W or self._OldRot.X ~= self.Rot.X or self._OldRot.Y ~= self.Rot.Y or self._OldRot.Z ~= self.Rot.Z))
        then
            WORLD.UpdateAllEntities()
        end
        self._OldPos = Clone(self.Pos)
        self._OldRot = Clone(self.Rot)
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
function CEnvironment:IsInside(x,y,z)    
    local w = self.Size.Width  / 2
    local h = self.Size.Height / 2
    local d = self.Size.Depth  / 2

    if x >= self.Pos.X - w and x <= self.Pos.X + w and 
       y >= self.Pos.Y - h and y <= self.Pos.Y + h and 
       z >= self.Pos.Z - d and z <= self.Pos.Z + d then
           return true
    end
    return false
end
--============================================================================
function CEnvironment:FillDependentLights()
    tmp_tab = {"-remove-"}
    local lights = GObjects:GetAllObjectsByClass("CLight")
    for i,v in lights do
        table.insert(tmp_tab,v._Name)
    end
end
--============================================================================
--CEnvironment:MultiplyAllEnvironment("*",1,1,1)
--"*" leci po wszystkich lub szuka substringow
function CEnvironment:MultiplyAllEnvironment(searchString,ambientCol,dirCol,dirintensity)
    local tmp = GObjects:GetAllObjectsByClass("CEnvironment")	
    for i, o in tmp do
		if (searchString == "*" or string.find(o._Name , searchString) ) then
			Game:Print("found = "..o._Name)			
			o.Ambient.Color.R = o.Ambient.Color.R * ambientCol
			o.Ambient.Color.G = o.Ambient.Color.G * ambientCol
			o.Ambient.Color.B = o.Ambient.Color.B * ambientCol
			o.DirLight.Color.R = o.DirLight.Color.R * dirCol
			o.DirLight.Color.G = o.DirLight.Color.G * dirCol
			o.DirLight.Color.B = o.DirLight.Color.B * dirCol
			o.DirLight.Intensity = o.DirLight.Intensity * dirintensity	
		end			
		
    end
end
--============================================================================
