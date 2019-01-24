--暂时不用的方法
--开关灯
function TurnOnPlayerLight()
	GameRules:SetTimeOfDay(0.3)
	for i=6,13 do
		for j=6,13 do
			if GameRules:GetGameModeEntity().lights[i][j] == nil then
				local x = CreateUnitByName("invisible_unit",CenterVector(j),true,nil,nil,i)
				x:AddAbility('street_light')
				x:FindAbilityByName('street_light'):SetLevel(1)
				GameRules:GetGameModeEntity().lights[i][j] = x
			else
				if GameRules:GetGameModeEntity().lights[i][j]:FindAbilityByName('street_light') ~= nil then
					GameRules:GetGameModeEntity().lights[i][j]:FindAbilityByName('street_light'):SetLevel(1)
				else
					GameRules:GetGameModeEntity().lights[i][j]:AddAbility('street_light')
					GameRules:GetGameModeEntity().lights[i][j]:FindAbilityByName('street_light'):SetLevel(1)
				end
			end
		end
	end
end
function TurnOffPlayerLight()
	GameRules:SetTimeOfDay(0.8)
	for i=6,13 do
		for j=6,13 do
			--给自己开灯
			if i == j then
				if GameRules:GetGameModeEntity().lights[i][j] == nil then
					local x = CreateUnitByName("invisible_unit",CenterVector(j),true,nil,nil,i)
					x:AddAbility('street_light')
					x:FindAbilityByName('street_light'):SetLevel(1)
					GameRules:GetGameModeEntity().lights[i][j] = x
				else
					if GameRules:GetGameModeEntity().lights[i][j]:FindAbilityByName('street_light') ~= nil then
						GameRules:GetGameModeEntity().lights[i][j]:FindAbilityByName('street_light'):SetLevel(1)
					else
						GameRules:GetGameModeEntity().lights[i][j]:AddAbility('street_light')
						GameRules:GetGameModeEntity().lights[i][j]:FindAbilityByName('street_light'):SetLevel(1)
					end
				end
			else
				if GameRules:GetGameModeEntity().lights[i][j] == nil then
					local x = CreateUnitByName("invisible_unit",CenterVector(j),true,nil,nil,i)
					x:AddAbility('street_light')
					x:FindAbilityByName('street_light'):SetLevel(0)
					x:RemoveModifierByName('modifier_street_light')
					GameRules:GetGameModeEntity().lights[i][j] = x
				else
					if GameRules:GetGameModeEntity().lights[i][j]:FindAbilityByName('street_light') ~= nil then
						GameRules:GetGameModeEntity().lights[i][j]:FindAbilityByName('street_light'):SetLevel(0)
						GameRules:GetGameModeEntity().lights[i][j]:RemoveModifierByName('modifier_street_light')
					else
						GameRules:GetGameModeEntity().lights[i][j]:AddAbility('street_light')
						GameRules:GetGameModeEntity().lights[i][j]:RemoveModifierByName('modifier_street_light')
						GameRules:GetGameModeEntity().lights[i][j]:FindAbilityByName('street_light'):SetLevel(0)
					end
				end
			end
		end
	end
end
function SyncHeroDeckHandItem(hero_new)
	for i=0,5 do
		if hero_new:GetItemInSlot(i) then
			if hero_new:GetItemInSlot(i):GetInitialCharges() == 30 then
				hero_new:GetItemInSlot(i):SetCurrentCharges(table.maxn(hero_new.deck))
			end
			if hero_new:GetItemInSlot(i):GetInitialCharges() == 0 then
				hero_new:GetItemInSlot(i):SetCurrentCharges(table.maxn(hero_new.hand))
			end
		end
	end
end
function CalScore()

	GameRules:SendCustomMessage('CalScore',0,0)

	--统计双方人数
	local rcount = 0
	local dcount = 0
	for x,vx in pairs(GameRules:GetGameModeEntity().hero) do
		if vx.team ~= nil and vx.team == 2 then
			rcount = rcount + 1
		end
		if vx.team ~= nil and vx.team == 3 then
			dcount = dcount + 1
		end
	end

	GameRules:SendCustomMessage('rcount:'..rcount..' dcount:'..dcount,0,0)

	--计算胜负
	--winteam:1=平局，2=天辉获胜，3=夜魇获胜
	local winteam = 1
	local rscore = GameRules:GetGameModeEntity().good_castle.hp
	local dscore = GameRules:GetGameModeEntity().bad_castle.hp
	if rscore > dscore then
		winteam = 2
	end
	if rscore < dscore then
		winteam = 3
	end

	GameRules:SendCustomMessage('winteam:'..winteam,0,0)
	
	--统计本局成绩并排序
	local final_score_table = {}
	for i,vi in pairs (GameRules:GetGameModeEntity().player_score) do
		local hh = ""
		for ii,vii in pairs(GameRules.HEROS) do
			local h = EntIndexToHScript(GameRules:GetGameModeEntity().steamid2heroindex[i])
			if h:GetUnitName() == vii then
				hh = ii
			end
		end
		local one_score = {
			steam_id = i,
			kill = vi.kill or 0,
			death = vi.death or 0,
			castle = vi.castle or 0,
			team = vi.team,
			score = (vi.kill + vi.castle - vi.death) or 0,
			hero = hh,
		}
		
		--获胜方分数有加成
		if vi.team == winteam then
			one_score['score'] = one_score['score'] + 100
		end
		GameRules:SendCustomMessage(''..i..'---'..one_score['score'],0,0)
		table.insert(final_score_table, one_score)
	end
	table.sort(final_score_table, function(a,b) return a.score>b.score end)

	--向服务器提交成绩
	if rcount == dcount and winteam ~= 1 then
		local users = nil
		local blackusers = "null"  --暂时写死null
		for i,vi in pairs (final_score_table) do
			if users == nil then
				users = vi.steam_id
			else
				users = users..","..vi.steam_id
			end
		end
		local url = "http://101.200.189.65:430/dac/ranking/@"..users.."@"..blackusers.."?hehe="..RandomInt(1,10000)
		local req = CreateHTTPRequestScriptVM("GET", url)

		req:SetHTTPRequestAbsoluteTimeoutMS(20000)
		req:Send(function (result)

			local t = json.decode(result["Body"])
			EmitGlobalSound("crowd.lv_03")

			CustomNetTables:SetTableValue( "dac_table", "final_score", {data = final_score_table,award = t.result,winteam = winteam, hehe = RandomInt(1,10000)})

			Timers:CreateTimer(10,function()
				--宣布获胜方
				if winteam == 2 then
					GameRules:SendCustomMessage('#text_goodguys_win',0,0)
					-- GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
				end
				if winteam == 3 then
					GameRules:SendCustomMessage('#text_badguys_win',0,0)
					
					-- GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
				end
			end)
			
		end)
	else 
		EmitGlobalSound("crowd.lv_03")
		--不需要提交成绩
		CustomNetTables:SetTableValue( "dac_table", "final_score", {data = final_score_table, hehe = RandomInt(1,10000)})
	end
end
--打出随从牌
function SummonMinion(keys)
	local caster = keys.caster
	local team_id = caster:GetTeam()
	local p = keys.target_points[1]
	local x = Vector2X(p,caster:GetTeam())
	local y = Vector2Y(p,caster:GetTeam())
	local position = XY2Vector(x,y,team_id) --格子中心点
	
	--召唤一个随从
	SummonOneMinion({
		caster = caster, --召唤者单位
		minion = keys.minion, --召唤的随从单位名称
		position = position, --召唤的地点
		direction = Vector(0,1,0), --默认朝上
	})
	--移除手牌
	CastSpell({caster = caster,spell = keys.minion})
end
--召唤1个随从
--参数caster minion position direction 
function SummonOneMinion(keys)
	local caster = keys.caster
	local team_id = caster:GetTeam()
	local minion = keys.minion
	local position = keys.position
	local direction = keys.direction

	if caster == nil or minion == nil then
		return
	end
	if direction == nil or (direction.x == 0 and direction.y == 0)then
		direction = RandomDirection()
	end

	if IsBlocked(Vector2X(position,team_id),Vector2Y(position,team_id),team_id) ~= false then
		--被占了就尝试挤到旁边格子
		position = FindClearPosition(position,team_id)
		if position == nil then
			return
		end
	end
	GameRules:GetGameModeEntity().unit[team_id][Vector2X(position,team_id)][Vector2Y(position,team_id)] = caster.team
	local u = CreateUnitByName(minion,position,true,nil,nil,caster.team)
	u.steam_id = caster.steam_id
	u.team = caster.team
	u.owner = caster
	u.direction = direction
	u.dream_direction = {x=direction.x,y=direction.y}
	u:AddAbility("root_self")
	u:FindAbilityByName("root_self"):SetLevel(1)
	u:AddAbility("blink_chess")
	u:FindAbilityByName("blink_chess"):SetLevel(1)
	
	u:SetHullRadius(1)
	u:SetForwardVector(Vector(direction.x,direction.y,0))
	u:SetOwner(caster:GetOwner())
	u:SetControllableByPlayer(caster:GetPlayerID(), true)

	-- --特殊战吼随从
	-- local myself = 0
	-- local theirs = 0
	-- if caster.team == 2 then
	-- 	myself = GameRules:GetGameModeEntity().good_castle.hp
	-- 	theirs = GameRules:GetGameModeEntity().bad_castle.hp
	-- else
	-- 	theirs = GameRules:GetGameModeEntity().good_castle.hp
	-- 	myself = GameRules:GetGameModeEntity().bad_castle.hp
	-- end
	-- if keys.minion == "m409" and myself < theirs then
	-- 	--vp北极熊是否高赔
	-- 	u:AddAbility("vp_add_attack_5")
	-- 	u:FindAbilityByName("vp_add_attack_5"):SetLevel(1)
	-- 	Timers:CreateTimer(2,function()
	-- 		EmitSoundOn("ursa_ursa_spawn_11",u)
	-- 	end)
		
	-- end
	-- if keys.minion == "m402" then
	-- 	--喷火龙
	-- 	BurnALine({caster = u})
	-- end
	-- if keys.minion == "m211" then
	-- 	PlayParticle("particles/econ/items/disruptor/disruptor_resistive_pinfold/disruptor_ecage_formation_wall_b.vpcf",PATTACH_OVERHEAD_FOLLOW,u,2)
	-- end
	-- if keys.minion == "m215" then
	-- 	PlayParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf",PATTACH_OVERHEAD_FOLLOW,u,2)
	-- end
	-- if keys.minion == "m312" then
	-- 	GrantInvisible({caster = u})
	-- end

 --    local t = MoveSpeed2Time(u:GetIdealSpeed())

 --    Timers:CreateTimer(0.5,function()
 --    	MinionAct(u)
 --    end)

	return u
end

function MinionAct(u)
	if u:IsNull() == true or u:IsAlive() == false or GameRules.is_game_ended == true then
		return
	end 
	--判断打
	local attack_result = AttackEnemy(u)
	t = MoveSpeed2Time(u:GetIdealSpeed())
	if attack_result == false and GameRules.is_stop ~= true then
		if u:FindAbilityByName("is_ward") == nil then
			--判断走
			local tt = MinionMove(u)
			if tt ~= nil then
				return tt
			else
				return t
			end
		else
			Timers:CreateTimer(t,function()
				if GameRules.is_game_ended == true then
					return
				end
		    	MinionAct(u)
		    end)
		end
	else
		return t
	end
end

function MinionMove(u)
	if u:FindAbilityByName("take_up_castle") ~= nil then
		return
	end
	if u.direction.x == 0 and u.direction.y == 0 then
		Timers:CreateTimer(1,function()
	    	MinionAct(u)
	    end)
	    return
	end
	if u:FindModifierByName('modifier_chaosalways') ~= nil then
		--有混乱buff就瞎走
		u.direction = RandomDirection()
	end

	--走一步
	local x = Pos2x(u:GetAbsOrigin()) + u.direction.x
	local y = Pos2y(u:GetAbsOrigin()) + u.direction.y
	if IsBlocked(x,y) ~= false and ((x > 17 and u.team == 2) or (x < 1 and u.team == 3)) then
		--进城堡了
		GameRules:GetGameModeEntity().unit[Pos2x(u:GetAbsOrigin())][Pos2y(u:GetAbsOrigin())] = 0
		BiteCastle(u)
		return
	end
	if IsBlocked(x,y) == "unit" then
		--被挡住了
		FindClearDirection(u)
		Timers:CreateTimer(0.1,function()
	    	MinionAct(u)
	    end)
	    return
	end
	if IsBlocked(x,y) == "map" then
		if PlantStop(u) == true then
			Timers:CreateTimer(0.1,function()
		    	MinionAct(u)
		    end)
			return
		end
		--反弹逻辑
		local block_x = IsBlocked(x,Pos2y(u:GetAbsOrigin())) 
		local block_y = IsBlocked(Pos2x(u:GetAbsOrigin()),y)
		-- if block_x == 'unit' or block_y == 'unit' then
		-- 	-- FindClearDirection(u)
		-- 	Timers:CreateTimer(0.1,function()
		--     	MinionAct(u)
		--     end)
		--     return
		-- end
		if block_x == 'unit' then
			block_x = false
		end
		if block_y == 'unit' then
			block_y = false
		end
		if block_x == block_y or (block_x=='unit' and block_y=='map') or (block_x=='map' and block_y=='unit') then
			u.direction.x = -u.direction.x
			u.direction.y = -u.direction.y
		else
			if block_x ~= false then
				u.direction.x = -u.direction.x
			else
				u.direction.y = -u.direction.y
			end
		end
		u.dream_direction = {x=u.direction.x,y=u.direction.y}
		u:MoveToPosition(Vector(u:GetAbsOrigin().x+u.direction.x, u:GetAbsOrigin().y+u.direction.y, u:GetAbsOrigin().z))

		Timers:CreateTimer(0.1,function()
	    	MinionAct(u)
	    end)
	    return
	end

	if Pos2x(u:GetAbsOrigin()) == x and Pos2y(u:GetAbsOrigin()) == y then
		if PlantStop(u) == true then
			Timers:CreateTimer(0.1,function()
		    	MinionAct(u)
		    end)
		end
		return
	end

	--正式决定走
	GameRules:GetGameModeEntity().unit[Pos2x(u:GetAbsOrigin())][Pos2y(u:GetAbsOrigin())] = 0
	GameRules:GetGameModeEntity().unit[x][y] = u.team
	local target_p = Arr2Grid(x,y)
	u:Stop()

	u:RemoveAbility("root_self")
	u:RemoveModifierByName("modifier_root_self")
	u:MoveToPosition(target_p)

	u:AddAbility("moving_self")
	u:FindAbilityByName("moving_self"):SetLevel(1)

	u.target = target_p

	Timers:CreateTimer(function()
		if u:IsNull() == true or u:IsAlive() == false or u:FindAbilityByName("take_up_castle") ~= nil then
			return
		end
		if u.target == nil then
			-- GameRules:SendCustomMessage('target = nil',0,0)
			return
		end
		if GameRules.is_game_ended == true then
			return
		end
		if (u:GetAbsOrigin() - u.target):Length2D() < 16 then
			--走到了
			u:RemoveAbility("moving_self")
			u:RemoveModifierByName("modifier_moving_self")
			u:AddAbility("root_self")
			u:FindAbilityByName("root_self"):SetLevel(1)
			u.target = nil

			if u.dream_direction ~= nil and (u.dream_direction.x ~= u.direction.x or u.dream_direction.y ~= u.direction.y) then
				u.direction.x = u.dream_direction.x
				u.direction.y = u.dream_direction.y

				u:MoveToPosition(Vector(u:GetAbsOrigin().x+u.direction.x, u:GetAbsOrigin().y+u.direction.y, u:GetAbsOrigin().z))
				Timers:CreateTimer(0.1,function()
					MinionAct(u)
					return
				end)
				return
			else
				MinionAct(u)
			end

			
		end   
		return 0.1
	end)
end

function BiteCastle(u)
	local castle = nil
	if u.team == 2 then 
		castle = GameRules:GetGameModeEntity().bad_castle
	else
		castle = GameRules:GetGameModeEntity().good_castle
	end
	u:AddAbility('take_up_castle')
	u:RemoveAbility("root_self")
	u:RemoveModifierByName("modifier_root_self")
	u:MoveToPosition(castle:GetAbsOrigin())
	u:AddAbility("moving_self")
	u:FindAbilityByName("moving_self"):SetLevel(1)
	Timers:CreateTimer(0.1,function()
		if u:IsAlive() == false then
			return
		end
		if GameRules.is_game_ended == true then
			return
		end
		if ((u:GetAbsOrigin()-castle:GetAbsOrigin()):Length2D() < 128) then
			castle.hp = castle.hp - (u:GetAttackDamage()*1)
			local uu = u
			if uu:IsHero() == false then
				uu = uu.owner
			end
			if uu ~= nil and uu.steam_id ~= nil then
				GameRules:GetGameModeEntity().player_score[uu.steam_id].castle = GameRules:GetGameModeEntity().player_score[uu.steam_id].castle + 1
				PlayerResource:IncrementAssists(uu:GetPlayerID(),1)
			end

			AMHC:CreateNumberEffect(castle,u:GetAttackDamage(),5,AMHC.MSG_DAMAGE,"red",3)

			if castle.hp <= 0 then
				castle.hp = 0

				--城堡碎裂
				if u.team == 2 then
					GameRules:GetGameModeEntity().bad_castle:SetOriginalModel("models/props_structures/dire_ancient_base001_destruction.vmdl")
					GameRules:GetGameModeEntity().bad_castle:SetModel("models/props_structures/dire_ancient_base001_destruction.vmdl")
					GameOver()
				else
					GameRules:GetGameModeEntity().good_castle:SetOriginalModel("models/props_structures/radiant_ancient001_rock_destruction.vmdl")
					GameRules:GetGameModeEntity().good_castle:SetModel("models/props_structures/radiant_ancient001_rock_destruction.vmdl")
					GameOver()
				end
			end

			EmitGlobalSound("DOTA_Item.Maim")
			PlayParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_sphere_final_explosion_smoke_ti5.vpcf",PATTACH_ABSORIGIN_FOLLOW,castle,2)

			CustomNetTables:SetTableValue( "dac_table", "team_score", { r = GameRules:GetGameModeEntity().good_castle.hp,d = GameRules:GetGameModeEntity().bad_castle.hp, hehe = RandomInt(1,10000) })


			Timers:CreateTimer(0.5,function()
				u:ForceKill(false)
			end)

			return
		end
		return 0.1
	end)
end

function PlantStop(plant)
	if plant:FindAbilityByName('plant_stop') ~= nil then
		plant.direction.x = 0
		plant.direction.y = 0
		plant.dream_direction = { x=0, y=0 }
		PlayParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_entangle_body.vpcf",PATTACH_ABSORIGIN_FOLLOW,plant,3)
		EmitSoundOn("LoneDruid_SpiritBear.Entangle",plant)
		return true
	end
	return false
end
function IsChaos(u)
	if u:FindModifierByName("modifier_chaosalways") ~= nil or u:FindModifierByName("modifier_minion_attack_chaos") ~= nil then
		return true
	else
		return false
	end
end
function AttackEnemy(u)
	if u:FindModifierByName('modifier_a106') ~= nil then --被致盲
		return false
	end
	if IsChaos(u) == true and RandomInt(1,100)>50 then --混乱
		return false
	end
	if u:GetAttackDamage() > 0 then
		local emeny_units = FindUnitsInRadius(u.team,u:GetAbsOrigin(),nil,u:GetAttackRange(),DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS,FIND_CLOSEST,false)
		if emeny_units == nil or table.maxn(emeny_units) <=0 then
			--范围内没有敌人
			return false
		end
		if u:FindModifierByName('modifier_melancholy') ~= nil or u:FindModifierByName('modifier_melan_aura_2') ~= nil then
			--傲娇
			if RandomInt(1,100) > 50 then
				PlayParticle("particles/econ/items/sniper/sniper_immortal_cape/sniper_immortal_cape_headshot_slow_ring.vpcf",PATTACH_OVERHEAD_FOLLOW,u,2)
				local t = MoveSpeed2Time(u:GetIdealSpeed())
				Timers:CreateTimer(t,function()
					MinionAct(u)
				end)
				return true
			end
		end

		local num = 1
		local e = emeny_units[1]
		-- local have_target = false
		-- while num <= table.maxn(emeny_units) do
		-- 	e = emeny_units[num]
		-- 	if e:FindAbilityByName('riki_permanent_invisibility') == nil then
		-- 		have_target = true
		-- 		break
		-- 	else
		-- 		num = num + 1
		-- 	end
		-- end
		-- if have_target == false then
		-- 	return false
		-- end
		-- if e:FindAbilityByName('riki_permanent_invisibility') ~= nil then
		-- 	GameRules:SendCustomMessage(e:GetUnitName()..'被攻击，现形！',0,0)
		-- 	e:RemoveAbility('riki_permanent_invisibility')
		-- end
		-- if u:FindAbilityByName('riki_permanent_invisibility') ~= nil then
		-- 	u:RemoveAbility('riki_permanent_invisibility')
		-- end
		local attack_abillity = "minion_attack"
		if u:FindAbilityByName("have_attack_froze") ~= nil then
			attack_abillity = "minion_attack_froze"
		end
		if u:FindAbilityByName("have_attack_poison") ~= nil then
			attack_abillity = "minion_attack_poison"
		end

		if u:FindAbilityByName("have_attack_break") ~= nil then
			attack_abillity = "minion_attack_break"
		end
		if u:FindAbilityByName("have_attack_cleave") ~= nil and u:GetUnitName() ~= "w303" and u:GetUnitName() ~= "w401" then
			attack_abillity = "minion_attack_cleave"
		end
		if u:FindAbilityByName("have_attack_cleave") ~= nil and (u:GetUnitName() == "w303" or u:GetUnitName() == "w401") then
			attack_abillity = "minion_attack_cleave2"
		end
		if u:FindAbilityByName("have_attack_chaos") ~= nil then
			attack_abillity = "minion_attack_chaos"
		end
		if u:FindAbilityByName("have_attack_split") ~= nil then
			attack_abillity = "minion_attack_split"
		end
		if u:FindAbilityByName(attack_abillity) == nil then
			u:AddAbility(attack_abillity)
			u:FindAbilityByName(attack_abillity):SetLevel(1)
		end
		local newOrder = {
	 		UnitIndex = u:entindex(), 
	 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
	 		TargetIndex = e:entindex(), 
	 		AbilityIndex = u:FindAbilityByName(attack_abillity):entindex(), 
	 		Position = nil, 
	 		Queue = 0 
	 	}
		ExecuteOrderFromTable(newOrder)

		local t = MoveSpeed2Time(u:GetIdealSpeed())
		Timers:CreateTimer(t,function()
			MinionAct(u)
		end)
		return true
	else
		return false
	end
end

function SummonWard(keys)
	local caster = keys.caster
	local position = caster:GetAbsOrigin() + caster:GetForwardVector():Normalized()*128

	local y = Pos2y(position)
	local x = Pos2x(position)
	position = Arr2Grid(x,y)

	local y0 = Pos2y(caster:GetAbsOrigin())
	local x0 = Pos2x(caster:GetAbsOrigin())

	SummonOneMinion({
		caster = caster, --召唤者单位
		minion = keys.ward, --召唤的随从单位名称
		position = position, --召唤的地点
		direction = {x=x-x0,y=y-y0}, --方向向量xy（从-1,-1到1,1）
	})

	--移除手牌
	CastSpell({caster = caster,spell = keys.ward})
end

function HeroDrawCard(keys)
	local caster = keys.caster
	
	if caster:IsHero() == false then
		caster = caster.owner
	end
	if caster:IsAlive() == false or caster.deck == nil or table.maxn(caster.deck) <= 0 then
		return
	end
	if table.maxn(caster.hand) >= 5 then
		return
	end
	local count = 0
	local r = RandomInt(1,table.maxn(caster.deck))
	if caster:FindAbilityByName('no_duplicate') then
		while caster:FindAbilityByName(caster.deck[r]) ~= nil and count < 1000 do
			if count >= 1000 then
				return
			else
				count = count + 1
				r = RandomInt(1,table.maxn(caster.deck))
			end
		end
	end
	if count < 1000 then
		GetCardInQueue({caster=caster,card=caster.deck[r]})
		table.remove(caster.deck,r)
		--deck -1
		SyncHeroDeckHandItem(caster)
	end
end

function HeroDropCard(keys)
	Timers:CreateTimer(0.5,function()
		local caster = keys.caster

		if caster.hand == nil or table.maxn(caster.hand) <= 0 then
			return
		end
		local r = RandomInt(1,table.maxn(caster.hand))
		DropCardInQueue({caster=caster,card=caster.hand[r]})
		table.remove(caster.hand,r)
	end)
end

function AttackDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local damage = caster:GetAttackDamage()
	local damageTable = {
    	victim = target,
    	attacker = caster,
    	damage_type = DAMAGE_TYPE_PHYSICAL,
    	damage = damage
    }
    ApplyDamage(damageTable)
end




function CastSpell(keys)
	local caster = keys.caster
	RemoveTableItem(caster.hand,keys.spell)
	table.insert(caster.deck,keys.spell)

	if PROLOGUE[keys.spell] ~= nil then
		local s =PROLOGUE[keys.spell][RandomInt(1,table.maxn(PROLOGUE[keys.spell]))]
		EmitSoundOn(s,caster)
	end

	CustomNetTables:SetTableValue( "dac_table", "say_card", { text = ''..keys.spell,unit = caster:entindex(), hehe = RandomInt(1,1000)})

	-- Say(PlayerResource:GetPlayer(caster:GetPlayerID()),keys.spell..'_name',false)

	if caster:GetUnitName() == "npc_dota_hero_zuus" then
		local ran = RandomInt(1,100)
		if ran <= 20 and string.sub(keys.spell,1,1) == "a" then
			local emeny_units = FindUnitsInRadius(caster.team,caster:GetAbsOrigin(),nil,99999,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,FIND_CLOSEST,false)
			if table.maxn(emeny_units) > 1 then
				local unlucky = emeny_units[2]
				local x = CreateUnitByName("invisible_unit",caster:GetAbsOrigin(),true,nil,nil,caster.team)
				x:AddAbility("a102inner")
				x:FindAbilityByName("a102inner"):SetLevel(1)
				Timers:CreateTimer(0.1,function()
					local newOrder = {
				 		UnitIndex = x:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				 		TargetIndex = unlucky:entindex(), 
				 		AbilityIndex = x:FindAbilityByName("a102inner"):entindex(), 
				 		Position = nil, 
				 		Queue = 0 
				 	}
					ExecuteOrderFromTable(newOrder)
					Timers:CreateTimer(5,function()
						x:ForceKill(false)
					end)
				end)
			end
		end
	end

	-- local level = caster:FindAbilityByName(keys.spell):GetLevel()
	-- if level == 1 then
	caster:RemoveAbility(keys.spell)
	-- else
	-- 	caster:FindAbilityByName(keys.spell):SetLevel(level-1)
	-- end
	caster:AddAbility("empty1")
	PutHandCardsInOrder(caster)
	caster:RemoveAbility("empty1")

	SyncHeroDeckHandItem(caster)
end

function Draw2cards(keys)
	HeroDrawCard({caster = keys.caster})
	Timers:CreateTimer(0.5,function()
		HeroDrawCard({caster = keys.caster})
	end)
end

function HeroBlink(keys)
	local p = keys.target_points[1]
	local caster = keys.caster
	local target_p = Arr2Grid(Pos2x(p),Pos2y(p))

	if caster.team == 2 and Pos2x(p) > 10 then
		target_p = Arr2Grid(10,Pos2y(p))
	end
	if caster.team == 3 and Pos2x(p) < 8 then
		target_p = Arr2Grid(8,Pos2y(p))
	end

	if IsBlocked(Pos2x(p),Pos2y(p)) ~= false then
		return
	end

	GameRules:GetGameModeEntity().unit[Pos2x(caster:GetAbsOrigin())][Pos2y(caster:GetAbsOrigin())] = 0
	GameRules:GetGameModeEntity().unit[Pos2x(p)][Pos2y(p)] = caster.team

	caster:SetAbsOrigin(target_p)

	CastSpell({caster = caster,spell = 'a302'})
end

function Ravage(keys)
	local caster = keys.caster

	local u = CreateUnitByName("invisible_unit", caster:GetAbsOrigin() ,false,nil,nil, caster.team) 

	u:AddAbility('tidehunter_ravage')
	u:FindAbilityByName('tidehunter_ravage'):SetLevel(1)
	Timers:CreateTimer(0.1,function()
		local newOrder = {
	 		UnitIndex = u:entindex(), 
	 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
	 		TargetIndex = nil, --Optional.  Only used when targeting units
	 		AbilityIndex = u:FindAbilityByName("tidehunter_ravage"):entindex(), --Optional.  Only used when casting abilities
	 		Position = nil, --Optional.  Only used when targeting the ground
	 		Queue = 0 --Optional.  Used for queueing up abilities
	 	}
		ExecuteOrderFromTable(newOrder)
		Timers:CreateTimer(5,function()
			u:ForceKill(false)
		end)
	end)
end

function Lottery(keys)
	local caster = keys.caster
	if caster.deck and table.maxn(caster.deck) then
		for i,v in pairs(caster.deck) do
			local r = RandomInt(1,table.maxn(GameRules.all_m_w_a_cards))
			caster.deck[i] = GameRules.all_m_w_a_cards[r]
		end
	end
end

function CardSteal(keys)
	local target = keys.target
	local caster = keys.caster
	-- Create the projectile
	local info = {
		Target = caster,
		Source = target,
		Ability = ability,
		EffectName = keys.particle,
		bDodgeable = false,
		bProvidesVision = false,
		iMoveSpeed = 1000,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	}
	ProjectileManager:CreateTrackingProjectile(info)
	if table.maxn(caster.hand) >= 10 then
		return
	end
	if target.hand == nil or table.maxn(target.hand) == 0 then
		return
	end
	local card = target.hand[RandomInt(1,table.maxn(target.hand))]
	table.insert(caster.hand,card)
	GetCardInQueue({caster=caster,card=card})
	if caster:FindAbilityByName(card) ~= nil then
		caster:FindAbilityByName(card):SetLevel(caster:FindAbilityByName(card):GetLevel()+1)
	else
		caster:AddAbility(card)
		caster:FindAbilityByName(card):SetLevel(1)
	end
end

function SwapProps(keys)
	local caster = keys.caster
	local target = keys.target
	local healthb = target:GetHealth()
	local attackb = (target:GetBaseDamageMax() + target:GetBaseDamageMin())/2
	local healthmax = target:GetMaxHealth()

	PlayParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf",PATTACH_OVERHEAD_FOLLOW,caster,2)

	PlayParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf",PATTACH_OVERHEAD_FOLLOW,target,2)

	local aaa = math.floor(healthb/10)
	local h = healthb - aaa
	local a = attackb + aaa
	if h < 1 then
		h = 1
	end

	target:SetHealth(h)
	target:SetBaseDamageMin(a)
	target:SetBaseDamageMax(a)
end


function RandomDirection()
	local random_d = {{x=-1,y=-1},{x=0,y=-1},{x=1,y=-1},{x=-1,y=0},{x=1,y=0},{x=-1,y=1},{x=0,y=1},{x=1,y=1}}
	return random_d[RandomInt(1,8)]
end

function FindClearDirection(u)
	local x = u.direction.x
	local y = u.direction.y

	local xx = x
	local yy = y

	if x==0 then
		if RandomInt(1,100)>50 then
			xx = -1
		else
			xx = 1
		end
	elseif y==0 then
		if RandomInt(1,100)>50 then
			yy = -1
		else
			yy = 1
		end
	else
		if RandomInt(1,100)>50 then
			xx = 0
		else
			yy = 0
		end
	end

	u.direction.x = xx
	u.direction.y = yy

	u:MoveToPosition(Vector(u:GetAbsOrigin().x+u.direction.x, u:GetAbsOrigin().y+u.direction.y, u:GetAbsOrigin().z))
end

function FindClearPosition(position,playerid)
	local random_d = {{x=-1,y=-1},{x=0,y=-1},{x=1,y=-1},{x=-1,y=0},{x=1,y=0},{x=-1,y=1},{x=0,y=1},{x=1,y=1}}
	local d = random_d[RandomInt(1,8)]
	local try_times = 0
	while IsBlocked(Pos2x(position)+d.x,Pos2y(position)+d.y,playerid) ~= false and try_times<200 do
		d = random_d[RandomInt(1,8)]
		try_times = try_times + 1
	end

	if try_times >=200 then
		return nil
	end

	return Arr2Grid(Pos2x(position)+d.x, Pos2y(position)+d.y,playerid)
end
function MoveSpeed2Time(s)
	local t = 2
    if s<160 then t = 2 end
    if s>=160 and s<240 then t = 1.5 end
    if s>240 then t = 1 end
    return t
end

function HeathPlus1(keys)
	Timers:CreateTimer(0.5,function()
		local caster = keys.caster
		
		local h = caster:GetHealth()
		local hmax = caster:GetMaxHealth()
		caster:SetBaseMaxHealth(hmax+1)
		caster:SetMaxHealth(hmax+1)
		caster:SetHealth(h+1)
		PlayParticle("particles/items_fx/healing_flask_c.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,2)
	end)
end

function HeathPlus10(keys)
	Timers:CreateTimer(0.5,function()
		local caster = keys.caster
		
		local h = caster:GetHealth()
		local hmax = caster:GetMaxHealth()
		caster:SetBaseMaxHealth(hmax+10)
		caster:SetMaxHealth(hmax+10)
		caster:SetHealth(h+10)
		EmitSoundOn("Rune.Regen",caster)
		PlayParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf",PATTACH_OVERHEAD_FOLLOW,caster,2)
	end)
end

function HealSelf2Full(keys)
	Timers:CreateTimer(0.5,function()
		local caster = keys.caster
		
		local h = caster:GetHealth()
		local hmax = caster:GetMaxHealth()
		caster:SetHealth(hmax)
		EmitSoundOn("Rune.Regen",caster)
		PlayParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok_ribbon.vpcf",PATTACH_OVERHEAD_FOLLOW,caster,2)
	end)
end

function HealthPlus2(keys)
	Timers:CreateTimer(0.5,function()
		local caster = keys.caster

		local u = CreateUnitByName("invisible_unit", caster:GetAbsOrigin() ,false,nil,nil, caster.team) 

		u:AddAbility('battle_armor_20')
		u:FindAbilityByName('battle_armor_20'):SetLevel(1)

		Timers:CreateTimer(0.1,function()
			local newOrder = {
		 		UnitIndex = u:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		 		TargetIndex = nil, --Optional.  Only used when targeting units
		 		AbilityIndex = u:FindAbilityByName("battle_armor_20"):entindex(), --Optional.  Only used when casting abilities
		 		Position = nil, --Optional.  Only used when targeting the ground
		 		Queue = 0 --Optional.  Used for queueing up abilities
		 	}
			ExecuteOrderFromTable(newOrder)
			Timers:CreateTimer(5,function()
				u:ForceKill(false)
			end)
		end)
	end)
end

function AttackPlus2(keys)
	Timers:CreateTimer(0.5,function()
		local caster = keys.caster

		local u = CreateUnitByName("invisible_unit", caster:GetAbsOrigin() ,false,nil,nil, caster.team) 

		u:AddAbility('battle_attack_plus_2')
		u:FindAbilityByName('battle_attack_plus_2'):SetLevel(1)
		
		Timers:CreateTimer(0.1,function()
			local newOrder = {
		 		UnitIndex = u:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		 		TargetIndex = nil, --Optional.  Only used when targeting units
		 		AbilityIndex = u:FindAbilityByName("battle_attack_plus_2"):entindex(), --Optional.  Only used when casting abilities
		 		Position = nil, --Optional.  Only used when targeting the ground
		 		Queue = 0 --Optional.  Used for queueing up abilities
		 	}
			ExecuteOrderFromTable(newOrder)
			Timers:CreateTimer(5,function()
				u:ForceKill(false)
			end)
		end)
	end)
end

function Heal3(keys)
	Timers:CreateTimer(0.5,function()
		local caster = keys.caster

		local u = CreateUnitByName("invisible_unit", caster:GetAbsOrigin() ,false,nil,nil, caster.team) 

		u:AddAbility('battle_heal_3')
		u:FindAbilityByName('battle_heal_3'):SetLevel(1)
		PlayParticle("particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_pu_ti6_heal_hammers.vpcf",PATTACH_OVERHEAD_FOLLOW,caster,2)
		
		Timers:CreateTimer(0.1,function()
			local newOrder = {
		 		UnitIndex = u:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		 		TargetIndex = nil, --Optional.  Only used when targeting units
		 		AbilityIndex = u:FindAbilityByName("battle_heal_3"):entindex(), --Optional.  Only used when casting abilities
		 		Position = nil, --Optional.  Only used when targeting the ground
		 		Queue = 0 --Optional.  Used for queueing up abilities
		 	}
			ExecuteOrderFromTable(newOrder)
			Timers:CreateTimer(5,function()
				u:ForceKill(false)
			end)
		end)
	end)
end

function ArmorReduce20(keys)
	Timers:CreateTimer(0.5,function()
		local caster = keys.caster

		local u = CreateUnitByName("invisible_unit", caster:GetAbsOrigin() ,false,nil,nil, caster.owner.team) 

		u:AddAbility('battle_armor_reduce_20')
		u:FindAbilityByName('battle_armor_reduce_20'):SetLevel(1)
		PlayParticle("particles/econ/items/slardar/slardar_takoyaki_gold/slardar_crush_tako_ground_dust_pyro_gold.vpcf",PATTACH_OVERHEAD_FOLLOW,caster,2)
		
		Timers:CreateTimer(0.1,function()
			local newOrder = {
		 		UnitIndex = u:entindex(), 
		 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		 		TargetIndex = nil, --Optional.  Only used when targeting units
		 		AbilityIndex = u:FindAbilityByName("battle_armor_reduce_20"):entindex(), --Optional.  Only used when casting abilities
		 		Position = nil, --Optional.  Only used when targeting the ground
		 		Queue = 0 --Optional.  Used for queueing up abilities
		 	}
			ExecuteOrderFromTable(newOrder)
			Timers:CreateTimer(5,function()
				u:ForceKill(false)
			end)
		end)
	end)
end

function GrantChaos(keys)
	local caster = keys.caster
	PlayParticle("particles/econ/items/puck/puck_alliance_set/puck_dreamcoil_waves_aproset.vpcf",PATTACH_OVERHEAD_FOLLOW,keys.caster,2)
	EmitSoundOn("Item.GreevilWhistle",castle)
	local us = FindUnitsInRadius(caster.team,caster:GetAbsOrigin(),nil,384,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
	for i,vi in pairs (us) do
		if vi:FindAbilityByName('modifier_chaosalways') == nil then
			vi:AddAbility("chaosalways")
			vi:FindAbilityByName("chaosalways"):SetLevel(1)
		end
	end
end

function Get1WardCard(keys)
	Timers:CreateTimer(0.5,function()
		local caster = keys.caster
		local r = RandomInt(1,table.maxn(GameRules.all_w_cards))
		local a = GameRules.all_w_cards[r]
		GetCardInQueue({caster=caster,card=a})

		PlayParticle("particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,2)
	end)
end

function GetCardInQueue(keys)
	local caster = keys.caster
	local card = keys.card

	if caster.drawing == true then
		Timers:CreateTimer(0.1,function()
			GetCardInQueue({caster=caster,card=card})
		end)
	else
		caster.drawing = true
		Timers:CreateTimer(1.5,function()
			caster.drawing = false
		end)
		-- if caster:FindAbilityByName(card) ~= nil then
		-- 	caster:FindAbilityByName(card):SetLevel(caster:FindAbilityByName(card):GetLevel()+1)
		-- else
		-- 	caster:AddAbility(card)
		-- 	caster:FindAbilityByName(card):SetLevel(1)
		-- end

		caster:AddAbility(card)
		caster:FindAbilityByName(card):SetLevel(1)

		table.insert(caster.hand,card)

		PutHandCardsInOrder(caster)

		SyncHeroDeckHandItem(caster)

		CustomNetTables:SetTableValue( "dac_table", "draw_card", { steam_id = caster.steam_id,card_id = card, hehe = RandomInt(1,1000)})
	end
end

function PutHandCardsInOrder(caster)
	for i,v in pairs(caster.hand) do
		for ii = i-1,15 do
			if caster:GetAbilityByIndex(ii) ~= nil and caster:GetAbilityByIndex(ii):GetAbilityName() == v then
				caster:SwapAbilities(v,caster:GetAbilityByIndex(i-1):GetAbilityName(),true,true)
				caster:GetAbilityByIndex(i-1):SetLevel(1)
				break
			end
		end
	end

	local hidden_ability_list = {
		'dac_guai_base',
		'root_self',
		'moving_self',
		'mana_recharge_1',
		'mana_recharge_2',
		'mana_recharge_3',
		'mana_recharge_4',
		'mana_recharge_5',
		'mana_recharge_6',
		'mana_recharge_7',
		'mana_recharge_8',
		'mana_recharge_9',
		'mana_recharge_10',
		'river_speed',
	}

	for i,v in pairs(hidden_ability_list) do
		if caster:FindAbilityByName(v)~=nil then
			caster:RemoveAbility(v)
			caster:AddAbility(v)
			caster:FindAbilityByName(v):SetLevel(1)
		end
	end
end
function DropCardInQueue(keys)
	local caster = keys.caster
	local card = keys.card
	if caster.droping == true then
		Timers:CreateTimer(0.1,function()
			DropCardInQueue({caster=caster,card=card})
		end)
	else
		caster.droping = true
		Timers:CreateTimer(2,function()
			caster.droping = false
		end)
		if caster:FindAbilityByName(card) ~= nil then
			local level = caster:FindAbilityByName(card):GetLevel()
			if level == 1 then
				caster:RemoveAbility(card)
			else
				caster:FindAbilityByName(card):SetLevel(level-1)
			end
			CustomNetTables:SetTableValue( "dac_table", "drop_card", { steam_id = caster.steam_id,card_id = card, hehe = RandomInt(1,1000)})
		end
	end
end

function RespawnSelf(keys)
	PlayParticle("particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf",PATTACH_ABSORIGIN_FOLLOW,keys.caster,5)
	Timers:CreateTimer(5,function()
		local uuuu = SummonOneMinion({
			caster = keys.caster.owner, --召唤者单位
			minion = keys.caster:GetUnitName(), --召唤的随从单位名称
			position = keys.caster:GetAbsOrigin(), --召唤的地点
			direction = keys.caster.direction, --方向向量xy（从-1,-1到1,1）
		})
	end)	
end
function ResummonSelf(keys)
	PlayParticle("particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf",PATTACH_ABSORIGIN_FOLLOW,keys.target,5)
	Timers:CreateTimer(5,function()
		local uuuu = SummonOneMinion({
			caster = keys.target.owner, --召唤者单位
			minion = keys.target:GetUnitName(), --召唤的随从单位名称
			position = keys.target:GetAbsOrigin(), --召唤的地点
			direction = keys.target.direction, --方向向量xy（从-1,-1到1,1）
		})
		Timers:CreateTimer(0.1,function()
			PlayParticle("particles/ui/ui_game_start_hero_spawn.vpcf",PATTACH_ABSORIGIN_FOLLOW,uuuu,5)
		end)
	end)	
end

function StopAreaUnits(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local us = FindUnitsInRadius(caster.team,point,nil,384,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
	for i,vi in pairs (us) do
		vi.direction = {x=0,y=0}
		vi.dream_direction = { x=0, y=0 }
		PlayParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_entangle_body.vpcf",PATTACH_ABSORIGIN_FOLLOW,vi,3)
		EmitSoundOn("LoneDruid_SpiritBear.Entangle",vi)
	end
end

function WildCall(keys)
	local caster = keys.caster
	local position = caster:GetAbsOrigin() + caster:GetForwardVector():Normalized()*128

	local y = Pos2y(position)
	local x = Pos2x(position)
	position = Arr2Grid(x,y)

	local y0 = Pos2y(caster:GetAbsOrigin())
	local x0 = Pos2x(caster:GetAbsOrigin())

	local r1 = RandomInt(1,table.maxn(GameRules.all_beast_cards))
	local a1 = GameRules.all_beast_cards[r1]
	SummonOneMinion({
		caster = caster, --召唤者单位
		minion = a1, --召唤的随从单位名称
		position = position, --召唤的地点
		direction = {x=x-x0,y=y-y0}, --方向向量xy（从-1,-1到1,1）
	})
	local r2 = RandomInt(1,table.maxn(GameRules.all_beast_cards))
	local a2 = GameRules.all_beast_cards[r2]
	SummonOneMinion({
		caster = caster, --召唤者单位
		minion = a2, --召唤的随从单位名称
		position = position, --召唤的地点
		direction = {x=x-x0,y=y-y0}, --方向向量xy（从-1,-1到1,1）
	})
	local r3 = RandomInt(1,table.maxn(GameRules.all_beast_cards))
	local a3 = GameRules.all_beast_cards[r3]
	SummonOneMinion({
		caster = caster, --召唤者单位
		minion = a3, --召唤的随从单位名称
		position = position, --召唤的地点
		direction = {x=x-x0,y=y-y0}, --方向向量xy（从-1,-1到1,1）
	})
end

function ReverseDirection(keys)
	local target = keys.target
	local d = target.direction
	target.direction = {x=-d.x,y=-d.y}
end

function FeastCall(keys)
	local caster = keys.caster
	local position = caster:GetAbsOrigin() + caster:GetForwardVector():Normalized()*128

	local y = Pos2y(position)
	local x = Pos2x(position)
	position = Arr2Grid(x,y)

	local y0 = Pos2y(caster:GetAbsOrigin())
	local x0 = Pos2x(caster:GetAbsOrigin())

	local r1 = RandomInt(1,table.maxn(GameRules.all_beast_cards))
	local a1 = GameRules.all_beast_cards[r1]
	SummonOneMinion({
		caster = caster, --召唤者单位
		minion = a1, --召唤的随从单位名称
		position = position, --召唤的地点
		direction = {x=x-x0,y=y-y0}, --方向向量xy（从-1,-1到1,1）
	})
	local r2 = RandomInt(1,table.maxn(GameRules.all_halobios_cards))
	local a2 = GameRules.all_halobios_cards[r2]
	SummonOneMinion({
		caster = caster, --召唤者单位
		minion = a2, --召唤的随从单位名称
		position = position, --召唤的地点
		direction = {x=x-x0,y=y-y0}, --方向向量xy（从-1,-1到1,1）
	})
	local r3 = RandomInt(1,table.maxn(GameRules.all_plant_cards))
	local a3 = GameRules.all_plant_cards[r3]
	SummonOneMinion({
		caster = caster, --召唤者单位
		minion = a3, --召唤的随从单位名称
		position = position, --召唤的地点
		direction = {x=x-x0,y=y-y0}, --方向向量xy（从-1,-1到1,1）
	})
	local r4 = RandomInt(1,table.maxn(GameRules.all_dragon_cards))
	local a4 = GameRules.all_dragon_cards[r4]
	SummonOneMinion({
		caster = caster, --召唤者单位
		minion = a4, --召唤的随从单位名称
		position = position, --召唤的地点
		direction = {x=x-x0,y=y-y0}, --方向向量xy（从-1,-1到1,1）
	})
end

function DealBurningDamage(keys)
	local caster = keys.caster
	local target = keys.target
	if target:entindex() == caster:entindex() then
		return
	end

	local damage = 1
	local damageTable = {
    	victim = target,
    	attacker = caster,
    	damage_type = DAMAGE_TYPE_MAGICAL,
    	damage = damage
    }
    ApplyDamage(damageTable)
end
function DealBurningDamage1(keys)
	local caster = keys.caster
	local target = keys.target
	if target:entindex() == caster:entindex() then
		return
	end

	local damage = 1
	local damageTable = {
    	victim = target,
    	attacker = caster,
    	damage_type = DAMAGE_TYPE_MAGICAL,
    	damage = damage
    }
    ApplyDamage(damageTable)
end
function DealBurningDamage2(keys)
	local caster = keys.caster
	local target = keys.target
	if target:entindex() == caster:entindex() then
		return
	end

	local damage = 2
	local damageTable = {
    	victim = target,
    	attacker = caster,
    	damage_type = DAMAGE_TYPE_MAGICAL,
    	damage = damage
    }
    ApplyDamage(damageTable)
end
function DealBurningDamageInvisible(keys)
	local caster = keys.caster
	local target = keys.target
	if target:entindex() == caster:entindex() then
		return
	end
	local damage = 10
	local damageTable = {
    	victim = target,
    	attacker = caster,
    	damage_type = DAMAGE_TYPE_MAGICAL,
    	damage = damage
    }
    ApplyDamage(damageTable)
end
function Get1SpellCard(keys)
	Timers:CreateTimer(0.5,function()
		local caster = keys.caster
		local r = RandomInt(1,table.maxn(GameRules.all_a_cards))
		local a = GameRules.all_a_cards[r]
		GetCardInQueue({caster=caster,card=a})

		PlayParticle("particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,2)
	end)
end

function Summon3Donkey(keys)
	local caster = keys.caster
	SummonOneMinion({
		caster = caster, --召唤者单位
		minion = GameRules.all_donkey_cards[RandomInt(1,table.maxn(GameRules.all_donkey_cards))], --召唤的随从单位名称
		position = caster:GetAbsOrigin(), --召唤的地点
		direction = caster.direction, --方向向量xy（从-1,-1到1,1）
	})
	SummonOneMinion({
		caster = caster, --召唤者单位
		minion = GameRules.all_donkey_cards[RandomInt(1,table.maxn(GameRules.all_donkey_cards))], --召唤的随从单位名称
		position = caster:GetAbsOrigin(), --召唤的地点
		direction = caster.direction, --方向向量xy（从-1,-1到1,1）
	})
	SummonOneMinion({
		caster = caster, --召唤者单位
		minion = GameRules.all_donkey_cards[RandomInt(1,table.maxn(GameRules.all_donkey_cards))], --召唤的随从单位名称
		position = caster:GetAbsOrigin(), --召唤的地点
		direction = caster.direction, --方向向量xy（从-1,-1到1,1）
	})
end

function Get2SpellCard(keys)
	Timers:CreateTimer(0.5,function()
		local caster = keys.caster
		local r = RandomInt(1,table.maxn(GameRules.all_a_cards))
		local a = GameRules.all_a_cards[r]
		GetCardInQueue({caster=caster,card=a})

		PlayParticle("particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,2)
	end)
	Timers:CreateTimer(1.5,function()
		local caster = keys.caster
		local r = RandomInt(1,table.maxn(GameRules.all_a_cards))
		local a = GameRules.all_a_cards[r]
		GetCardInQueue({caster=caster,card=a})
	end)
end

function Get14xxCard(keys)
	Timers:CreateTimer(0.5,function()
		local caster = keys.caster
		local r = RandomInt(1,table.maxn(GameRules.all_4xx_cards))
		local a = GameRules.all_4xx_cards[r]
		GetCardInQueue({caster=caster,card=a})

		PlayParticle("particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,2)
	end)
end

--召唤吃人随从
function SummonEatMinion(keys)
	local caster = keys.caster
	local position = caster:GetAbsOrigin() + caster:GetForwardVector():Normalized()*128
	local y0 = Pos2y(caster:GetAbsOrigin())
	local x0 = Pos2x(caster:GetAbsOrigin())
	local y = Pos2y(position)
	local x = Pos2x(position)
	local direction = {x=x-x0,y=y-y0}
	position = Arr2Grid(x,y)


	local us = FindUnitsInRadius(caster.team,position,nil,192,DOTA_UNIT_TARGET_TEAM_BOTH,DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
	if us ~= nil and table.maxn(us) > 0 then
		local unluckydog = us[RandomInt(1,table.maxn(us))]
		local y = Pos2y(unluckydog:GetAbsOrigin())
		local x = Pos2x(unluckydog:GetAbsOrigin())
		position = Arr2Grid(x,y)

		

		local damageTable = {
	    	victim = unluckydog,
	    	attacker = caster,
	    	damage_type = DAMAGE_TYPE_PHYSICAL,
	    	damage = 99999
	    }
	    ApplyDamage(damageTable)
		
	    Timers:CreateTimer(0.5,function()
	    	local u = SummonOneMinion({
				caster = caster, --召唤者单位
				minion = keys.minion, --召唤的随从单位名称
				position = position, --召唤的地点
				direction = direction, --方向向量xy（从-1,-1到1,1）
			})
			PlayParticle("particles/radiant_fx/good_barracks_ranged001_lvl3_disintegrate.vpcf",PATTACH_ABSORIGIN_FOLLOW,u,3)

	    end)
	else
		
		SummonOneMinion({
			caster = caster, --召唤者单位
			minion = keys.minion, --召唤的随从单位名称
			position = position, --召唤的地点
			direction = direction, --方向向量xy（从-1,-1到1,1）
		})
	end
	
	--移除手牌
	CastSpell({caster = caster,spell = keys.minion})

end

function Draw1Card(keys)
	Timers:CreateTimer(0.5,function()
		PlayParticle("particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf",PATTACH_ABSORIGIN_FOLLOW,keys.caster,2)
		HeroDrawCard({caster = keys.caster})
	end)
end

function Draw3Card(keys)
	Timers:CreateTimer(0.5,function()
		PlayParticle("particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf",PATTACH_ABSORIGIN_FOLLOW,keys.caster,2)
		HeroDrawCard({caster = keys.caster})
	end)
	Timers:CreateTimer(1.5,function()
		HeroDrawCard({caster = keys.caster})
	end)
	Timers:CreateTimer(2.5,function()
		HeroDrawCard({caster = keys.caster})
	end)
end

function Daze(keys)
	local caster = keys.caster
	PlayParticle("particles/econ/items/puck/puck_alliance_set/puck_dreamcoil_waves_aproset.vpcf",PATTACH_OVERHEAD_FOLLOW,keys.caster,2)
	local us = FindUnitsInRadius(caster.team,caster:GetAbsOrigin(),nil,1024,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
	for i,vi in pairs (us) do
		if vi:FindAbilityByName('modifier_chaosalways') == nil then
			vi:AddAbility("chaosalways")
			vi:FindAbilityByName("chaosalways"):SetLevel(1)
		end
	end
end

function Assassin(keys)
	local caster = keys.caster
	local us = FindUnitsInRadius(caster.team,caster:GetAbsOrigin(),nil,9999,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS,FIND_CLOSEST,false)
	local unluckydog = us[RandomInt(1,table.maxn(us))]

    local info =
    {
        Target = unluckydog,
        Source = caster,
        Ability = nil,
        EffectName = "particles/units/heroes/hero_warlock/warlock_fatal_bonds_base.vpcf",
        bDodgeable = false,
        iMoveSpeed = 1500,
        bProvidesVision = false,
        iVisionRadius = 0,
        iVisionTeamNumber = caster:GetTeamNumber(),
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
    }
    projectile = ProjectileManager:CreateTrackingProjectile(info)

	local t = 1
	PlayParticle("particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_shield_mark.vpcf",PATTACH_OVERHEAD_FOLLOW,unluckydog,t)

	Timers:CreateTimer(t,function()
		PlayParticle("particles/dac/ansha/loadout.vpcf",PATTACH_ABSORIGIN_FOLLOW,unluckydog,5)
		Timers:CreateTimer(0.5,function()
			unluckydog:ForceKill(false)
			EmitSoundOn("Hero_Sniper.AssassinateDamage", unluckydog)
		end)
		
	end)

end

function AttackDamageCleave(keys)
	local caster = keys.caster
	local target = keys.target
	local enemyUnits = FindUnitsInRadius(caster.team,target:GetAbsOrigin(),nil,192,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
	for aaa,unit in pairs(enemyUnits) do
		--获取攻击伤害
		if unit:entindex() == target:entindex() then
			local damage = caster:GetAttackDamage()
		    local damageTable = {
		    	victim=unit,
		    	attacker=caster,
		    	damage_type=DAMAGE_TYPE_PHYSICAL,
		    	damage=damage
		    }
		    ApplyDamage(damageTable)
		else
		    local damage = caster:GetAttackDamage() * 0.5
		    local damageTable = {
		    	victim=unit,
		    	attacker=caster,
		    	damage_type=DAMAGE_TYPE_PURE,
		    	damage=damage
		    }
		    ApplyDamage(damageTable)
		end
	end

end

function Explode1(keys)
	local caster = keys.caster
	Timers:CreateTimer(6,function()
		if caster == nil or caster:IsNull() == true or caster:IsAlive() == false then
			return
		end
		if caster:FindModifierByName('modifier_riki_permanent_invisibility') == nil then
			return 1
		end
		local enemyUnits = FindUnitsInRadius(caster.team,caster:GetAbsOrigin(),nil,512,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
		local trigger = FindUnitsInRadius(caster.team,caster:GetAbsOrigin(),nil,192,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
		if table.maxn(trigger) > 0 then
			caster:RemoveAbility('riki_permanent_invisibility')
			caster:RemoveModifierByName('modifier_riki_permanent_invisibility')
			Timers:CreateTimer(0.2,function()
				EmitSoundOn("ParticleDriven.Rocket.Explode",caster)
				PlayParticle('particles/dac/explode/land_mine_explode.vpcf',PATTACH_OVERHEAD_FOLLOW,caster,2)
				caster:SetModelScale(0.001)
				GameRules:GetGameModeEntity().unit[Pos2x(caster:GetAbsOrigin())][Pos2y(caster:GetAbsOrigin())] = 0
				Timers:CreateTimer(2,function()
					caster:Destroy()
				end)
				for aaa,unit in pairs(enemyUnits) do
					--获取攻击伤害
				    local attack_damage = 15
				    local damage = attack_damage
				    local damageTable = {
				    	victim=unit,
				    	attacker=caster,
				    	damage_type=DAMAGE_TYPE_MAGICAL,
				    	damage=damage
				    }
				    ApplyDamage(damageTable)
				end
				return
			end)
		else
			return 1
		end
	end)
end

function Explode2(keys)
	local caster = keys.caster
	Timers:CreateTimer(6,function()
		if caster == nil or caster:IsNull() == true or caster:IsAlive() == false then
			return
		end
		if caster:FindModifierByName('modifier_riki_permanent_invisibility') == nil then
			return 1
		end
		local enemyUnits = FindUnitsInRadius(caster.team,caster:GetAbsOrigin(),nil,512,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
		local trigger = FindUnitsInRadius(caster.team,caster:GetAbsOrigin(),nil,192,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
		if table.maxn(trigger) > 0 then
			caster:RemoveAbility('riki_permanent_invisibility')
			caster:RemoveModifierByName('modifier_riki_permanent_invisibility')
			Timers:CreateTimer(0.2,function()
				EmitSoundOn("ParticleDriven.Rocket.Explode",caster)
				PlayParticle("particles/dac/zhayaotong/zhayaotong.vpcf",PATTACH_OVERHEAD_FOLLOW,caster,2)
				caster:SetModelScale(0.001)
				GameRules:GetGameModeEntity().unit[Pos2x(caster:GetAbsOrigin())][Pos2y(caster:GetAbsOrigin())] = 0
				Timers:CreateTimer(2,function()
					caster:Destroy()
				end)
				for aaa,unit in pairs(enemyUnits) do
					--获取攻击伤害
				    local attack_damage = 40
				    local damage = attack_damage
				    local damageTable = {
				    	victim=unit,
				    	attacker=caster,
				    	damage_type=DAMAGE_TYPE_MAGICAL,
				    	damage=damage
				    }
				    ApplyDamage(damageTable)
				end
				return
			end)
		else
			return 1
		end
	end)
end
function Explode3(keys)
	local caster = keys.caster
	Timers:CreateTimer(6,function()
		if caster == nil or caster:IsNull() == true or caster:IsAlive() == false then
			return
		end
		if caster:FindModifierByName('modifier_riki_permanent_invisibility') == nil then
			return 1
		end
		local enemyUnits = FindUnitsInRadius(caster.team,caster:GetAbsOrigin(),nil,512,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
		local trigger = FindUnitsInRadius(caster.team,caster:GetAbsOrigin(),nil,192,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
		if table.maxn(trigger) > 0 then
			caster:RemoveAbility('riki_permanent_invisibility')
			caster:RemoveModifierByName('modifier_riki_permanent_invisibility')
			Timers:CreateTimer(0.2,function()
				PlayParticle("particles/units/heroes/hero_techies/techies_stasis_trap_explode.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,3)
				caster:SetModelScale(0.001)
				GameRules:GetGameModeEntity().unit[Pos2x(caster:GetAbsOrigin())][Pos2y(caster:GetAbsOrigin())] = 0
				Timers:CreateTimer(2,function()
					caster:Destroy()
				end)
				local u = CreateUnitByName("invisible_unit", caster:GetAbsOrigin() ,false,nil,nil, caster.team) 

				u:AddAbility('explode_now')
				u:FindAbilityByName('explode_now'):SetLevel(1)
				Timers:CreateTimer(0.1,function()
					local newOrder = {
				 		UnitIndex = u:entindex(), 
				 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				 		TargetIndex = nil, --Optional.  Only used when targeting units
				 		AbilityIndex = u:FindAbilityByName("explode_now"):entindex(), --Optional.  Only used when casting abilities
				 		Position = nil, --Optional.  Only used when targeting the ground
				 		Queue = 0 --Optional.  Used for queueing up abilities
				 	}
					ExecuteOrderFromTable(newOrder)
					Timers:CreateTimer(5,function()
						u:ForceKill(false)
					end)
				end)
				return
			end)
		else
			return 1
		end
	end)
end

function BurnALine(keys)
	local caster = keys.caster
	Timers:CreateTimer(0.4,function()
		local px = Pos2x(caster:GetAbsOrigin())
		local py = Pos2y(caster:GetAbsOrigin())
		local d = caster:GetForwardVector():Normalized()
		local x = px
		local y = py
		d.x = math.floor(d.x+0.5)
		d.y = -math.floor(d.y+0.5)
		x = x + d.x
		y = y + d.y
		while x < 18 and y < 18 and x > 0 and y > 0 do
			-- local u = CreateUnitByName("invisible_unit", Arr2Grid(x,y) ,false,nil,nil, caster.team)
			BurnABrick(x,y,caster.team)
			x = x + d.x
			y = y + d.y
		end
	end)
end

function BurnABrick(xx,yy,team)
	local u = CreateUnitByName("invisible_unit", Arr2Grid(xx,yy) ,false,nil,nil, team)
	-- FindClearSpaceForUnit(u,Arr2Grid(x,y),true)
	Timers:CreateTimer(0.1,function()
		u:AddAbility('burning_soil_aura0')
		u:FindAbilityByName('burning_soil_aura0'):SetLevel(1)
		Timers:CreateTimer(1,function()
			u:ForceKill(false)
		end)
	end)
end

function GrowUp(keys)
	local caster = keys.caster
	local anow = caster:GetAttackDamage()
	local hnow = (caster:GetBaseDamageMax() + caster:GetBaseDamageMin())/2
	local hmax = caster:GetMaxHealth()
	local h = caster:GetHealth()
	local hmax = caster:GetMaxHealth()

	if hmax >= 50 then
		caster:RemoveAbility("growup")
		caster:RemoveModifierByName("modifier_growup")
		return
	end
	caster:SetBaseMaxHealth(hmax+5)
	caster:SetMaxHealth(hmax+5)
	caster:SetHealth(h+5)
	caster:SetBaseDamageMin(hnow+1)
	caster:SetBaseDamageMax(hnow+1)

	caster:SetModelScale((0.8+(hnow/7)))
end

function GrantInvisible(keys)
	local caster = keys.caster
	PlayParticle("particles/items2_fx/smoke_of_deceit.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,4)
	Timers:CreateTimer(0.5,function()
		local us = FindUnitsInRadius(caster.team,caster:GetAbsOrigin(),nil,384,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
		for i,vi in pairs (us) do
			if vi:FindAbilityByName('is_ward') == nil then
				vi:AddAbility('riki_permanent_invisibility')
				vi:FindAbilityByName('riki_permanent_invisibility'):SetLevel(4)
			end
		end
	end)
end

function KeepGrantHidden(keys)
	local caster = keys.caster
	Timers:CreateTimer(0.1,function()
		if not caster:IsAlive() then 
			return 
		else
			local us = FindUnitsInRadius(caster.team,caster:GetAbsOrigin(),nil,384,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
			for i,vi in pairs (us) do
				if vi:FindAbilityByName('riki_permanent_invisibility') == nil then
					vi:AddAbility('riki_permanent_invisibility')
					vi:FindAbilityByName('riki_permanent_invisibility'):SetLevel(4)
					Timers:CreateTimer(6,function()
						PlayParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue_smoke04.vpcf",PATTACH_ABSORIGIN_FOLLOW,vi,2)
					end)
				end
			end
			return 1
		end
	end)
end
function DealAreaDamage(keys)
	Timers:CreateTimer(0.3,function()
		local caster = keys.caster
		local us = FindUnitsInRadius(caster.team,caster:GetAbsOrigin(),nil,384,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
		for i,vi in pairs (us) do
			local damage = 1
			local damageTable = {
		    	victim = vi,
		    	attacker = caster,
		    	damage_type = DAMAGE_TYPE_MAGICAL,
		    	damage = damage
		    }
		    ApplyDamage(damageTable)
		end
	end)
	
end

ALL_ATTACK_EFFECTS = {
	w304 = "particles/units/heroes/hero_razor/razor_static_link_projectile_a.vpcf",
}

--多重箭函数
function DuoChongGongJi( keys )
    local caster = keys.caster
    local target = keys.target
    -- --只对远程有效
    -- if caster:IsRangedAttacker() then
            --获取攻击范围
            local radius = caster:GetAttackRange() +64
            local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
            local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BUILDING
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS
            --获取周围的单位
            local group = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetOrigin(),nil,radius,teams,types,flags,FIND_CLOSEST,true)
            --获取箭的数量
            local attack_count = keys.attack_count or 10
            --获取箭的特效
            local attack_effect = ALL_ATTACK_EFFECTS[caster:GetUnitName()] or "particles/units/heroes/hero_lina/lina_base_attack.vpcf"
            local attack_unit = {}

            --筛选离英雄最近的敌人
            for i,unit in pairs(group) do
                if (#attack_unit)==attack_count then
                        break
                end

                if unit:IsAlive() then
                        table.insert(attack_unit,unit)
                end
            end

            for i,unit in pairs(attack_unit) do
                    local info =
                    {
                        Target = unit,
                        Source = caster,
                        Ability = keys.ability,
                        EffectName = attack_effect,
                        bDodgeable = false,
                        iMoveSpeed = 500,
                        bProvidesVision = false,
                        iVisionRadius = 0,
                        iVisionTeamNumber = caster:GetTeamNumber(),
                        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
                    }
                    projectile = ProjectileManager:CreateTrackingProjectile(info)
            end
    -- end
end

function Gouhe(keys)
	local caster = keys.caster
	local count = 0
	Timers:CreateTimer(0.4,function()
		local px = Pos2x(caster:GetAbsOrigin())
		local py = Pos2y(caster:GetAbsOrigin())
		local d = caster:GetForwardVector():Normalized()
		local x = px
		local y = py
		d.x = math.floor(d.x+0.5)
		d.y = -math.floor(d.y+0.5)
		x = x + d.x
		y = y + d.y
		EmitSoundOn("Hero_EarthShaker.Fissure",caster)
		while x < 18 and y < 18 and x > 0 and y > 0 and count < 5 and IsBlocked(x,y)==false do
			local u = CreateUnitByName("w101", Arr2Grid(x,y) ,false,nil,nil, caster.team)
			count = count + 1
			GameRules:GetGameModeEntity().unit[x][y] = caster.team
			PlayParticle("particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact.vpcf",PATTACH_ABSORIGIN_FOLLOW,u,2)
			x = x + d.x
			y = y + d.y
		end
	end)
end
function show_heal(keys)
	-- DeepPrintTable(keys)
end

function RuneInvisible(keys)
	local caster = keys.caster
	PlayParticle("particles/items2_fx/smoke_of_deceit.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,4)
	Timers:CreateTimer(0.5,function()
		local us = FindUnitsInRadius(caster.team,caster:GetAbsOrigin(),nil,9999,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
		for i,vi in pairs (us) do
			if vi:FindAbilityByName('is_ward') == nil then
				vi:AddAbility('riki_permanent_invisibility')
				vi:FindAbilityByName('riki_permanent_invisibility'):SetLevel(4)
			end
		end
	end)
end
function RuneBig(keys)
	local caster = keys.caster
	Timers:CreateTimer(0.5,function()
		local us = FindUnitsInRadius(caster.team,caster:GetAbsOrigin(),nil,9999,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,FIND_CLOSEST,false)
		for i,vi in pairs (us) do
			PlayParticle("particles/radiant_fx/tower_good3_dest_beam.vpcf",PATTACH_ABSORIGIN_FOLLOW,vi,4)
			if vi:FindAbilityByName('is_ward') == nil and vi.huge == nil then
				vi:SetModelScale(vi:GetModelScale()*1.5)
				local healthb = vi:GetHealth()
				local attackb = (vi:GetBaseDamageMax() + vi:GetBaseDamageMin())/2
				local healthmax = vi:GetMaxHealth()
				vi:SetMaxHealth(healthmax*5)
				vi:SetHealth(healthb*5)
				vi:SetBaseDamageMin(attackb*2)
				vi:SetBaseDamageMax(attackb*2)
				vi.huge = true
			end
		end
	end)
end


function GetCurrScore()
	local hp_r = GameRules:GetGameModeEntity().good_castle.hp
	local hp_d = GameRules:GetGameModeEntity().bad_castle.hp
	return hp_r - hp_d
end

GameRules.all_m_w_a_cards = {
	'm101','m102','m103','m104','m105','m106','m107','m108','m109','m110','m111','m112','m113','m114','m201','m202','m203','m204','h101','a101','a102','a103','a104','a105','a106','a107','a108','a109','w101','w102','w103','w104','w105','w106','w107','w108','w109','m201','m202','m203','m204','m205','m206','m207','m208','m209','m210','m211','m212','m213','m214','m215','m216','m217','m218','a201','a202','a203','a204','a205','a206','a207','w201','w202','w203','w204','w205','m301','m302','m303','m304','m305','m306','m307','m308','m309','m310','m311','m312','m313','a301','a302','a303','a304','a305','a306','w301','w302','w303','w304','w305','w306','m401','m402','m403','m404','m405','m406','m407','m408','m409','m410','a401','a402','a403','a404','a405','w401','w402',
}
GameRules.all_w_cards = {
	'w101','w102','w103','w104','w105','w106','w107','w108','w109','w201','w202','w203','w204','w205','w301','w302','w303','w304','w305','w306','w401','w402',
}
GameRules.all_beast_cards = {
	'm104','m105','m107','m108','m109','m110','m113','m208','m215','m407','m409',
}
GameRules.all_halobios_cards = {
	'm209','m311','m312','m410',
}
GameRules.all_plant_cards = {
	'm111',
}
GameRules.all_ghost_cards = {
	'm210','m214','m303','m310','m404',
}
GameRules.all_dragon_cards = {
	'm202','m217','m218','m305','m402',
}
GameRules.all_a_cards = {
	'a101','a102','a103','a104','a105','a106','a107','a108','a109','a201','a202','a203','a204','a205','a206','a207','a301','a302','a303','a304','a305','a306','a401','a402','a403','a404','a405',
}
GameRules.all_donkey_cards = {
	'm101','m102','m211','m205',
}
GameRules.all_4xx_cards = {
	'm401','m402','m403','m404','m405','m406','m407','m408','m409','m410','a401','a402','a403','a404','a405','w401','w402',
}

GameRules.all_runes = {
	[1] = {
		"rune_attack",
		"rune_regeneration",
		"rune_speed",
	},
	[2] = {
		"rune_attack",
		"rune_regeneration",
		"rune_speed",
		"rune_aim",
		"rune_mango",
		"rune_invisible",
	},
	[3] = {
		"rune_attack",
		"rune_regeneration",
		"rune_speed",
		"rune_aim",
		"rune_mango",
		"rune_invisbile",
		"rune_defend",
		"rune_big",
		"rune_curse",
	},
}


GameRules.good_castle = nil
GameRules.bad_castle = nil

--出牌音效
PROLOGUE = {
	m103 = {"Hero_ShadowShaman.Hex.Target"},
	m105 = {"General.Pig"},
	m106 = {"Hero_Lion.Hex.Target"},
	m107 = {"greevil_courier.grunt"},
	m108 = {"Hero_LoneDruid.BattleCry.Bear"},
	m112 = {""},
	m201 = {"RoshanDT.Scream"},
	m206 = {"tinker_tink_move_11"},
	m209 = {"Hero_Lion.Fishstick.Target"},
	m214 = {"death_prophet_dpro_spawn_02"},
	m215 = {"Hero_LoneDruid.BattleCry.Bear"},
	m301 = {"techies_tech_move_38","techies_tech_move_39"},
	m302 = {"greevil_courier.grunt"},
	m304 = {"doom_bringer_doom_level_04"},
	m307 = {"nyx_assassin_nyx_move_06"},
	m309 = {"tinker_tink_travel_02"},
	m312 = {"Hero_Lion.Fishstick.Target"},
	m313 = {"stormspirit_ss_anger_01","stormspirit_ss_anger_02","stormspirit_ss_anger_03","stormspirit_ss_anger_04"},
	m401 = {"rattletrap_ratt_level_02","rattletrap_ratt_level_20","rattletrap_ratt_level_21"},
	m402 = {"dragon_knight_drag_move_13","dragon_knight_drag_move_10"},
	m403 = {"tiny_tiny_spawn_08","tiny_tiny_spawn_06","tiny_tiny_spawn_02"},
	m404 = {"death_prophet_dpro_spawn_02","death_prophet_dpro_spawn_04","death_prophet_dpro_spawn_05"},
	m405 = {"lina_lina_lose_03","lina_lina_kill_06"},
	m406 = {"tinker_tink_cast_01","tinker_tink_bottle_01"},
	m407 = {"lycan_lycan_ability_howl_01","lycan_lycan_wolf_move_02"},
	m408 = {"shredder_timb_kill_01","shredder_timb_kill_02","shredder_timb_kill_03"},
	m409 = {"ursa_ursa_spawn_05","ursa_ursa_respawn_13"},
	m410 = {"enchantress_ench_spawn_03","enchantress_ench_invis_01","enchantress_ench_happy_03"},
}

function PrepareARound(teamid)
	local occupied_count = 0
	for i=1,8 do
		if GameRules:GetGameModeEntity().hand[teamid][i] == 1 then
			occupied_count = occupied_count + 1
		end
	end
	local new_count = 2
	if GameRules:GetGameModeEntity().battle_round == 1 then
		new_count = 4
	end

	if TeamId2Hero(teamid):FindAbilityByName('h202_ability') ~= nil and RandomInt(1,100) < 20 then
		new_count = 2
	end
	if new_count + occupied_count > 8 then
		new_count = 8 - occupied_count
	end
	local last_draw = nil
	Timers:CreateTimer(function()
		for j=1,new_count do
			if GameRules:GetGameModeEntity().battle_round == 1 then
				RandomOneChessInHand(teamid)
			else
				RandomOneChessInHand(teamid,true)
			end
			new_count = new_count - 1
			if new_count <= 0 then
				return
			end
			return 1
		end
	end)
end

function RandomOneChessInHand(team_id,use_crab)
	local index = FindEmptyHandSlot(team_id)

	if PlayerResource:GetPlayer(GameRules:GetGameModeEntity().team2playerid[team_id]) == nil then
		return
	end

	if index ~= nil then
		local h = TeamId2Hero(team_id)
		local x = nil
		local this_chess = nil
		if GameRules:GetGameModeEntity().next_crab ~= nil then
			x = CreateUnitByName(GameRules:GetGameModeEntity().next_crab,HandIndex2Vector(team_id,index),true,nil,nil,team_id)
			GameRules:GetGameModeEntity().next_crab = nil
		else
			local ran = RandomInt(1,100)
			local chess_level = 1
			local curr_per = 0
			local hero_level = h:GetLevel()
			if GameRules:GetGameModeEntity().chess_gailv[hero_level] ~= nil then
				for per,lv in pairs(GameRules:GetGameModeEntity().chess_gailv[hero_level]) do
					if ran>per and curr_per<=per then
						curr_per = per
						chess_level = lv
					end
				end
			end
			this_chess = GameRules:GetGameModeEntity().chess_list_by_mana[chess_level][RandomInt(1,table.maxn(GameRules:GetGameModeEntity().chess_list_by_mana[chess_level]))]
			x = CreateUnitByName(this_chess,HandIndex2Vector(team_id,index),true,nil,nil,team_id)
		end

		GameRules:GetGameModeEntity().hand[team_id][index] = 1
		if h.hand_entities == nil then
			h.hand_entities = {}
		end

		h.hand_entities[index] = x
		setHandStatus(team_id)

		x:SetForwardVector(Vector(0,1,0))
		x.hand_index = index
		x.team_id = team_id
		x.owner_player_id = GameRules:GetGameModeEntity().team2playerid[team_id]
		
		AddAbilityAndSetLevel(x,'root_self')
		AddAbilityAndSetLevel(x,'jiaoxie_wudi')

		play_particle("particles/econ/items/antimage/antimage_ti7/antimage_blink_start_ti7_ribbon_bright.vpcf",PATTACH_ABSORIGIN_FOLLOW,x,5)

		--添加战斗技能
		if GameRules:GetGameModeEntity().chess_ability_list[x:GetUnitName()] ~= nil then
			local a = GameRules:GetGameModeEntity().chess_ability_list[x:GetUnitName()]
			if x:FindAbilityByName(a) == nil then
				AddAbilityAndSetLevel(x,a,0)
			end
		end
		if TeamId2Hero(team_id):FindAbilityByName('h403_ability') ~= nil and use_crab == true then
			GameRules:GetGameModeEntity().next_crab = this_chess
		end
	end
end

--游戏循环1.3——提示可以上场的牌-暂时不用了
function setHandStatus(team_id)
	local h = TeamId2Hero(team_id)
	local mana = h:GetMana()
	if h.hand_entities ~= nil then
		for _,v in pairs(h.hand_entities) do
			if v ~= nil then
				local level = GetMinionManaCost(v)
				if level <= mana and GameRules:GetGameModeEntity().game_status == 1 then
					--有蓝
					AddAbilityAndSetLevel(v,'act_teleport')
					AddCostParticle(v, level)
					-- GameRules:SendCustomMessage('有蓝-->'..v:GetUnitName(),0,0)
				else
					--没蓝
					v:RemoveAbility('act_teleport')
					v:RemoveModifierByName('modifier_act_teleport')
					RemoveCostParticle(v)
					-- GameRules:SendCustomMessage('没蓝-->'..v:GetUnitName(),0,0)
				end
			end
		end
	end
end
--添加/删除头上的数字（费）特效
function AddCostParticle(unit, level)
	if unit == nil then
		return
	end
	if unit.hand_status_particle == nil then
		unit.hand_status_particle = ParticleManager:CreateParticle("effect/arrow/"..level..".vpcf", PATTACH_OVERHEAD_FOLLOW, unit)
	end
end
function RemoveCostParticle(unit)
	if unit == nil then
		return
	end
	if unit.hand_status_particle ~= nil then
		ParticleManager:DestroyParticle(unit.hand_status_particle,true)
		unit.hand_status_particle = nil
	end
end
--添加/删除头上的星星（等级）特效
function showStarParticle(unit)
	if unit == nil then
		return
	end
	local level = 1
	if string.find(unit:GetUnitName(),'1') then
		level = 2
	end
	if string.find(unit:GetUnitName(),'11') then
		level = 3
	end
	AMHC:CreateParticle("effect/arrow/star"..level..".vpcf",PATTACH_OVERHEAD_FOLLOW,false,unit,5)
end