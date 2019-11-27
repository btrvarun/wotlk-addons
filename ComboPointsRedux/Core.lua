--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
$Date: 2010-08-15 21:58:13 +0000 (Sun, 15 Aug 2010) $
$Revision: 137 $
Project Version: 2.0.0 beta4
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2010 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

local ComboPointsRedux = LibStub("AceAddon-3.0"):NewAddon("ComboPointsRedux", "AceConsole-3.0")
ComboPointsRedux:SetDefaultModuleState(false)
local LSM = LibStub("LibSharedMedia-3.0")
local basepath = [[Interface\Addons\ComboPointsRedux\Icons\]]

function ComboPointsRedux:OnInitialize()
	local defaults = {
		profile = {
			modules = {
				['**'] = {
					enabled = true,
					--text options
					font = "Friz Quadrata TT",
					fontsize = 12,
					textColor = {1, 1, 1},
					textAlpha = 1,
					textStrata = "HIGH",
					textPos = {},
					disableText = false,
					--graphics options
					orientation = "h",
					icon = "square",
					colors = {
						['**'] = {1, 0.9, 0},
						[5] = {1, 0, 0},
					},
					graphicsAlpha = 1,
					spacing = 5,
					scale = 1,
					strata = "HIGH",
					graphicsPos = {},
					disableGraphics = false,
				},
				['Deadly Poison'] = {
					colors = {
						[1] = {0, 1, 0},
						[2] = {0, 1, 0},
						[3] = {0, 1, 0},
						[4] = {0, 1, 0},
						[5] = {0, 0.5, 0},
					},
				},
			},
			locked = false,
		}
	}
	
	self.db = LibStub("AceDB-3.0"):New("CPRDB2", defaults, "Default")
	
	self.db.RegisterCallback(self, "OnProfileReset", "Reset")
	self.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
	self.db.RegisterCallback(self, "OnProfileChanged", "Refresh")
	
	self:RegisterChatCommand("cpr", "OpenConfig", true, true)
	self:RegisterChatCommand("cpredux", "OpenConfig", true, true)
end

function ComboPointsRedux:OnEnable()
	for name, module in self:IterateModules() do
		if self.db.profile.modules[name].enabled then
			module:Enable()
		end
	end
end

function ComboPointsRedux:Reset()
	for name, module in self:IterateModules() do
		if module:IsEnabled() then
			local db = self.db.profile.modules[name]
			module.text:ClearAllPoints()
			module.graphics:ClearAllPoints()
			module.text:SetPoint("CENTER", UIParent, "CENTER")
			module.graphics:SetPoint("CENTER", UIParent, "CENTER")
			
			module.graphics:SetWidth(145*db.scale)
			module.graphics:SetHeight(25*db.scale)
			
			for i = 1, module.MAX_POINTS do
				module.graphics.points[i].icon:SetTexture(basepath..db.icon)
				module.graphics.points[i]:SetWidth(25*db.scale)
				module.graphics.points[i]:SetHeight(25*db.scale)
				module.graphics.points[i]:ClearAllPoints()
			end
			
			local offset = db.spacing*db.scale
			module.graphics.points[1]:SetPoint("LEFT", module.graphics, "LEFT", 0, 0)
			for i = 2, module.MAX_POINTS do
				module.graphics.points[i]:SetPoint("LEFT", module.graphics.points[i-1], "RIGHT", offset, 0)
			end
			
			module.graphics:SetBackdropColor(1,1,1,1)
			module.graphics:EnableMouse(true)
			module.graphics:SetMovable(true)
			module.graphics.points[1]:Show()
			module.graphics.points[2]:Show()
			
			module.text:SetBackdropColor(1,1,1,1)
			module.text:EnableMouse(true)
			module.text:SetMovable(true)
			module.text:SetNumPoints(module.abbrev)
		end
	end
end

function ComboPointsRedux:Refresh()
	for name, module in self:IterateModules() do
		if module:IsEnabled() then
			--update will refresh all settings but the frame positions
			self:UpdateSettings(name, module)
			
			--adjust frame positions
			local db = self.db.profile.modules[name]
			module.text:ClearAllPoints()
			module.graphics:ClearAllPoints()
			if db.textPos.x then
				module.text:SetPoint(db.textPos.point, UIParent, db.textPos.anchor, db.textPos.x, db.textPos.y)
			else
				module.text:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
			end
			
			if db.graphicsPos.x then
				module.graphics:SetPoint(db.graphicsPos.point, UIParent, db.graphicsPos.anchor, db.graphicsPos.x, db.graphicsPos.y)
			else
				module.graphics:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
			end
			
			if self.db.profile.locked then
				module.text:EnableMouse(false)
				module.text:SetMovable(false)
				module.text:SetBackdropColor(1,1,1,0)
				module.text:SetNumPoints("")
				
				module.graphics:SetBackdropColor(1,1,1,0)
				module.graphics:EnableMouse(false)
				module.graphics:SetMovable(false)
				module.graphics.points[1]:Hide()
				module.graphics.points[2]:Hide()
			else
				module.text:SetBackdropColor(1,1,1,1)
				module.text:EnableMouse(true)
				module.text:SetMovable(true)
				module.text:SetNumPoints(module.abbrev)
				
				module.graphics:SetBackdropColor(1,1,1,1)
				module.graphics:EnableMouse(true)
				module.graphics:SetMovable(true)
				module.graphics.points[1]:Show()
				module.graphics.points[2]:Show()
			end
		end
	end
end

function ComboPointsRedux:UpdateSettings(name)
	local db = self.db.profile.modules[name]
	local module = self:GetModule(name)
	
	--graphics
	if not db.disableGraphics then
		--change icon textures
		--update icon Alpha
		for i = 1, module.MAX_POINTS do
			module.graphics.points[i].icon:SetTexture(basepath..db.icon)
			module.graphics.points[i]:SetAlpha(db.graphicsAlpha)
			module.graphics.points[i]:SetWidth(25*db.scale)
			module.graphics.points[i]:SetHeight(25*db.scale)
			module.graphics.points[i]:ClearAllPoints()
		end
		
		--adjust container scale
		if db.orientation == "v" then
			module.graphics:SetHeight(145*db.scale)
			module.graphics:SetWidth(25*db.scale)
		else
			module.graphics:SetWidth(145*db.scale)
			module.graphics:SetHeight(25*db.scale)
		end
		
		--adjust for orientation changes (this updates spacing too)
		local offset = db.spacing*db.scale
		if db.orientation == "v" then
			module.graphics.points[1]:SetPoint("BOTTOM", module.graphics, "BOTTOM", 0, 0)
			for i = 2, module.MAX_POINTS do
				module.graphics.points[i]:SetPoint("BOTTOM", module.graphics.points[i-1], "TOP", 0, offset)
			end
		else
			module.graphics.points[1]:SetPoint("LEFT", module.graphics, "LEFT", 0, 0)
			for i = 2, module.MAX_POINTS do
				module.graphics.points[i]:SetPoint("LEFT", module.graphics.points[i-1], "RIGHT", offset, 0)
			end
		end
		
		--update strata
		module.graphics:SetFrameStrata(db.strata)
	end
	
	--text
	if not db.disableText then
		--update font, font size, alpha and strata
		module.text.count:SetShadowColor(0, 0, 0, db.textAlpha)
		module.text.count:SetFont(LSM:Fetch("font", db.font), db.fontsize)
		module.text.count:SetTextColor(unpack(db.textColor))
		module.text.count:SetAlpha(db.textAlpha)
		module.text:SetFrameStrata(db.textStrata)
	end
end

function ComboPointsRedux:OpenConfig()
	LoadAddOn("ComboPointsRedux_Options")
	LibStub("AceConfigDialog-3.0"):Open("ComboPointsRedux")
end

function ComboPointsRedux:GetColorByPoints(module, points)
	return unpack(self.db.profile.modules[module].colors[points])
end

local bg = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",}
function ComboPointsRedux:MakeTextFrame(module)
	local f = CreateFrame("FRAME", nil, UIParent)
	local db = self.db.profile.modules[module]
	f:SetBackdrop(bg)
	f:SetFrameStrata(db.textStrata)
	f:SetClampedToScreen(true)
	if db.textPos.x then
		f:SetPoint(db.textPos.point, UIParent, db.textPos.anchor, db.textPos.x, db.textPos.y)
	else
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
	f:SetBackdropColor(1,1,1,0)
	f:SetWidth(50)
	f:SetHeight(50)
	
	f.count = f:CreateFontString(nil,"OVERLAY")
	f.count:SetAllPoints(f)
	f.count:SetShadowColor(0, 0, 0, db.textAlpha)
	f.count:SetShadowOffset(1, -1)
	f.count:SetFont(LSM:Fetch("font", db.font), db.fontsize)
	f.count:SetTextColor(unpack(db.textColor))
	f.count:SetAlpha(db.textAlpha)
	
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(frame) frame:StartMoving() end)
	f:SetScript("OnDragStop", function(frame)
		frame:StopMovingOrSizing()
		local point, _, anchor, x, y = frame:GetPoint()
		db.textPos.x = math.floor(x)
		db.textPos.y = math.floor(y)
		db.textPos.anchor = anchor
		db.textPos.point = point
	end)
	
	if not self.db.profile.locked then
		f:SetBackdropColor(1,1,1,1)
		f:EnableMouse(true)
		f:SetMovable(true)
		f.count:SetText(self.modules[module].abbrev)
	else
		f:EnableMouse(false)
		f:SetMovable(false)
	end
	
	function f:SetNumPoints(points)
		self.count:SetText(points)
	end
	
	if db.disableText then
		f:Hide()
	end
	
	return f
end

function ComboPointsRedux:MakeGraphicsFrame(module, num)
	local g = CreateFrame("FRAME", nil, UIParent)
	local db = self.db.profile.modules[module]
	g:SetBackdrop(bg)
	g:SetFrameStrata(db.strata)
	g:SetClampedToScreen(true)
	if db.graphicsPos.x then
		g:SetPoint(db.graphicsPos.point, UIParent, db.graphicsPos.anchor, db.graphicsPos.x, db.graphicsPos.y)
	else
		g:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
	
	g:SetBackdropColor(1,1,1,0)
	
	if db.orientation == "v" then
		g:SetHeight(145*db.scale)
		g:SetWidth(25*db.scale)
	else
		g:SetWidth(145*db.scale)
		g:SetHeight(25*db.scale)
	end
	
	g:RegisterForDrag("LeftButton")
	g:SetScript("OnDragStart", function(frame) frame:StartMoving() end)
	g:SetScript("OnDragStop", function(frame)
		frame:StopMovingOrSizing()
		local point, _, anchor, x, y = frame:GetPoint()
		db.graphicsPos.x = math.floor(x)
		db.graphicsPos.y = math.floor(y)
		db.graphicsPos.anchor = anchor
		db.graphicsPos.point = point
	end)
	
	g.points = {}
	for i = 1, num do
		g.points[i] = CreateFrame("FRAME", nil, g)
		g.points[i].icon = g.points[i]:CreateTexture(nil, "OVERLAY")
		g.points[i].icon:SetAllPoints(g.points[i])
		g.points[i].icon:SetTexture(basepath..db.icon)
		g.points[i].icon:SetVertexColor(unpack(db.colors[1]))
		g.points[i]:SetAlpha(db.graphicsAlpha)
		g.points[i]:SetHeight(25*db.scale)
		g.points[i]:SetWidth(25*db.scale)
		g.points[i]:Hide()
	end
	
	if not self.db.profile.locked then
		g:SetBackdropColor(1,1,1,1)
		g:EnableMouse(true)
		g:SetMovable(true)
		g.points[1]:Show()
		g.points[2]:Show()
	else
		g:EnableMouse(false)
		g:SetMovable(false)
	end
	
	local offset = db.spacing*db.scale
	if db.orientation == "v" then
		g.points[1]:SetPoint("BOTTOM", g, "BOTTOM", 0, 0)
		for i = 2, num do
			g.points[i]:SetPoint("BOTTOM", g.points[i-1], "TOP", 0, offset)
		end
	else
		g.points[1]:SetPoint("LEFT", g, "LEFT", 0, 0)
		for i = 2, num do
			g.points[i]:SetPoint("LEFT", g.points[i-1], "RIGHT", offset, 0)
		end
	end
	
	if db.disableGraphics then
		g:Hide()
	end
	
	return g
end
