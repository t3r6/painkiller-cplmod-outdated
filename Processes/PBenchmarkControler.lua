--============================================================================
PBenchmarkControler = {
    _Class = "CProcess",
	_Frames = 0,
    _StartTime = 0,
	_Time = 0,
    _LastTime = 0,
	_MinDelta = 10000,
	_MaxDelta = 0,
}
Inherit(PBenchmarkControler,PCameraControler)
--============================================================================
function PBenchmarkControler:New(area,speed,lookat)
    local p = Clone(PBenchmarkControler)
    p.BaseObj = "PBenchmarkControler"
    p:Init(area,speed,lookat)
	p._Weapon = Cfg.ViewWeaponModel
    p._StartTime = os.clock()
    p._Time = os.clock()
	PMENU.Activate(false)
	Hud.Enabled = false	
	MOUSE.Lock()	
	if Player then
		Player._died = true
		ENTITY.PO_Enable(Player._Entity,false) 	
	end    
    return p
end
--============================================================================
function PBenchmarkControler:Tick(delta)    
	PCameraControler.Tick(self,delta)	
	R3D.SetCameraFOV(90)
    PX,PY,PZ =  self.Pos.X,self.Pos.Y,self.Pos.Z
    --Game:Print(PX..","..PY..","..PZ)
    
    self._LastTime = self._Time
    self._Time = os.clock() 
    delta = self._Time-self._LastTime
    if delta==0 then return end
	self._Frames = self._Frames + 1
	if self._MinDelta>delta then self._MinDelta=delta end
	if self._MaxDelta<delta then self._MaxDelta=delta end  
end
--============================================================================
function PBenchmarkControler:Delete() 
	local msg = GObjects:Add(TempObjName(),CloneTemplate("EndBench.CProcess"))
	local FPS = self._Frames/(self._Time-self._StartTime)
	local minFPS = 1/self._MaxDelta
	local maxFPS = 1/self._MinDelta
	msg.FPS = string.format("FPS: %.02f / %.02f / %.02f\nScore: %.02f",minFPS,FPS,maxFPS,FPS)
	Game._demoproc = nil
	R3D.SetCameraFOV(Cfg.FOV)	
end
--============================================================================
