--============================================================================
PMove = {
    _Entity = nil,
    Objactor = nil,
}
Inherit(PMove,CProcess)
--============================================================================
function PMove:New(actor, speed)
    local p = Clone(PMove)
    p.BaseObj = "PMove"
    p.Objactor = actor
    p.speed = speed
    p.move = false
    return p
end
--============================================================================
function PMove:SetDir(v)
	v:Normalize()
	self.dirx = v.X
	self.diry = v.Y
	self.dirz = v.Z
end

function PMove:GetDir()
	return self.dirx,self.diry,self.dirz
end

function PMove:Start()
	--Game:Print("START")
	self.move = true
end

function PMove:Stop()
	self.move = false
end


function PMove:Tick(delta)
    if self._ToKill then return end
    if self.move then
		if self.Objactor._frozen or not self.Objactor.AIenabled then
			ENTITY.PO_Move(self.Objactor._Entity, 0,0,0)
		else
			local mvx = self.dirx * self.speed
			local mvy = 0
			local mvz = self.dirz * self.speed	
			ENTITY.PO_Move(self.Objactor._Entity, mvx, mvy, mvz)
		end
	end
end
--============================================================================
