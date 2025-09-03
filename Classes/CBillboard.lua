--============================================================================
-- Billboard class
--============================================================================
CBillboard =
{
    Pos = Vector:New(0,0,0),
    Color = Color:New(255,255,255,255),
    Texture = "banka",
    BlendMode = 1,
    Alpha = 0.5,
    Size	= 5,
    Corona = 
    {
        Enabled = false,
        FadeInTime	= 0.5,
        FadeOutTime	= 0.5,
        TraceMargin = 1,
        MinDistance	= 5,
        MaxDistance	= 20,
        MinSize	= 0.8,
        OffDistance	= 70,
    },
    _Class = "CBillboard",
    s_Editor = {
        Texture   = { "BrowseEdit", {"*.*", "data\\textures\\particles\\", true} },
        BlendMode = { "ComboBox", {"None|0","Alpha|1","Add|2","Filter|3","Translucent|4"}},
		Size      = { "SpinEdit"  , {"%.1f", 0, 99, 0.1} },
		Alpha     = { "SpinEdit" , {"%.2f", 0, 1, 0.01} },
    }    
}
Inherit(CBillboard,CObject)
--============================================================================
function CBillboard:OnClone(old)
    if old == CBillboard then 
        self.Pos = OppositeToCamera() 
    else 
        self.Pos.X = old.Pos.X - 1
        self.Pos.Z = old.Pos.Z - 1
    end
    self._Entity = nil
end
--============================================================================
function CBillboard:Delete()
    WORLD.RemoveEntity(self._Entity)
    ENTITY.Release(self._Entity)
    self._Entity = nil
end
--============================================================================
function CBillboard:Apply(old)
    if not old or old.Corona.Texture ~= self.Corona.Texture then 
        ENTITY.Release(self._Entity)
        self._Entity = ENTITY.Create(ETypes.Billboard,"Script",self._Name)        
    end    
    
    -- tryb konwersji ze swiatel
    if self.Active then self.Active = nil end
    if self.Visible then self.Visible = nil end
    self.IsDynamic = nil
    self.Type = nil
    self.Intensity = nil
    self.Range = nil
    self.StartFalloff = nil
    self.Direction = nil
    self.InheritFrom = nil
    if self.Corona.Texture then
        self.Texture = self.Corona.Texture
        self.Corona.Texture = nil
        if self.Corona.Billboard ~= nil then
            self.Corona.Enabled = not self.Corona.Billboard
            self.Corona.Billboard = nil
        else
            self.Corona.Enabled = true
        end
    end  
    if self.Corona.BlendMode then
        self.BlendMode = self.Corona.BlendMode
        self.Corona.BlendMode = nil
    end  
    if self.Corona.AlphaMax then
        self.Alpha = self.Corona.AlphaMax
        self.Corona.AlphaMax = nil
    end  
    if self.Corona.MaxRadius then
        self.Size = self.Corona.MaxRadius
        self.Corona.MaxRadius = nil
    end  
    if self.Corona.MinRadius then
        self.Corona.MinSize = self.Corona.MinRadius
        self.Corona.MinRadius = nil
    end  
    -- tryb konwersji ze swiatel
    
    local c = self.Corona
    local ctex = "Particles/"..self.Texture
    BILLBOARD.SetupCorona(self._Entity,self.Alpha,c.FadeInTime,c.FadeOutTime,c.MinSize,c.MinDistance,
         self.Size,c.MaxDistance,c.OffDistance,c.TraceMargin,ctex,self.Color:Compose(),self.BlendMode,not self.Corona.Enabled)    
    ENTITY.SetPosition(self._Entity,self.Pos.X,self.Pos.Y,self.Pos.Z)
    WORLD.AddEntity(self._Entity)
end
--============================================================================
--function CBillboard:Synchronize()
    -- synchronization with  C++ object
--    ENTITY.SetPosition(self._Entity,self.Pos.X,self.Pos.Y,self.Pos.Z)
--end
--============================================================================
function CBillboard:EditRender(delta)
    if not Editor.EditBillboardsAndDecals then return end
    local sx,sy,sz = R3D.VectorToScreen(self.Pos:Get())
    if sz<=1 then 
        if self.Corona.Texture == "" then
            if (self.Type==1) then
                R3D.DrawDirLight(self.Color:Compose(),self.Pos.X, self.Pos.Y, self.Pos.Z,self.Direction.X,self.Direction.Y,self.Direction.Z) 
            else            
                R3D.DrawSphere(self.Range,self.Color:Compose(),self.Pos.X,self.Pos.Y,self.Pos.Z)
                R3D.DrawSphere(self.StartFalloff,self.Color:Compose(),self.Pos.X,self.Pos.Y,self.Pos.Z)
            end
            R3D.RenderBox(self.Pos.X-0.15,self.Pos.Y-0.15,self.Pos.Z-0.15,self.Pos.X+0.15,self.Pos.Y+0.15,self.Pos.Z+0.15,self.Color:Compose())
        else
            R3D.RenderBox(self.Pos.X-0.15,self.Pos.Y-0.15,self.Pos.Z-0.15,self.Pos.X+0.15,self.Pos.Y+0.15,self.Pos.Z+0.15,Color:New(255,50,50):Compose())
        end
        --Hud:Quad(Editor.matLight,sx,sy,1,true) 
    end
end
--============================================================================
function CBillboard:EditTick(delta)
    if not Editor.EditBillboardsAndDecals then return end

    -- edit
    if Editor.SelObj == self then        

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