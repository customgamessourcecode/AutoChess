
----------------
--这里实现KV接口
----------------

--匹配伤害类型
function AMHC:DamageType( _type )
	if _type == "DAMAGE_TYPE_MAGICAL" then
		return DAMAGE_TYPE_MAGICAL
	elseif _type == "DAMAGE_TYPE_PHYSICAL" then
		return DAMAGE_TYPE_PHYSICAL
	elseif _type == "DAMAGE_TYPE_PURE" then
		return DAMAGE_TYPE_PURE
	else
		error("AMHC:Damage:DamageType is error",2)
	end
end

----------------------------------------------------------------------------------------------------------
--伤害-单体
-- "RunScript"
-- {
-- 	"ScriptFile"	"scripts/vscripts/amhc_library/KV.lua"
-- 	"Function"		"DamageTarget"
-- 	"Damage"		"%attack_damage"		//伤害
-- 	"DamageType"	"DAMAGE_TYPE_PHYSICAL"	//伤害类型
-- 	"Scale"			"%scale"				//可选，伤害比例
-- }
function DamageTarget( keys )
	local caster = keys.caster
	local target = keys.target

	if target == caster then
		if keys.attacker ~= nil then
			target = keys.attacker
		else
			return
		end
	end

	AMHC:Damage( caster,target,keys.Damage,AMHC:DamageType(keys.DamageType),keys.Scale )
end


----------------------------------------------------------------------------------------------------------
--伤害AOE
-- "RunScript"
-- {
-- 	"ScriptFile"	"scripts/vscripts/amhc_library/KV.lua"
-- 	"Function"		"DamageAOE"
-- 	"Damage"		"%attack_damage"		//伤害
-- 	"DamageType"	"DAMAGE_TYPE_PHYSICAL"	//伤害类型
-- 	"Scale"			"%scale"				//可选
-- 	"Target"
--     {
--         "Types"     "DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_HERO"
--         "Teams"     "DOTA_UNIT_TARGET_TEAM_ENEMY"
--         "Flags"     "DOTA_UNIT_TARGET_FLAG_NONE"
--         "Center"    "CASTER"
--         "Radius"    "500"
--     }
-- }
function DamageAOE( keys )
	local caster = keys.caster
	local group = keys.target_entities

	for k,v in pairs(group) do
		caster:Damage(v,keys.Damage,AMHC:DamageType(keys.DamageType),keys.Scale)
	end
end


----------------------------------------------------------------------------------------------------------
--增大模型
function AddModelScale( keys )
	local target = keys.target

	if target == nil then
		target = keys.caster
	end

	AMHC:AddModelScale( target,tonumber(keys.Scale),tonumber(keys.Duration) )
end