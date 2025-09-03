function Deto:OnInitTemplate()
    self:SetAIBrain()
    --self._AIBrain._lastSliceTime = 0
    self._bombs = {}
end

--[[
function Deto:CustomOnDamage(he,x,y,z,obj, damage, type)
    if type == AttackTypes.Demon then
        return false
    end

    if he then
        local t,e,j = PHYSICS.GetHavokBodyInfo(he)
        local jName = MDL.GetJointName(e,j)
        if jName == "shield" then
            if type == AttackTypes.Shotgun or type == AttackTypes.MiniGun or type == AttackTypes.Painkiller then
				self:PlaySound({"$/actor/maso/maso_hit_impact1","$/actor/maso/maso_hit_impact2"},22,52)
            end
			return true
		end
	else
		if type == AttackTypes.Physics then
			return false
		end
		if x and type == AttackTypes.Rocket then
			local x1,y1,z1 = self:GetJointPos("root")
			local dist = Dist3D(x,y,z,x1,y1,z1)
			Game:Print("odleglosc wybuchu od jointa : "..dist.." "..damage)
			if dist < 1.5 then
				damage = damage * (15/10 - dist)*10/15
				return false, damage
			end
		end
	end
	return false
end


function Deto:OnThrow(x,y,z)
	--local q = Quaternion:New()
    --Game:Print("yaw "..(yaw*180/math.pi).." pitch "..(pitch*180/math.pi))
    local v = Vector:New(x,y,z)
    v:Normalize()
	local q = Quaternion:New_FromNormalX(v.X, v.Y, v.Z)
	--Game:Print(v.X.." "..v.Y.." "..v.Z)
	--Game:Print(q.X.." "..q.Y.." "..q.Z)
    q:ToEntity(self._objTakenToThrow._Entity)
end
--]]




o._CustomAiStates = {}
o._CustomAiStates.detoAttack = {
	name = "detoAttack",
}


function o._CustomAiStates.detoAttack:OnInit(brain)
	local actor = brain._Objactor
	actor:Stop()
	self._lastTimeLost = brain._currentTime
end

function o._CustomAiStates.detoAttack:OnUpdate(brain)
	local actor = brain._Objactor
	if actor.Animation == "detonacja" then
		return
	end
	local aiParams = actor.AiParams
	
	if not actor._isWalking then
		local r = actor.AiParams.runRadius
		--
		local x,y,z = PX+FRand(-r,r), PY, PZ+FRand(-r,r)
		-- zamiast random, zeby nie obraca sie o 180 jedn
		--:WalkForward(dist, run, ang
		
		-- czy sciana po drodze
		local b,d = WORLD.LineTraceFixedGeom(actor._groundx, actor._groundy + 1.5, actor._groundz, x,y,z)
		if not d then
			d = actor.AiParams.runRadius * 2
			Game:Print("ok")
		else
			Game:Print("sciana "..d)
		end
		
		if debugMarek then
			DEBUG1,DEBUG2,DEBUG3,DEBUG4,DEBUG5,DEBUG6 = actor._groundx, actor._groundy + 1.5, actor._groundz, x, y, z
		end
		
		if d > 4 then
			-- czy bedzie widzial z tej pozycji gracza
			-- czy tam WP bedzie w poblizu

			--
			--[[local a = 14
			if a > 14 then
				a = 14
			end
			local r = a - 5
			r = r * 0.1
			actor._randomizedParams.RotateSpeed = actor.RotateSpeed * (1 - r)--]]
			actor._randomizedParams.RotateSpeed = actor.RotateSpeed * FRand(0.8, 1.2)


			--actor.disbleRotWhenStartWalk = true				-- ### dlaczego nie dziala samo _walkWithAngle???
			if math.random(100) < 40 then
				actor:WalkTo(x,y,z,true, d - 2,nil,nil,true)
			else
				actor:WalkTo(x,y,z,true, d - 2)
			end
		
			Game:Print("wwwwalk")
			
			--if math.abs(actor._distToAngle) > 90 * 3.14/180 then
			--	actor:Stop()
			--end
		end
	else
		local b,d,e_other = actor:Trace(1.8)
		if e_other then
			local obj = EntityToObject[e_other]
			if obj then
				Game:Print(" kolizja z "..obj._Name)
				local v = Vector:New(math.sin(actor.angle), 0, math.cos(actor.angle))
				v:Normalize()
				self.ImpulseSTR = 12

				if obj._Class == "CPlayer" then
					ENTITY.PO_SetPlayerFlying(e_other, 0.33)
					ENTITY.SetVelocity(e_other, v.X*self.ImpulseSTR,self.ImpulseSTR*0.66,v.Z*self.ImpulseSTR)
				else
					local a = self.ImpulseSTR * 0.3
					ENTITY.SetVelocity(e_other, v.X*a,v.Y*a + a*0.5,v.Z*a)
				end
				obj:OnDamage(10,actor)
			end
		end
		local a = brain._distToNearestEnemy		-- blizej wroga wieksza szansa zgubienia
		if a > 20 then
			a = 20
		end
		a = 20 - a
		a = a * 0.001

        local count = table.getn(actor._bombs)		
		local wantDetonate = (FRand(0,1) < aiParams.detonateChance) or (count > aiParams.maxExplosives)
		if wantDetonate then
			a = 0
			local dist = 99
			for i,v in actor._bombs do
				local d = Dist2D(v.Pos.X, v.Pos.Z, actor._groundx, actor._groundz)
				if d < dist then
					dist = d
				end
			end
			--Game:Print("closest bomb = "..dist)
			if dist < 2 then		-- jak blisko bomby mniejsza szansa
				a = -0.02
			end
		end
		
		--if wantDetonate then
		--	Game:Print(" W "..aiParams.dropExplChance * 0.8 + a * 0.5)
		--else
		--	Game:Print("NW "..aiParams.dropExplChance * 0.8 + a * 0.5)
		--end
		
		if FRand(0,1) < (aiParams.dropExplChance * 0.8 + a * 0.5) and self._lastTimeLost + 0.4 < brain._currentTime then
			self._lastTimeLost = brain._currentTime
			
			if count > 1 and wantDetonate then
				actor:Stop()
				actor:SetAnim("detonacja",false)
			else
				if count < aiParams.maxExplosives then
					local x,y,z = actor:GetJointPos("root")
					x = x + FRand(-0.2,0.2)
					z = z + FRand(-0.2,0.2)
					local ke,obj = AddItem("Deto_bomb.CItem",nil,Vector:New(x,y,z),true)
					table.insert(actor._bombs, obj)
				end
			end			
		end
	end
end

function o._CustomAiStates.detoAttack:OnRelease(brain)
	local actor = brain._Objactor
end

function o._CustomAiStates.detoAttack:Evaluate(brain)
	if brain.r_closestEnemy then
		return 0.4
	end
	return 0
end


function o:Detonate()
	for i,v in self._bombs do
		if not v._ToKill then
			v:Detonate()
		end
	end
	self._bombs = {}
end
