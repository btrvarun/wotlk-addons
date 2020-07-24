local pName = UnitName("player")

--------------------------------
--[[ Announcement Functions ]]--
--------------------------------
local function Print_Self(message) -- Sends a message to your default chat window.
	_G.ChatFrame1:AddMessage("|cFFFF75B3TFTB:|r " .. format(message, spellinfo))
end

local function Print_Self_RW(message) -- Sends a message locally to the raid warning frame. Only visible to the user.
	local RWColor = {r=1, g=1, b=1}
	RaidNotice_AddMessage(RaidWarningFrame, format(message, spellinfo), RWColor)
end

local function Print_Whisper(message, target) -- Sends a whisper to the target.
	SendChatMessage(format(message, spellinfo), "WHISPER", nil, target)
end

----------------------------------------------------------
--[[ The event checking section. Look for our spells! ]]--
----------------------------------------------------------
local spells = CreateFrame("Frame", "TFTB_SPELLS")
spells:SetScript("OnEvent", function(_, _, _, event, _, source, _, _, dest, _, spellID, _, _, missType)

		if event == "SPELL_ENERGIZE" then
			if source == pName and dest == pName then
				if spellID == 57776 then
					spellinfo = GetSpellInfo(spellID)
					Print_Self("You have just received " .. missType .. " Mana from %s!")
					Print_Self_RW("You have just received " .. missType .. " Mana from %s!")				
				end
			end		
		
		
		elseif event == "SPELL_AURA_APPLIED" then
		
			if source ~= pName and dest == pName then
			
				if spellID == 54646 or spellID == 47788 or spellID == 29166 or spellID == 57934 or spellID == 1038 or spellID == 10060 or spellID == 50720 or spellID == 1044 or spellID == 48788 or spellID == 53601 or spellID == 10278 or spellID == 6940 or spellID == 19752 then
					spellinfo = GetSpellInfo(spellID)
					--if TFTB.db.profile.raid_warn == 1 or TFTB.db.profile.raid_warn == 3 then
						Print_Whisper("Thank you for %s!", source)
					--end
					--if TFTB.db.profile.raid_warn == 2 or TFTB.db.profile.raid_warn == 3 then
						Print_Self_RW("You have just received %s!")
					--end	
				end
				
				if spellID == 48066 or spellID == 48065 or spellID == 1044 or spellID == 25218 or spellID == 25217 or spellID == 10901 or spellID == 10900 or spellID == 10899 or 
					spellID == 10898 or spellID == 6066 or spellID == 6065 or spellID == 3747 or spellID == 600 or spellID == 592 or spellID == 17 or 
					spellID == 64904 or spellID == 58597 or spellID == 47753 then
					spellinfo = GetSpellInfo(spellID)
					Print_Self("You have just received %s!")
					Print_Self_RW("You have just received %s!")
				end				

			elseif source == pName and dest ~= pName then
				if spellID == 130 then
					spellinfo = GetSpellInfo(spellID)
					Print_Whisper("I have just given you %s, use it wisely!", dest)
				end
				
			end

		elseif event == "SPELL_AURA_REMOVED" then
		
			if source == pName and dest ~= pName then
				if spellID == 54646 then
				spellinfo = GetSpellInfo(spellID)
					Print_Self("Your %s has just ended on " .. dest .. "!")
					Print_Self_RW("Your %s has just ended on " .. dest .. "!")
				end

		
			end
			
		end -- End of the If checking which event is fired.		
end) -- Final end for the OnEvent function.
spells:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")