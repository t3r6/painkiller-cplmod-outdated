--============================================================================
PMusicFade = {
    Channel = 0,
    VolumeIn = 0,
    VolumeOut = 0,
    FadeTime  = 0,
    Volume  = 0,
    ScriptOnFinish  = 0,
    _ft = 0,
    _Class = "CProcess",
}
Inherit(PMusicFade,CProcess)
--============================================================================
function PMusicFade:New(ch,vol_in,vol_out,tm,scriptOnFinish)
    local p = Clone(PMusicFade)
    p.BaseObj = "PMusicFade"
    p.Channel = ch
    p.FadeTime = tm
    p.VolumeIn = vol_in
    if not vol_in then
        Game:Print(" ERROR: PMusicFade:New vol_in = nil")
        p.VolumeIn = 0
    end
    p.VolumeOut = vol_out
    if not vol_out then
        Game:Print(" ERROR: PMusicFade:New vol_out = nil")
        p.VolumeOut = 100
    end

    p.ScriptOnFinish = scriptOnFinish
    return p
end
--============================================================================
function PMusicFade:Tick(delta)
    if self._ToKill then return end
    
    self._ft = self._ft +  delta       
    if self._ft > self.FadeTime then
        self._ft = self.FadeTime
        GObjects:ToKill(self)
        if self.ScriptOnFinish then dostring(self.ScriptOnFinish) end
    end
    
    local a = self._ft / self.FadeTime
    local vol = self.VolumeIn + (self.VolumeOut - self.VolumeIn) * a
    
    SOUND.StreamSetVolume(self.Channel,vol)
end
--============================================================================
