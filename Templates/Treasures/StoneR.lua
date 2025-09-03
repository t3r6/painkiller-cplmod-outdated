function StoneR:OnCreateEntity()
    self:DropOut()    
end
--============================================================================
function StoneR:OnTake(player)	
    self.Client_OnTake(player.ClientID,player._Entity,self._Entity,"StoneR")
end
--============================================================================
