--============================================================================
PCameraControler = {
    Factor = 0,
    Speed = 0.01,
    Pos = Vector:New(0,0,0),
    r_Area = nil,
    r_LookAt = nil,
    CubicSpline = nil,
    _Class = "CProcess",
}
Inherit(PCameraControler,CProcess)
--============================================================================
function PCameraControler:New(area,speed,lookat)
    local p = Clone(PCameraControler)
    p.BaseObj = "PCameraControler"
    p:Init(area,speed,lookat)
    return p
end
--============================================================================
function PCameraControler:Init(area,speed,lookat)
    self.Speed = speed
    self.r_Area = area
    self.r_LookAt = lookat
    Game.CameraFromPlayer = false
    local a = self.r_Area.Points
    CAM.SetPos(a[1].X,a[1].Y,a[1].Z)        
    self.CubicSpline = CalcNaturalCubicSpline(a)
    self.Pos:Set(a[1])
end
--============================================================================
function PCameraControler:Tick(delta)    

    self.Factor = self.Factor + self.Speed * delta
    if self.Factor > 1 then    
        GObjects:ToKill(self)
        return
    end

    local p = NCubicPoint(self.CubicSpline,self.Factor)
    CAM.SetPos(p.X,p.Y,p.Z)
    
    self.Pos:Set(p)
    
    if self.r_LookAt then
        local x,y,z = ENTITY.GetPosition(self.r_LookAt._Entity)
        CAM.LookAt(x,y,z)
    else
        local p1 = NCubicDerivative(self.CubicSpline,self.Factor)
        CAM.LookAt(p1.X+p.X,p1.Y+p.Y,p1.Z+p.Z)
    end
end
--============================================================================
function CameraMove(area,speed,lookat) 
    local p = PCameraControler:New(area,speed,lookat)
    GObjects:Add(TempObjName(),p)
    p:Init()
end
--============================================================================
