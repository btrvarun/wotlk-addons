local K, C, L, _ = select(2, ...):unpack()
if not IsAddOnLoaded("CLCRet") or C.Skins.CLCRet ~= true or K.Class ~= "PALADIN" then return end

-- CLCRet skin(by Elv22)
if not LibStub then return end
local clcret = LibStub("AceAddon-3.0"):GetAddon("clcret")

function clcret:CreateButton(name, size, point, parent, pointParent, offsetx, offsety, bfGroup, isChecked)
	local db = self.db.profile
	clcretFrame:SetScale(1)
	clcretFrame.SetScale = K.Noop

	name = "clcret"..name
	local button
	if isChecked then
		button = CreateFrame("CheckButton", name, parent)
		button:CreateBackdrop(2)
	else
		button = CreateFrame("Button", name, parent)
		button:CreateBackdrop(2)
	end
	button:EnableMouse(false)
	button:SetSize(size, size)

	button.texture = button:CreateTexture("$parentIcon", "OVERLAY")
	button.texture:SetPoint("TOPLEFT", 2, -2)
	button.texture:SetPoint("BOTTOMRIGHT", -2, 2)
	button.texture:SetTexture(BGTEX)
	button.texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.texture.SetTexCoord = K.Noop

	button.border = button:CreateTexture(nil, "BORDER")
	button.border:Kill()

	button.cooldown = CreateFrame("Cooldown", "$parentCooldown", button, "CooldownFrameTemplate")
	button.cooldown:SetPoint("TOPLEFT", 2, -2)
	button.cooldown:SetPoint("BOTTOMRIGHT", -2, 2)

	button.stack = button:CreateFontString("$parentCount", "OVERLAY", "TextStatusBarText")

	local fontFace, _, fontFlags = button.stack:GetFont()
	button.stack:SetFont(fontFace, 30, fontFlags)
	button.stack:SetJustifyH("RIGHT")
	button.stack:ClearAllPoints()
	button.stack:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, 0)

	button.defaultSize = button:GetWidth()

	button.SetScale = K.Noop
	button:ClearAllPoints()
	button:SetPoint(point, parent, pointParent, offsetx, offsety)

	if self.LBF then
		self.LBF:Group("clcret", bfGroup):AddButton(button)
	end

	button:Hide()
	return button
end

function clcret:UpdateButtonLayout(button, opt)
	button:SetSize(opt.size, opt.size)
	button:ClearAllPoints()
	button:SetPoint(opt.point, clcretFrame, opt.pointParent, opt.x, opt.y)
	button:SetAlpha(opt.alpha)

	button.stack:ClearAllPoints()
	button.stack:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, 0)
end