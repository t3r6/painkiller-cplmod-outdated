function o:OnInitTemplate()
    self:SetAIBrain()
end

function o:OnCreateEntity()
    self:BindTrailSword('trail_loki','dlo_prawa_root','d_p_srodek')
    self:BindTrailSword('trail_loki','dlo_lewa_root','d_l_srodek')
end
