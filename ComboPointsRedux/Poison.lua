--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
Poison.lua - A module for tracking deadly poison stacks
$Date: 2010-08-05 21:11:39 +0000 (Thu, 05 Aug 2010) $
$Revision: 125 $
Project Version: 2.0.0 beta4
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2010 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "ROGUE" then return end

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Deadly Poison"
local Poison = cpr:NewModule(modName, "AceConsole-3.0", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
Poison.abbrev = "DP"
Poison.MAX_POINTS = 5
Poison.displayName = GetSpellInfo(2823)
local UnitAura = UnitAura
local strfind = string.find


function Poison:OnInitialize()
	self.graphics = cpr:MakeGraphicsFrame(modName, self.MAX_POINTS)
	self.text = cpr:MakeTextFrame(modName)
end

function Poison:OnEnable()
	if not cpr.db.profile.modules[modName].disableGraphics then
		self.graphics:Show()
	end
	if not cpr.db.profile.modules[modName].disableText then
		self.text:Show()
	end
	
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
end

function Poison:OnDisable()
	self.graphics:Hide()
	self.text:Hide()
	self:UnregisterAllEvents()
end

function Poison:UNIT_AURA(event, unit)
	if unit ~= "target" then return end
	
	if UnitIsDead("target") then
		return self:UpdateDeadlyPoison(0)
	end
		
	local icon, count, _
	local i = 1
	
	if UnitExists("target") then
		while UnitAura("target", i, "PLAYER|HARMFUL") ~= nil do
			_, _, icon, count = UnitAura("target", i, "PLAYER|HARMFUL")
			if strfind(icon, "Ability_Rogue_DualWeild") then
				self:UpdateDeadlyPoison(count)
				return
			end
			i = i + 1
		end
	end
	
	self:UpdateDeadlyPoison(0)
end

function Poison:PLAYER_TARGET_CHANGED()
	self:UNIT_AURA(nil, "target")
end

function Poison:UpdateDeadlyPoison(stacks)
	local r, g, b = cpr:GetColorByPoints(modName, stacks)
	
	if stacks == 0 then
		for i = 1, self.MAX_POINTS do
			self.graphics.points[i]:Hide()
		end
		stacks = ""
	elseif stacks == 5 then
		for i = stacks, 1, -1 do
			self.graphics.points[i].icon:SetVertexColor(r, g, b)
			self.graphics.points[i]:Show()
		end
	else
		for i = stacks, 1, -1 do
			self.graphics.points[i].icon:SetVertexColor(r, g, b)
			self.graphics.points[i]:Show()
		end
		for j = self.MAX_POINTS, stacks+1, -1 do
			self.graphics.points[j]:Hide()
		end
	end
	
	self.text:SetNumPoints(stacks)
end
