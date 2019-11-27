--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
Serendipity.lua - A module for tracking Serendipity buff stacks
$Date: 2010-08-15 21:33:14 +0000 (Sun, 15 Aug 2010) $
$Revision: 136 $
Project Version: 2.0.0 beta4
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2010 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "PRIEST" then return end

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Serendipity"
local SerendipityModule = cpr:NewModule(modName, "AceConsole-3.0", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
SerendipityModule.abbrev = "S"
SerendipityModule.MAX_POINTS = 3
SerendipityModule.displayName = GetSpellInfo(63734)

function SerendipityModule:OnInitialize()
	self.graphics = cpr:MakeGraphicsFrame(modName, self.MAX_POINTS)
	self.text = cpr:MakeTextFrame(modName)
end

function SerendipityModule:OnEnable()
	if not cpr.db.profile.modules[modName].disableGraphics then
		self.graphics:Show()
	end
	if not cpr.db.profile.modules[modName].disableText then
		self.text:Show()
	end
	
	self:RegisterEvent("UNIT_AURA")
end

function SerendipityModule:OnDisable()
	self.graphics:Hide()
	self.text:Hide()
	self:UnregisterAllEvents()
end

local buff = GetSpellInfo(63734)
function SerendipityModule:UNIT_AURA(_, unit)
	if unit ~= "player" then return end
	
	local _, _, _, count = UnitBuff("player", buff)
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
