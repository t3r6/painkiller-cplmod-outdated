--============================================================================
-- Wait Task
--============================================================================
TWait =
{
    ___IsWaitingProc = true,
    Condition = nil,
    Timeout = nil,
}
Inherit(TWait,CProcess)
--============================================================================
function TWait:New(timeout,conditionStr)
    local p = Clone(TWait)
    p.BaseObj = "TWait"
    p.Timeout = timeout
    p.ConditionStr = conditionStr
    if p.ConditionStr then
        p.Condition = loadstring("if "..p.ConditionStr.." then return true else return false end") 
    end
    return p
end
--============================================================================
function TWait:Update()
    proc = self
    if self.Condition and self.Condition(self) then 
        self._ToKill = true
    end
    proc = nil
end
--============================================================================
function TWait:Tick(delta)
    if self.Timeout then 
        self.Timeout = self.Timeout -  delta
        if self.Timeout <=0 then self._ToKill = true end
    end
end
--============================================================================
function TWait:RestoreFromSave()    
    if self.ConditionStr then
        self.Condition = loadstring("if "..self.ConditionStr.." then return true else return false end") 
    end
end
--============================================================================