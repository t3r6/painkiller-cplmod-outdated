function StoneG:OnCreateEntity()
    self:DropOut()    
end
--============================================================================
function StoneG:OnTake(player)	
    self.Client_OnTake(player.ClientID,player._Entity,self._Entity,"StoneG")
end
--============================================================================
