modifier_status_resistance = class({})

function modifier_status_resistance:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    }
    return funcs
end
function modifier_status_resistance:GetModifierStatusResistanceStacking(t)
    return 100
end
function modifier_status_resistance:IsHidden() 
    return false
end
