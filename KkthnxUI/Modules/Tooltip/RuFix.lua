﻿local K, C, L, _ = select(2, ...):unpack()
if C.Tooltip.Enable ~= true then return end

-- Clean ruRU tooltip(snt_rufix by Don Kaban, edited by ALZA)
if K.Client ~= "ruRU" then return end

GUILD_ACHIEVEMENT = "Уведомл. для гильдии"

local ttext
local replace = {
	["красного цвета"] = "|cffFF4040красного цвета|r",
	["синего цвета"] = "|cff6060ffсинего цвета|r",
	["желтого цвета"] = "|cffffff40желтого цвета|r",
	["Требуется хотя бы"] = "Требуется",
}

local replaceclass = {
	["Воин"] = "|cffC79C6EВоин|r",
	["Друид"] = "|cffFF7D0AДруид|r",
	["Жрец"] = "|cffFFFFFFЖрец|r",
	["Маг"] = "|cff2eb6ffМаг|r",
	["Монах"] = "|cff00FF96Монах|r",
	["Охотник"] = "|cffABD473Охотник|r",
	["Паладин"] = "|cffF58CBAПаладин|r",
	["Разбойник"] = "|cffFFF569Разбойник|r",
	["Рыцарь смерти"] = "|cffC41F3BРыцарь смерти|r",
	["Чернокнижник"] = "|cff9482C9Чернокнижник|r",
	["Шаман"] = "|cff0070DEШаман|r",
}

local function Translate(text)
	if text then
		for rus, replace in next, replace do
			text = text:gsub(rus, replace)
		end
		return text
	end
end

local function TranslateClass(text)
	if text then
		for rus, replaceclass in next, replaceclass do
			text = text:gsub(rus, replaceclass)
		end
		return text
	end
end

local function UpdateTooltip(self)
	if not self:GetItem() then return end
	local tname = self:GetName()
	for i = 3, self:NumLines() do
		ttext = _G[tname.."TextLeft"..i]
		local class = ttext:GetText() and (string.find(ttext:GetText(), "Класс") or string.find(ttext:GetText(), "Требуется"))
		if ttext then ttext:SetText(Translate(ttext:GetText())) end
		if ttext and class then ttext:SetText(TranslateClass(ttext:GetText())) end
		ttext = _G[tname.."TextRight"..i]
		if ttext then ttext:SetText(Translate(ttext:GetText())) end
	end
	ttext = nil
end

GameTooltip:HookScript("OnTooltipSetItem", UpdateTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", UpdateTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", UpdateTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", UpdateTooltip)