if select(2, UnitClass"player") ~= "PRIEST" then return end

local addon = CreateFrame"Frame"
local addonname = ...

local spellname = GetSpellInfo(15286)

addon:RegisterEvent"ADDON_LOADED"
addon:RegisterEvent"UNIT_AURA"
addon:SetScript("OnEvent", function(self, e, arg)
	if (e == "UNIT_AURA" and arg == "player") or
	   (e == "ADDON_LOADED" and arg == addonname) then

		if UnitAura("player", spellname) then
			SetCVar("CombatHealing", 0)
		else
			SetCVar("CombatHealing", 1)
		end
	end
end)
