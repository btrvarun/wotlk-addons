--[[
ComboPointsRedux_Options - LoD option module for ComboPointsRedux
Author: Michael Joseph Murray aka Lyte of Lothar(US)
$Revision: 134 $
$Date: 2010-08-09 19:56:46 +0000 (Mon, 09 Aug 2010) $
Project Version: 2.0.0 beta2
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2010 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

local core = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local L = LibStub("AceLocale-3.0"):GetLocale("ComboPointsRedux")
local format = string.format

--upvalue some tables used in the 'select' options
local stratas = {["FULLSCREEN"] = "Fullscreen", ["HIGH"] = "High", ["MEDIUM"] = "Medium", ["LOW"] = "Low", ["BACKGROUND"] = "Background",}
local symbols = {
	square = L["Square"],
	circle = L["Circle"],
	diamond = L["Diamond"],
	["kanji-strength"] = L["Kanji - Strength"],
	["kanji-strength-invert"] = L["Kanji - Strength (Inverted)"],
	["kanji-death"] = L["Kanji - Death"],
	["kanji-death-invert"] = L["Kanji - Death (Inverted)"],
	["kanji-faith"] = L["Kanji - Faith"],
	--["kanji-faith-invert"] = L["Kanji - Faith (Inverted)"],
}
local orientations =  {h = L["Horizontal"], v = L["Vertical"],}

local opts = {
	type = 'group',
	args = {},
}

--generate the Core options
opts.args["core"] = {
	type = "group",
	name = "Core",
	order = 1,
	args = {
		locked = {
			type = "toggle",
			name = L["Lock"],
			desc = L["Lock all the frames in place, preventing movement and hiding the background."],
			descStyle = "inline",
			width = "full",
			order = 1,
			get = function() return core.db.profile.locked end,
			set = function()
				core.db.profile.locked = not core.db.profile.locked
				for name, module in core:IterateModules() do
					if module:IsEnabled() then
						if not core.db.profile.locked then
							module.graphics:SetBackdropColor(1,1,1,1)
							module.graphics:EnableMouse(true)
							module.graphics:SetMovable(true)
							module.graphics.points[1]:Show()
							module.graphics.points[2]:Show()
							
							module.text:SetBackdropColor(1,1,1,1)
							module.text:EnableMouse(true)
							module.text:SetMovable(true)
							module.text.count:SetText(module.abbrev)
						else
							module.graphics:EnableMouse(false)
							module.graphics:SetMovable(false)
							module.graphics:SetBackdropColor(1,1,1,0)
							module.graphics.points[1]:Hide()
							module.graphics.points[2]:Hide()
							
							module.text:EnableMouse(false)
							module.text:SetMovable(false)
							module.text:SetBackdropColor(1,1,1,0)
							module.text.count:SetText("")
						end
					end
				end
			end,
		},
	},
}

--generate the enable/disable options per module
for name, module in core:IterateModules() do
	opts.args.core.args[name.."toggle"] = {
		type = "toggle",
		name = format(L["%s Module enabled"], module.displayName),
		desc = format(L["Select whether or not the %s module is enabled."], module.displayName),
		descStyle = "inline",
		width = "full",
		order = 2,
		get = function()
			return core.db.profile.modules[name].enabled
		end,
		set = function(info, value)
			core.db.profile.modules[name].enabled = value
			if value then
				module:Enable()
			else
				module:Disable()
			end
		end,
	}
end

--generate options for each registered module
local handlers = {}
local i = 2
for name, module in core:IterateModules() do
	handlers[name] = {
		Get = function(self, info, ...)
			if info.type == "color" then
				if info.arg == "textColor" then
					return unpack(core.db.profile.modules[name][info.arg])
				else
					return unpack(core.db.profile.modules[name].colors[info.arg])
				end
			else
				return core.db.profile.modules[name][info.arg]
			end
		end,
		Set = function(self, info, ...)
			if info.type == "color" then
				if info.arg == "textColor" then
					local color = core.db.profile.modules[name][info.arg]
					color[1], color[2], color[3] = ...
				else
					local color = core.db.profile.modules[name].colors[info.arg]
					color[1], color[2], color[3] = ...
				end
			else
				core.db.profile.modules[name][info.arg] = ...
			end
			core:UpdateSettings(name)
		end,
	}
	
	opts.args[name] = {
		type = "group",
		name = module.displayName,
		handler = handlers[name],
		disabled = function() return not core.db.profile.modules[name].enabled end,
		order = i,
		args = {
			disablegraphics = {
				type = "toggle",
				name = L["Disable Graphics"],
				desc = L["Select whether or not to show this module's graphics."],
				descStyle = "inline",
				width = "full",
				arg = "disableGraphics",
				get = "Get",
				set = function(info, value)
					core.db.profile.modules[name].disableGraphics = value
					if value then
						module.graphics:Hide()
					else
						module.graphics:Show()
					end
				end,
				order = 1,
			},
			disabletext = {
				type = "toggle",
				name = L["Disable Text"],
				desc = L["Select whether or not to show this module's text counter."],
				descStyle = "inline",
				width = "full",
				arg = "disableText",
				get = "Get",
				set = function(info, value)
					core.db.profile.modules[name].disableText = value
					if value then
						module.text:Hide()
					else
						module.text:Show()
					end
				end,
				order = 2,
			},
			graphics = {
				type = "group",
				name = L["%s Graphics"]:format(module.displayName),
				inline = true,
				order = 3,
				disabled = function() return core.db.profile.modules[name].disableGraphics end,
				args = {
					oneColor = {
						type = 'color',
						name = format(L["%d |4Point:Points;"], 1),
						desc = format(L["Set the color to be used when you have %d |4point:points;."], 1),
						arg = 1,
						get = "Get",
						set = "Set",
						order = 1,
					},
					icon = {
						type = "select",
						name = L["Icon"],
						desc = L["Select the icon to be used for these graphics."],
						arg = "icon",
						get = "Get",
						set = "Set",
						values = symbols,
						order = 106,
					},
					orientation = {
						type = "select",
						name = L["Orientation"],
						desc = L["Select the orientation of the graphical display (horizontal or vertical)."],
						arg = "orientation",
						get = "Get",
						set = "Set",
						values = orientations,
						order = 107,
					},
					strata = {
						type = 'select',
						name = L["Graphics Strata"],
						desc = L["Set the strata level of the graphics frame."],
						get = "Get",
						set = "Set",
						arg = "strata",
						values = stratas,
						order = 108,
					},
					alpha = {
						type = 'range',
						name = L["Icon Alpha"],
						desc = L["Set the alpha of the icons."],
						arg = "graphicsAlpha",
						get = "Get",
						set = "Set",
						min = 0.0,
						max = 1.0,
						step = 0.01,
						order = 109,
					},
					scale = {
						type = 'range',
						name = L["Scale"],
						desc = L["Set the scale of the icons."],
						arg = "scale",
						get = "Get",
						set = "Set",
						min = 0.1,
						max = 3.5,
						step = 0.01,
						order = 110,
					},
					spacing = {
						type = 'range',
						name = L["Icon Spacing"],
						desc = L["Set the spacing between the icons."],
						arg = "spacing",
						get = "Get",
						set = "Set",
						min = -2,
						max = 10,
						step = 1,
						order = 111,
					},
				},
			},
			text = {
				type = "group",
				name = L["%s Text"]:format(module.displayName),
				inline = true,
				order = 4,
				disabled = function() return core.db.profile.modules[name].disableText end,
				args = {
					font = {
						type = 'select',
						name = L["Font"],
						desc = L["Select the font for the text display."],
						arg = "font",
						get = "Get",
						set = "Set",
						dialogControl = "LSM30_Font",
						values = AceGUIWidgetLSMlists.font,
						order = 1,
					},
					fontsize = {
						type = 'range',
						name = L["Font Size"],
						desc = L["Set the font size for the text display."],
						arg = "fontsize",
						get = "Get",
						set = "Set",
						min = 1,
						max = 36,
						step = 1,
						order = 2,
					},
					textcolor = {
						type = 'color',
						name = L["Text Color"],
						desc = L["Set the color for the text display."],
						arg = "textColor",
						get = "Get",
						set = "Set",
						order = 3,
					},
					textalpha = {
						type = 'range',
						name = L["Text Alpha"],
						desc = L["Set the alpha of the text display."],
						arg = "textAlpha",
						get = "Get",
						set = "Set",
						min = 0.0,
						max = 1.0,
						step = 0.01,
						order = 4,
					},
					textstrata = {
						type = 'select',
						name = L["Text Strata"],
						desc = L["Set the strata level of the text frame."],
						get = "Get",
						set = "Set",
						arg = "textStrata",
						values = stratas,
						order = 5,
					},
				},
			},
		},
	}
	
	for j = 2, module.MAX_POINTS do
		opts.args[name].args.graphics.args["color"..j] = {
			type = 'color',
			name = format(L["%d |4Point:Points;"], j),
			desc = format(L["Set the color to be used when you have %d |4point:points;."], j),
			arg = j,
			get = "Get",
			set = "Set",
			order = j,
		}
	end
	
	i = i + 1
end

--add profile controls
opts.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(core.db)

LibStub("AceConfig-3.0"):RegisterOptionsTable("ComboPointsRedux", opts)
LibStub("AceConfigDialog-3.0"):SetDefaultSize("ComboPointsRedux", 800, 500)
