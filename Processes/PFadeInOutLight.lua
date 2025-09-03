--============================================================================
PFadeInOutLight = {
    FadeInTime  = 0,
    FadeMidTime = 0,
    FadeOutTime = 0,
    CurTime = 0,
    Intensity = 0,
    _Entity = nil,
 }
Inherit(PFadeInOutLight,CProcess)
--============================================================================
function PFadeInOutLight:New(entity,intensity,fin,fmid,fout)
    local dl = Clone(PFadeInOutLight)
    dl.BaseObj = "PFadeInOutLight"
    dl._Entity = entity
    dl.Intensity = intensity
    dl.FadeInTime = fin
    dl.FadeMidTime = fin + fmid
    dl.FadeOutTime = fin + fmid + fout
    return dl
end
--============================================================================
function PFadeInOutLight:Tick(delta)
    if self._ToKill then return end
    
    self.CurTime = self.CurTime +  delta
    
    local intensity = 0
    if self.CurTime <= self.FadeInTime then
        intensity = self.CurTime/self.FadeInTime * self.Intensity
    elseif self.CurTime <= self.FadeMidTime then
        intensity = self.Intensity
    elseif self.CurTime <= self.FadeOutTime then
        local fout = self.FadeOutTime - self.FadeMidTime
        intensity = (1 - (self.CurTime - self.FadeMidTime) / fout) * self.Intensity
    end
    
    --Game:Print(intensity)
    
    LIGHT.SetIntensity(self._Entity,intensity)    
    if self.CurTime > self.FadeOutTime then 
        ENTITY.Release(self._Entity)
        self._ToKill = true 
    end
end
--============================================================================
