NugComboBar = CreateFrame("Frame","NugComboBar")

NugComboBar.FADE_IN = 0.3;
NugComboBar.FADE_OUT = 0.5;
NugComboBar.HIGHLIGHT_FADE_IN = 0.4;
NugComboBar.SHINE_FADE_IN = 0.3;
NugComboBar.SHINE_FADE_OUT = 0.4;
NugComboBar.FRAME_LAST_NUM_POINTS = 0;

NugComboBar:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

NugComboBar:RegisterEvent("ADDON_LOADED")

function NugComboBar.ADDON_LOADED(self,event,arg1)
    if arg1 == "NugComboBar" then
        if select(2,UnitClass("player")) ~= "ROGUE" and select(2,UnitClass("player")) ~= "DRUID" then return end
        
        NugComboBarDB = NugComboBarDB or {}
        NugComboBarDB.posX = NugComboBarDB.posX or 0
        NugComboBarDB.posY = NugComboBarDB.posY or 0
        NugComboBarDB.scale = NugComboBarDB.scale or 1.0
        NugComboBarDB.skin = NugComboBarDB.skin or "NCB Classic"
        NugComboBarDB.visibility = NugComboBarDB.visibility or "normal"
        NugComboBarDB.colors = NugComboBarDB.colors or { {1,0.2,0.2}, {1,0.2,0.2}, {1,0.2,0.2}, {1,0.2,0.2}, {1,0.2,0.2}, {1,1,1}, }
        
    
        self.combat = 0
        self.showBg = 0
        self.frame = NugComboBar.CreateFrame(NugComboBarSkins[NugComboBarDB.skin])
        self.UpdateBehavior(NugComboBarDB.visibility)
        self:RegisterEvent("UNIT_COMBO_POINTS")
        self:RegisterEvent("PLAYER_TARGET_CHANGED")
        self.MakeOptions()
    end
end

function NugComboBar.SetColor(point, r, g, b)
if point < 6 then
    NugComboBarDB.colors[point] = {r,g,b}
    getglobal("NugComboBarPoint"..point.."Highlight"):SetVertexColor(r,g,b);
else
    NugComboBarDB.colors[6] = {r,g,b}
    getglobal("NugComboBarBackground"):SetVertexColor(r,g,b);
end
end

function NugComboBar.UNIT_COMBO_POINTS(self)
    local comboPoints = GetComboPoints("player");
	local comboPoint, comboPointHighlight, fadeInfo;
    if ( comboPoints > 0 - self.showBg - self.combat) then
		if ( not self.frame:IsVisible() ) then
			self.frame:Show();
			UIFrameFadeIn(self.frame, NugComboBar.FADE_IN);
		end

		for i=1, MAX_COMBO_POINTS do
			comboPointHighlight = getglobal("NugComboBarPoint"..i.."Highlight");
			comboPointShine = getglobal("NugComboBarPoint"..i.."Shine");
			if ( i <= comboPoints ) then
				if ( i > NugComboBar.FRAME_LAST_NUM_POINTS ) then
					fadeInfo = {};
					fadeInfo.mode = "IN";
					fadeInfo.timeToFade = NugComboBar.HIGHLIGHT_FADE_IN;
					fadeInfo.finishedFunc = function(frame) NugComboBar.ShineFadeIn(frame) end;
					fadeInfo.finishedArg1 = comboPointShine;
					UIFrameFade(comboPointHighlight, fadeInfo);
				end
			else
				comboPointHighlight:SetAlpha(0);
				comboPointShine:SetAlpha(0);
			end
		end
	else
		NugComboBarPoint1Highlight:SetAlpha(0);
		NugComboBarPoint1Shine:SetAlpha(0);
		self.frame:Hide();
	end
	NugComboBar.FRAME_LAST_NUM_POINTS = comboPoints;
end

function NugComboBar.PLAYER_TARGET_CHANGED(self)
    self:UNIT_COMBO_POINTS()
end

function NugComboBar.PLAYER_REGEN_ENABLED(self)
    self.combat = 0
--~     self.frame:Hide()
end
function NugComboBar.PLAYER_REGEN_DISABLED(self)
    self.combat = 1
    self.frame:Show()
end

function NugComboBar.UpdateBehavior(state)
    if state == "combat" then
        NugComboBar:RegisterEvent("PLAYER_REGEN_ENABLED")
        NugComboBar:RegisterEvent("PLAYER_REGEN_DISABLED")
    else
        NugComboBar:UnregisterEvent("PLAYER_REGEN_ENABLED")
        NugComboBar:UnregisterEvent("PLAYER_REGEN_DISABLED")
        NugComboBar.combat = 0
    end
    if state == "always" then
        NugComboBar.showBg = 1
        NugComboBar.frame:Show()
    else
        NugComboBar.showBg = 0
    end
end

function NugComboBar.ShineFadeIn(frame)
	local fadeInfo = {};
	fadeInfo.mode = "IN";
	fadeInfo.timeToFade = NugComboBar.SHINE_FADE_IN;
	fadeInfo.finishedFunc = function(frameName) NugComboBar.ShineFadeOut(frameName) end;
	fadeInfo.finishedArg1 = frame:GetName();
	UIFrameFade(frame, fadeInfo);
end

function NugComboBar.ShineFadeOut(frameName)
	UIFrameFadeOut(getglobal(frameName), NugComboBar.SHINE_FADE_OUT);
end

function NugComboBar.MakeOptions(self)
    local showtypes = {
        ["always"]          = "Always show",
        ["combat"]          = "Only in combat",
        ["normal"]          = "Normal",
    }
    local skins = {}
    for k,v in pairs(NugComboBarSkins) do
        skins[k] = v.name
    end
    local opt = {
		type = 'group',
        name = "NugComboBar",
        args = {},
	}
--~     opt.args.display = {
--~         type    = "group",
--~         name    = "Display Settings",
--~         order   = 1,
--~         args    = {},
--~     }
    opt.args.general = {
        type = "group",
        name = "General",
        order = 1,
        args = {
            showPositon = {
                type = "group",
                name = "Position",
                guiInline = true,
                order = 1,
                args = {
                    posX = {
                        name = "Pos X",
                        type = "range",
                        desc = "Horizontal position, relative to center",
                        get = function(info) return NugComboBarDB.posX end,
                        set = function(info, s) NugComboBarDB.posX = s; NugComboBar.frame:SetPoint("CENTER",UIParent,"CENTER",NugComboBarDB.posX,NugComboBarDB.posY); end,
                        min = -900,
                        max = 900,
                        step = 1,
                    },
                    posY = {
                        name = "Pos Y",
                        type = "range",
                        desc = "Vertical position, relative to center",
                        get = function(info) return NugComboBarDB.posY end,
                        set = function(info, s) NugComboBarDB.posY = s; NugComboBar.frame:SetPoint("CENTER",UIParent,"CENTER",NugComboBarDB.posX,NugComboBarDB.posY); end,
                        min = -700,
                        max = 700,
                        step = 1,
                    },
                },
            },
            showGeneral = {
                type = "group",
                name = "General",
                guiInline = true,
                order = 2,
                args = {
                    scale = {
                        name = "Scale",
                        type = "range",
                        desc = "Change scale",
                        get = function(info) return NugComboBarDB.scale end,
                        set = function(info, s) NugComboBarDB.scale = s; NugComboBar.frame:SetScale(NugComboBarDB.scale); end,
                        min = 0.4,
                        max = 2,
                        step = 0.01,
                    },
                    showopts = {
                        type = "select",
                        name = "Show",
                        desc = "When...",
                        values = showtypes,
                        get = function(info)
                            return NugComboBarDB.visibility 
                        end,
                        set = function(info, s)
                            NugComboBarDB.visibility = s
                            NugComboBar.UpdateBehavior(NugComboBarDB.visibility)
                        end,
                    },
                }
            },
            showColor = {
                type = "group",
                name = "Colors",
                guiInline = true,
                order = 3,
                args = {
                    color1 = {
                        name = "1st",
                        type = 'color',
                        desc = "Color of first point",
                        get = function(info)
                            local r,g,b = unpack(NugComboBarDB.colors[1])
                            return r,g,b
                        end,
                        set = function(info, r, g, b)
                            NugComboBar.SetColor(1,r,g,b)
                        end,
                    },
                    color2 = {
                        name = "2nd",
                        type = 'color',
                        desc = "Color of second point",
                        get = function(info)
                            local r,g,b = unpack(NugComboBarDB.colors[2])
                            return r,g,b
                        end,
                        set = function(info, r, g, b)
                            NugComboBar.SetColor(2,r,g,b)
                        end,
                    },
                    color3 = {
                        name = "3rd",
                        type = 'color',
                        desc = "Color of third point",
                        get = function(info)
                            local r,g,b = unpack(NugComboBarDB.colors[3])
                            return r,g,b
                        end,
                        set = function(info, r, g, b)
                            NugComboBar.SetColor(3,r,g,b)
                        end,
                    },
                    color4 = {
                        name = "4th",
                        type = 'color',
                        desc = "Color of fourth point",
                        get = function(info)
                            local r,g,b = unpack(NugComboBarDB.colors[4])
                            return r,g,b
                        end,
                        set = function(info, r, g, b)
                            NugComboBar.SetColor(4,r,g,b)
                        end,
                    },
                    color5 = {
                        name = "5th",
                        type = 'color',
                        desc = "Color of fifth point",
                        get = function(info)
                            local r,g,b = unpack(NugComboBarDB.colors[5])
                            return r,g,b
                        end,
                        set = function(info, r, g, b)
                            NugComboBar.SetColor(5,r,g,b)
                        end,
                    },
                    color = {
                        name = "ALL Points",
                        type = 'color',
                        desc = "Color of all Points",
                        get = function(info)
                            local r,g,b = unpack(NugComboBarDB.colors[1])
                            return r,g,b
                        end,
                        set = function(info, r, g, b)
                            for i=1,5 do
                                NugComboBar.SetColor(i,r,g,b)
                            end
                        end,
                    },
                    colorBG = {
                        name = "Background",
                        type = 'color',
                        desc = "Background color",
                        get = function(info)
                            local r,g,b = unpack(NugComboBarDB.colors[6])
                            return r,g,b
                        end,
                        set = function(info, r, g, b)
                            NugComboBar.SetColor(6,r,g,b)
                        end,
                    },
                },
            },
        },
    }
    opt.args.skin = {
        type = "group",
        name = "Skin",
        order = 2,
        args = {
            skin = {
                order = 1,
                type = "select",
                name = "Skin (requires ReloadUI)",
                desc = "Choose one",
                values = skins,
                get = function(info)
                    return NugComboBarDB.skin
                end,
                set = function(info, s)
                    NugComboBarDB.skin = s
--~                     NugComboBar.frame:Hide()
--~                     NugComboBar.frame = nil
--~                     NugComboBar.frame = NugComboBar.CreateFrame(NugComboBarSkins[NugComboBarDB.skin])
--~                     NugComboBar:UNIT_COMBO_POINTS()
                end,
            },
            reloadui = {
                order = 2,
                type = "execute",
                name = "ReloadUI",
                desc = "Reloads your UI",
                func = function() ReloadUI() end
            },
        },
    }
    
    local Config = LibStub("AceConfigRegistry-3.0")
    local Dialog = LibStub("AceConfigDialog-3.0")
    Config:RegisterOptionsTable("NugComboBar", opt)
    Config:RegisterOptionsTable("NugComboBar-Bliz", {name = "NugComboBar",type = 'group',args = {} })
    Dialog:SetDefaultSize("NugComboBar-Bliz", 600, 400)
    
    Config:RegisterOptionsTable("NugComboBar-General", opt.args.general)
    Dialog:AddToBlizOptions("NugComboBar-General", "NugComboBar")
    
    Config:RegisterOptionsTable("NugComboBar-Skin", opt.args.skin)
    Dialog:AddToBlizOptions("NugComboBar-Skin", opt.args.skin.name, "NugComboBar")
    
    SLASH_NCBSLASH1 = "/ncb";
    SLASH_NCBSLASH2 = "/nugcombobar";
    
--~     SlashCmdList["NCBSLASH"] = function() InterfaceOptionsFrame_OpenToFrame("NugComboBar") end;
    SlashCmdList["NCBSLASH"] = function() LibStub("AceConfigDialog-3.0"):Open("NugComboBar") end;
end

function NugComboBar.CreateFrame(skin)
    local fr = CreateFrame("Frame","NugComboBarFrame",UIParent);
    fr:SetFrameStrata("MEDIUM")
    fr:SetWidth(skin.frame.width)
    fr:SetHeight(skin.frame.height)
    fr:EnableMouse(false)

    ft = fr:CreateTexture("NugComboBarBackground","BACKGROUND")
    ft:SetTexture(skin.background.texture)
    ft:SetWidth(skin.background.width)
    ft:SetHeight(skin.background.height)
    ft:SetPoint("TOPLEFT",fr,"TOPLEFT",skin.background.offsetX,skin.background.offsetY)
--~     ft:SetAllPoints(fr)
    ft:SetVertexColor(unpack(NugComboBarDB.colors[6]))

    for i=1, 5 do
        local f = CreateFrame("Frame","NugComboBarPoint"..i,fr)
        
        f:SetWidth(skin.points[i].width)
        f:SetHeight(skin.points[i].height)
        
        if i == 1 then
            f:SetPoint("TOPLEFT","NugComboBarFrame","TOPLEFT",skin.points[i].offsetX,skin.points[i].offsetY)
        else
            f:SetPoint("CENTER","NugComboBarPoint"..(i-1),"CENTER",skin.points[i].offsetX,skin.points[i].offsetY)
        end
        
        local h = f:CreateTexture("NugComboBarPoint"..i.."Highlight","ARTWORK")
        h:SetTexture(skin.points[i].texture.texture)
        
        h:SetWidth(skin.points[i].texture.width)
        h:SetHeight(skin.points[i].texture.height)
            
        h:SetAlpha(0)
        h:SetPoint("TOPLEFT","NugComboBarPoint"..i,"TOPLEFT",skin.points[i].texture.offsetX,skin.points[i].texture.offsetY)
        h:SetVertexColor(unpack(NugComboBarDB.colors[i]))
        
        local s = f:CreateTexture("NugComboBarPoint"..i.."Shine","OVERLAY")
        s:SetTexture(skin.points[i].highlight.texture)
        
        s:SetWidth(skin.points[i].highlight.width)
        s:SetHeight(skin.points[i].highlight.height)
    
        s:SetAlpha(0)
        s:SetBlendMode("ADD")
        s:SetPoint("TOPLEFT","NugComboBarPoint"..i,"TOPLEFT",skin.points[i].highlight.offsetX,skin.points[i].highlight.offsetY)
    end    
    fr:SetScale(NugComboBarDB.scale)
    fr:SetPoint("CENTER",UIParent,"CENTER",NugComboBarDB.posX,NugComboBarDB.posY)
    fr:Hide()
    return fr
end
