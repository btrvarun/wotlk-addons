local K, C, L, _ = select(2, ...):unpack()
if C.ActionBar.Enable ~= true then return end

local _G = _G
local CreateFrame = CreateFrame

--	Setup MultiBarBottomRight as bar #5 by Tukz
local bar = CreateFrame("Frame", "Bar5Holder", UIParent)
if C.ActionBar.RightBars < 3 then
	if C.ActionBar.SplitBars == true then
		bar:SetAllPoints(SplitBarLeft)
	else
		bar:SetAllPoints(ActionBarAnchor)
	end
else
	bar:SetAllPoints(RightActionBarAnchor)
end
MultiBarBottomRight:SetParent(bar)

for i = 1, 12 do
	local b = _G["MultiBarBottomRightButton"..i]
	local b2 = _G["MultiBarBottomRightButton"..i-1]
	b:ClearAllPoints()
	if C.ActionBar.SplitBars == true and C.ActionBar.RightBars < 3 then
		if i == 1 then
			b:SetPoint("TOPLEFT", SplitBarLeft, "TOPLEFT", 0, 0)
		elseif i == 4 then
			b:SetPoint("BOTTOMLEFT", SplitBarLeft, "BOTTOMLEFT", 0, 0)
		elseif i == 7 then
			b:SetPoint("TOPLEFT", SplitBarRight, "TOPLEFT", 0, 0)
		elseif i == 10 then
			b:SetPoint("BOTTOMLEFT", SplitBarRight, "BOTTOMLEFT", 0, 0)
		else
			b:SetPoint("LEFT", b2, "RIGHT", C.ActionBar.ButtonSpace, 0)
		end
	else
		if i == 1 then
			if C.ActionBar.RightBars < 3 then
				b:SetPoint("TOPLEFT", Bar1Holder, 0, 0)
			else
				b:SetPoint("TOPLEFT", RightActionBarAnchor, "TOPLEFT", 0, 0)
			end
		else
			if C.ActionBar.RightBars < 3 then
				b:SetPoint("LEFT", b2, "RIGHT", C.ActionBar.ButtonSpace, 0)
			else
				b:SetPoint("TOP", b2, "BOTTOM", 0, -C.ActionBar.ButtonSpace)
			end
		end
	end
end

-- Hide bar
if C.ActionBar.RightBars < 3 and C.ActionBar.BottomBars < 3 then
	bar:Hide()
end