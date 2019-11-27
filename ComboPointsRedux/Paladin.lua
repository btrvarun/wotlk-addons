--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
Paladin.lua - A module for tracking Holy Vengeance or Blood Corruption stacks
$Date: 2010-08-18 22:08:01 +0000 (Wed, 18 Aug 2010) $
$Revision: 140 $
Project Version: 2.0.0 beta4
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2010 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "PALADIN" then return end

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Paladin"
local PaladinModule = cpr:NewModule(modName, "AceConsole-3.0", "AceEvent-3.0")
local buff = IsSpellKnown(53736) and GetSpellInfo(53742) or GetSpellInfo(31803)
PaladinModule.MAX_POINTS = 5
PaladinModule.displayName = buff
PaladinModule.abbrev = "P"

function PaladinModule:OnInitialize()
	self.graphics = cpr:MakeGraphicsFrame(modName, self.MAX_POINTS)
	self.text = cpr:MakeTextFrame(modName)
end

function PaladinModule:OnEnable()
	if not cpr.db.profile.modules[modName].disableGraphics then
		self.graphics:Show()
	end
	if not cpr.db.profile.modules[modName].disableText then
		self.text:Show()
	end
	
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
end

function PaladinModule:OnDisable()
	self.graphics:Hide()
	self.text:Hide()
	self:UnregisterAllEvents()
end

function PaladinModule:UNIT_AURA(_, unit)
	if unit ~= "target" then return end
	
	local _, _, _, count = UnitAura("target", buff, nil, "PLAYER|HARMFUL")
	if count then
		local r, g, b = cpr:GetColorByPoints(modName, count)
		for i = count, 1, -1 do
			self.graphics.points[i].icon:SetVertexColor(r, g, b)
			self.graphics.points[i]:Show()
		end
		for j = self.MAX_POINTS, count+1, -1 do
			self.graphics.points[j]:Hide()
		end
		self.text:SetNumPoints(count)
	else
		for i = 1, self.MAX_POINTS do
			self.graphics.points[i]:Hide()
		end
		self.text:SetNumPoints("")
	end
end

function PaladinModule:PLAYER_TARGET_CHANGED()
	self:UNIT_AURA(nil, "target")
end
