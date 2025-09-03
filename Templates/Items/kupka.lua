o.OnInitTemplate = CItem.StdOnInitTemplate

function kupka:OnCreateEntity()
	self:PO_Create(BodyTypes.FromMesh)
	self._burning = true
end
