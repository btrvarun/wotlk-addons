--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
Combo.lua - A module for tracking combo points
$Date: 2010-08-05 21:11:39 +0000 (Thu, 05 Aug 2010) $
$Revision: 125 $
Project Version: 2.0.0 beta4
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2010 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Combo Points"
local ComboModule = cpr:NewModule(modName, "AceConsole-3.0", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
ComboModule.abbrev = "CP"
ComboModule.MAX_POINTS = 5
ComboModule.displayName = COMBAT_TEXT_SHOW_COMBO_POINTS_TEXT

function ComboModule:OnInitialize()
	self.graphics = cpr:MakeGraphicsFrame(modName, self.MAX_POINTS)
	self.text = cpr:MakeTextFrame(modName)
end

function ComboModule:OnEnable()
	if not cpr.db.profile.modules[modName].disableGraphics then
		self.graphics:Show()
	end
	if not cpr.db.profile.modules[modName].disableText then
		self.text:Show()
	end
	
	self:RegisterEvent("UNIT_COMBO_POINTS")
	self:RegisterEvent("PLAYER_TARGET_CHANGED", "UNIT_COMBO_POINTS")
end

function ComboModule:OnDisable()
	self.graphics:Hide()
	self.text:Hide()
	self:UnregisterAllEvents()
end

function ComboModule:UNIT_COMBO_POINTS()
	local points = GetComboPoints(UnitHasVehicleUI("player") and "vehicle" or "player", "target")
	if UnitIsDead("target") then points = 0 end
	local r, g, b = cpr:GetColorByPoints(modName, points)
	
	if points == 0 then
		for i = 1, self.MAX_POINTS do
			self.graphics.points[i]:Hide()
		end
		points = ""
	else
		for i = points, 1, -1 do
			self.graphics.points[i].icon:SetVertexColor(r, g, b)
			self.graphics.points[i]:Show()
		end
	end
	self.text:SetNumPoints(points)
end
