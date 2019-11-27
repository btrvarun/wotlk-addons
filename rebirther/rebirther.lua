-- TODO: Better commenting
-- TODO: Clean this messy fucking code up



-- Bunch of vars describing the addon
local AddonName = "Rebirther"
local AddonVersion = "Beta-100802"
local AddonDBName = AddonName.."DB"
local AddonDesc = "Tracks Rebirth and Innervate cooldowns"
local AddonSlash = {"rebirther", "rbr"}
local AddonCommPrefix = "Rebirther-0.0.2"
local Window = {}
local Debug = false	
local RosterUpdate = false	
local MustUpdateNames = false

--local RosterLastUpdate = 0
--local RosterUpdateInterval = 1
local LastUpdate = 0
local UpdateInterval = 1

local testmode = false
local ClassColour = {}
local druid = {}
local sortedlist = {}
--local olddruid = {}
--local AddonEvents = {"UNIT_SPELLCAST_SENT", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PARTY_MEMBERS_CHANGED", "COMBAT_LOG_EVENT_UNFILTERED", "RAID_ROSTER_UPDATE", "PLAYER_ENTERING_BATTLEGROUND", "PLAYER_ENTERING_WORLD"}	-- What events we want to check for, some of these might not be necessary e.g. player_entering_world, player_enter_battleground. Don't know if they both will fire at the same time
Rebirther = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0", "AceHook-3.0")
local SM = LibStub:GetLibrary("LibSharedMedia-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Rebirther", true)

-- Our neat spells
local SpellTemplate = {
	innervate = {
		name = L["Innervate"],
		enname = "Innervate", -- Do not localize!
		cooldown = 179,
		time = "Ready",
	},
	rebirth = {
		name = L["Rebirth"],
		enname = "Rebirth", -- Do not localize!
		cooldown = 599,
		time = "Ready",
	}
}




--[===[@debug@
-- put debugging stuff in here
--Debug = true
--SpellTemplate.innervate.name = "Lifebloom"
--SpellTemplate.innervate.cooldown = 10
--SpellTemplate.rebirth.name = "Lifebloom"
--@end-debug@]===]



-- Random functions

function size(array)	-- Return the number of elements in a table
	local x = 0;
	for _,val in pairs(array) do
		x = x + 1;
	end
	return x
end
function NoDruids()	-- Number of druids
	local x = 0;
	for _,val in pairs(druid) do
		if ( val.show ) then
			x = x + 1;
		end
	end
	return x
end

function Rebirther:SetColour(dest, r, g, b, a)
	dest.r = r
	dest.g = g
	dest.b = b
	dest.a = a
	return dest
end

function Rebirther:GetColour(dest)
	return dest.r, dest.g, dest.b, dest.a
end

function Rebirther:Round(number)
	if ( number % 1 >= 0.5 ) then
		return math.ceil(number)
	else
		return math.floor(number)
	end
end

function Rebirther:FloatToHex(number)
	hex = string.format("%x", self:Round(number * 255))
	if ( number <= 0.06 ) then
		hex = "0"..hex
	end
	return hex
end

function Rebirther:Cout(message)	-- Just puts a message in the default chat frame (if set to)
	if ( self.db.profile.verbose and self:IsEnabled() ) then
		self:Print(message)
	end
end

function Rebirther:InnervateOut(message)	-- Just puts a message in the default chat frame (if set to)
	if ( self.db.profile.verbose and self:IsEnabled() ) then
		DEFAULT_CHAT_FRAME:AddMessage("|cff".."1db1f9"..L["Innervate"].."|r: "..message)
	end
end

function Rebirther:RebirthOut(message)	-- Just puts a message in the default chat frame (if set to)
	if ( self.db.profile.verbose and self:IsEnabled() ) then
		DEFAULT_CHAT_FRAME:AddMessage("|cff".."fc051a"..L["Rebirth"].."|r: "..message)
	end
end

function Rebirther:Debug(message)	-- Puts out debugging messages if Debug == true
	if ( Debug and self:IsEnabled() ) then
		DEFAULT_CHAT_FRAME:AddMessage("|cffef3131Debug|r: "..message)
	end
end

function Rebirther:SetDebug(orly)
	Debug = orly
end

function Rebirther:ColourByClass(name)
	if ( name ) then
		local class = UnitClass(name)
		if ( class and ClassColour[class] ) then
			self:Debug("ColourByClass: Name = "..name.." / Class = "..UnitClass(name))
			return "|cff"..ClassColour[class]..self:GetProperName(name).."|r"
		else
			self:Debug("Class not found")
			return self:GetProperName(name)
		end
	end
end

function Rebirther:GetProperName(name)
	if ( testmode ) then
		if ( string.find(name, "-") and not self.db.profile.showServerName ) then
			return string.sub(name, 1, string.find(name, "-")-1)
		else
			return name
		end
	end
	unitname,server = UnitName(name)
	if ( unitname ) then
		if ( server and server ~= "" and self.db.profile.showServerName ) then
			return unitname.."-"..server
		else
			return unitname
		end
	else
		return name
	end
end

function Rebirther:GetFullName(name)
	unitname,server = UnitName(name)
	if ( server and server ~= "" and self.db.profile.showServerName ) then
		return unitname.."-"..server
	else
		return unitname
	end
end

function Rebirther:GetLocalizedClassesWithColours()
	local classes, males, females = {}, {}, {}
	FillLocalizedClassList(males, false)
	FillLocalizedClassList(females, true)
	for id,classname in pairs(males) do
		local colour = RAID_CLASS_COLORS[id]
		classes[classname] = self:FloatToHex(colour.r)..self:FloatToHex(colour.g)..self:FloatToHex(colour.b)
	end
	for id,classname in pairs(females) do
		local colour = RAID_CLASS_COLORS[id]
		classes[classname] = self:FloatToHex(colour.r)..self:FloatToHex(colour.g)..self:FloatToHex(colour.b)
	end
	for class,colour in pairs(classes) do
	end
	return classes
end

















-- Druid related functions

function Rebirther:AddDruid(name)	-- Add a druid to the global (not really global) table
	--[[
	if ( olddruid[name] ) then
		druid[name] = olddruid[name]
		olddruid[name] = nil
		druid[name].innervate.bar:Show()	
		druid[name].rebirth.bar:Show()	
]]		
	if ( not druid[name] ) then	-- Only fire if that druid doesn't exist (duplicates are extremely bad)
		table.insert(sortedlist, name)
		self:Debug("Adding Druid: "..name)
		druid[name] = {}
		druid[name].timeofdeath = 0
		druid[name].name = name
		druid[name].alive = true
		druid[name].show = true
		druid[name].innervate = {	-- Seems to bug out like shit if you set this to SpellTemplate.innervate ?
			name = SpellTemplate.innervate.name,	-- These static vars seem to be fine though
			enname = SpellTemplate.innervate.enname,
			cooldown = SpellTemplate.innervate.cooldown,
			time = "Ready",
			target = "Unknown",
			bar = self:CreateBar(name, Window.innervates, SpellTemplate.innervate),
		}
		druid[name].rebirth = {
			name = SpellTemplate.rebirth.name,
			enname = SpellTemplate.rebirth.enname,
			cooldown = SpellTemplate.rebirth.cooldown,
			time = "Ready",
			target = "Unknown",
			bar = self:CreateBar(name, Window.rebirths, SpellTemplate.rebirth),
		}
	else	-- If the druid already exists just show the bars again
		self:Debug("Adding Druid: "..name.." (already exists: showing bars)")
		if ( not druid[name].show ) then
			table.insert(sortedlist, name)
		end
		druid[name].show = true
		druid[name].innervate.bar:Show()	
		druid[name].rebirth.bar:Show()		
	end
	MustUpdateNames = true
	return druid[name]	-- Do not know if all these returns are even necessary (probably not)
end
function Rebirther:RemoveDruid(name)	-- Remove that druid! This has the set back of deleting his cooldowns. Need a better way of doing this
	if ( druid[name] --[[ and not (UnitInBattleground(val.name) or UnitInRaid(val.name) or UnitInParty(val.name) or UnitName("player") == val.name) ]] ) then
		for key,val in pairs(sortedlist) do
			if ( val == name ) then
				table.remove(sortedlist, key)
			end
		end
		--olddruid[name] = druid[name]
		self:Debug("Removing: "..druid[name].name)
		druid[name].innervate.bar:Hide()	-- Can't delete frames I'm afraid, only hide them
		druid[name].rebirth.bar:Hide()
		--druid[name] = nil;
		druid[name].show = false
	else
		self:Debug("Failed removing: "..name)
	end
end
function Rebirther:SetDruidAlive(name, isAlive, isOffline)	-- Changes the colours of that druid's bars
	if ( druid[name] ) then
		druid[name].alive = isAlive
		if ( isAlive ) then
			self:Debug("Setting druid alive: "..name)
			-- Now find the appropriate colours for each bar (very crude)
			if ( druid[name].innervate.time == "Ready" ) then
				_G[druid[name].innervate.bar:GetName().."Time"]:SetText(L["Ready"])
				self:Debug("Using ready colour on innervate bar")
				-- I thought I had a function for retreiving colours more easily. Does it work?
				local r, g, b, a = self.db.profile.bar.readyColour.r, self.db.profile.bar.readyColour.g, self.db.profile.bar.readyColour.b, self.db.profile.bar.opacity
				_G[druid[name].innervate.bar:GetName().."Texture"]:SetVertexColor( r, g, b, a )
			else
				self:Debug("Using cooldown colour on innervate bar")
				local r, g, b, a = self.db.profile.bar.cooldownColour.r, self.db.profile.bar.cooldownColour.g, self.db.profile.bar.cooldownColour.b, self.db.profile.bar.opacity
				_G[druid[name].innervate.bar:GetName().."Texture"]:SetVertexColor( r, g, b, a )
			end
			if ( druid[name].rebirth.time == "Ready" ) then
				_G[druid[name].rebirth.bar:GetName().."Time"]:SetText(L["Ready"])
				self:Debug("Using ready colour on rebirth bar")
				local r, g, b, a = self.db.profile.bar.readyColour.r, self.db.profile.bar.readyColour.g, self.db.profile.bar.readyColour.b, self.db.profile.bar.opacity
				_G[druid[name].rebirth.bar:GetName().."Texture"]:SetVertexColor( r, g, b, a )
			else
				self:Debug("Using cooldown colour on rebirth bar")
				local r, g, b, a = self.db.profile.bar.cooldownColour.r, self.db.profile.bar.cooldownColour.g, self.db.profile.bar.cooldownColour.b, self.db.profile.bar.opacity
				_G[druid[name].rebirth.bar:GetName().."Texture"]:SetVertexColor( r, g, b, a )
			end
		else	
			druid[name].timeofdeath = time()
			self:Debug("Setting druid dead: "..name)
			local r, g, b, a = self.db.profile.bar.deadColour.r, self.db.profile.bar.deadColour.g, self.db.profile.bar.deadColour.b, self.db.profile.bar.opacity
			_G[druid[name].innervate.bar:GetName().."Texture"]:SetVertexColor( r, g, b, a )
			_G[druid[name].rebirth.bar:GetName().."Texture"]:SetVertexColor( r, g, b, a )
			if ( druid[name].innervate.time == "Ready" ) then
				if ( isOffline ) then
					_G[druid[name].innervate.bar:GetName().."Time"]:SetText(L["Offline"])
				else
					_G[druid[name].innervate.bar:GetName().."Time"]:SetText(L["Dead"])
				end
			end
			if ( druid[name].rebirth.time == "Ready" ) then
				if ( isOffline ) then
					_G[druid[name].rebirth.bar:GetName().."Time"]:SetText(L["Offline"])
				else
					_G[druid[name].rebirth.bar:GetName().."Time"]:SetText(L["Dead"])
				end
			end
		end
	end
end
function Rebirther:TestMode()
	testmode = not testmode
	if ( testmode ) then
		self:Show(MasterWindow, true)
		self:AddDruid("Venkman-New York")
		self:AddDruid("Stantz-New York")
		self:AddDruid("Spengler-New York")
		--self:StartCooldown(druid["Venkman-New York"].innervate, nil, "Venkman-New York", "Barret-New York")
		self:StartCooldown(druid["Stantz-New York"].rebirth, nil, "Stantz-New York", "Zuul-Ghost Realm")
		self:StartCooldown(druid["Stantz-New York"].innervate, nil, "Stantz-New York", "Peck-New York")
		self:StartCooldown(druid["Spengler-New York"].rebirth, 450, "Spengler-New York", UnitName("player"))
		self:SetDruidAlive("Spengler-New York", false)
		--[[
		local x = 0
		local height = self.db.profile.bar.height + self.db.profile.bar.spacing
		for key,val in pairs(druid) do
			if ( val.show ) then
				self:Debug("Updating bars for: "..val.name)
				self:UpdateBar(val, val.innervate, x * height )		
				self:UpdateBar(val, val.rebirth, x * height )	
				x = x + 1
			end
		end
		]]
		self:UpdateBars()
		self:SetNames()
	else
		self:CheckGroupStatus()
	end
end







-- Window relates functions

function Rebirther:CreateWindow(name, icon)
	self:Debug("Creating window: "..name)
	local padding = self:GetPadding()
	window = CreateFrame("FRAME", name, MasterWindow, "ContainerTemplate")
	_G[name.."Icon"]:SetTexture(icon)
	_G[name.."Title"]:SetFontObject(titleFont)
	_G[name.."Title"]:SetText(name)
	_G[name.."Title"]:SetPoint("TOPLEFT", window, "TOPLEFT", padding, 0);
	window:SetWidth(self.db.profile.bar.width)
	--window:EnableMouseWheel(true)
	return window
end

function Rebirther:MakeFont(name, size, r, g, b, a)	-- Like the name says. Need different fonts for text of different size to avoid graphical corruption of it
	file = self.db.profile.font.filePath
	tempFont = CreateFont(name)
	tempFont:SetFont(file, size)
	tempFont:SetTextColor(r, g, b, a)
	return tempFont
end

function Rebirther:SetFonts()
	nameFont = self:MakeFont("nameFont", self.db.profile.font.nameSize, self.db.profile.font.nameColour.r, self.db.profile.font.nameColour.g, self.db.profile.font.nameColour.b, 1)
	timeFont = self:MakeFont("timeFont", self.db.profile.font.timeSize, self.db.profile.font.timeColour.r, self.db.profile.font.timeColour.g, self.db.profile.font.timeColour.b, 1)
	targetFont = self:MakeFont("targetFont", self.db.profile.font.targetSize, self.db.profile.font.targetColour.r, self.db.profile.font.targetColour.g, self.db.profile.font.targetColour.b, 1)
	titleFont = self:MakeFont("titleFont", self.db.profile.font.titleSize, self.db.profile.font.titleColour.r, self.db.profile.font.titleColour.g, self.db.profile.font.titleColour.b, 1)
end

function Rebirther:SetScale()
	MasterWindow:SetScale(self.db.profile.scale)
end

function Rebirther:SetSize()
	local width, height = self.db.profile.bar.width, (self.db.profile.bar.height + self.db.profile.bar.spacing)
	local padding = self:GetPadding()
	for _,window in pairs({MasterWindow:GetChildren()}) do
		window:SetWidth(width)
		local p, r, rp = _G[window:GetName().."Title"]:GetPoint()
		_G[window:GetName().."Title"]:SetPoint(p, r, rp, padding, -padding)
		window:SetHeight( self.db.profile.font.titleSize + padding * 2)
		for key,val in pairs({window:GetChildren()}) do
			val:SetSize(width,height)
			_G[val:GetName().."TextureAnimation"].max = width
			_G[val:GetName().."TextureCasting"].max = width
			_G[val:GetName().."Texture"]:SetSize(width,height-Rebirther.db.profile.bar.spacing)
			_G[val:GetName().."Background"]:SetSize(width,height)
			--[[
			local p, r, rp = _G[val:GetName().."Name"]:GetPoint()
			_G[val:GetName().."Name"]:SetPoint(p, r, rp, padding, padding)
			p, r, rp = _G[val:GetName().."Time"]:GetPoint()
			_G[val:GetName().."Time"]:SetPoint(p, r, rp, -padding, padding)
			]]			
			local p, r, rp = _G[val:GetName().."Name"]:GetPoint(1)
			_G[val:GetName().."Name"]:SetPoint(p, r, rp, padding, padding)
			local p, r, rp = _G[val:GetName().."Name"]:GetPoint(2)
			_G[val:GetName().."Name"]:SetPoint(p, r, rp, padding, padding)
			local p, r, rp = _G[val:GetName().."Time"]:GetPoint(1)
			_G[val:GetName().."Time"]:SetPoint(p, r, rp, -padding, padding)
			local p, r, rp = _G[val:GetName().."Time"]:GetPoint(2)
			_G[val:GetName().."Time"]:SetPoint(p, r, rp, -padding, padding)
			_G[val:GetName().."Name"]:SetHeight(self.db.profile.font.nameSize)
			
			_G[val:GetName().."Name"]:SetWidth(0)
			_G[val:GetName().."Name"]:SetWidth(math.min(_G[val:GetName().."Name"]:GetWidth(), val:GetWidth() - _G[val:GetName().."Time"]:GetWidth() - self:GetPadding()*2))
		end
	end
	--[[
	local x = 0
	local height = self.db.profile.bar.height + self.db.profile.bar.spacing
	for key,val in pairs(druid) do
		if ( val.show ) then
			self:Debug("Updating bars for: "..val.name)
			self:UpdateBar(val, val.innervate, x * height )		
			self:UpdateBar(val, val.rebirth, x * height )	
			x = x + 1
		end
	end
	]]
	self:UpdateBars()
end

function Rebirther:SetColours()	
	for key,val in pairs(druid) do
		self:SetDruidAlive(val.name, val.alive)
	end
end

function Rebirther:SetBackground()
	local r, g, b, a = self.db.profile.backgroundColour.r, self.db.profile.backgroundColour.g, self.db.profile.backgroundColour.b, self.db.profile.backgroundColour.a
	for _,window in pairs({MasterWindow:GetChildren()}) do
		_G[window:GetName().."Background"]:SetTexture( r, g, b, a)
		for _,bar in pairs({window:GetChildren()}) do
			bg = _G[bar:GetName().."Background"]
			bg:SetTexture( r, g, b , a )
			tex = _G[bar:GetName().."Texture"]
			tex:SetTexture( self.db.profile.bar.texturePath )
			tex:SetAlpha( self.db.profile.bar.opacity )
		end
	end
end

function Rebirther:SetNames()
	for key,val in pairs({MasterWindow:GetChildren()}) do
		for _,bar in pairs({val:GetChildren()}) do
			local name = string.sub(bar:GetName(), 1, string.find(bar:GetName(), "_")-1)
			_G[bar:GetName().."Name"]:SetText(self:GetProperName(name))
			_G[bar:GetName().."Name"]:SetWidth(0)
			_G[bar:GetName().."Name"]:SetWidth(math.min(_G[bar:GetName().."Name"]:GetWidth(), bar:GetWidth() - _G[bar:GetName().."Time"]:GetWidth() - self:GetPadding()*2))
			if ( druid[name] ) then
				if ( string.find(bar:GetName(), "SpellIs"..SpellTemplate.innervate.enname) ) then	
					_G[bar:GetName().."Target"]:SetText(" ("..self:GetProperName(druid[name].innervate.target)..")")
				elseif ( string.find(bar:GetName(), "SpellIs"..SpellTemplate.rebirth.name) ) then
					_G[bar:GetName().."Target"]:SetText(" ("..self:GetProperName(druid[name].rebirth.target)..")")
				end
			end
		end
	end
end

function Rebirther:SetIcons()
	if ( self.db.profile.showicon ) then
		for key,val in pairs({MasterWindow:GetChildren()}) do
			_G[val:GetName().."Icon"]:Show()
		end
	else	
		for key,val in pairs({MasterWindow:GetChildren()}) do
			_G[val:GetName().."Icon"]:Hide()
		end
	end
end

function Rebirther:GetPadding()
	if ( self.db.profile.showtarget ) then
		return ( self.db.profile.bar.height - math.max( self.db.profile.font.nameSize, self.db.profile.font.timeSize, self.db.profile.font.targetSize ) ) / 2
	else		
		return ( self.db.profile.bar.height - math.max( self.db.profile.font.nameSize, self.db.profile.font.timeSize ) ) / 2
	end
end

function Rebirther:ShowTarget(value)
	for _,window in pairs({MasterWindow:GetChildren()}) do
		for _, bar in pairs({window:GetChildren()}) do
			if ( value and _G[bar:GetName().."TextureAnimation"]:IsPlaying() and _G[bar:GetName().."Target"]:GetText() ~= " (Unknown)" ) then
				_G[bar:GetName().."Target"]:Show()
			else				
				_G[bar:GetName().."Target"]:Hide()
			end
		end
	end
end

function Rebirther:Show(frame, show)	-- Shows/hides a frame if show is true/false
	if ( show ) then
		frame:Show()
	else
		frame:Hide()
	end
end
function Rebirther:UpdateBars()	
	for _,name in pairs(sortedlist) do
		if ( self.db.profile.bar.growUp ) then
			druid[name].innervate.bar:ClearAllPoints()
			druid[name].innervate.bar:SetPoint("BOTTOMLEFT", Window.innervates, "TOPLEFT")
			_G[druid[name].innervate.bar:GetName().."Texture"]:ClearAllPoints()
			_G[druid[name].innervate.bar:GetName().."Texture"]:SetPoint("TOPLEFT", druid[name].innervate.bar, "TOPLEFT")
			druid[name].rebirth.bar:ClearAllPoints()
			druid[name].rebirth.bar:SetPoint("BOTTOMLEFT", Window.rebirths, "TOPLEFT")
			_G[druid[name].rebirth.bar:GetName().."Texture"]:ClearAllPoints()
			_G[druid[name].rebirth.bar:GetName().."Texture"]:SetPoint("TOPLEFT", druid[name].rebirth.bar, "TOPLEFT")
		else
			druid[name].innervate.bar:ClearAllPoints()
			druid[name].innervate.bar:SetPoint("TOPLEFT", Window.innervates, "BOTTOMLEFT")
			_G[druid[name].innervate.bar:GetName().."Texture"]:ClearAllPoints()
			_G[druid[name].innervate.bar:GetName().."Texture"]:SetPoint("BOTTOMLEFT", druid[name].innervate.bar, "BOTTOMLEFT")
			druid[name].rebirth.bar:ClearAllPoints()
			druid[name].rebirth.bar:SetPoint("TOPLEFT", Window.rebirths, "BOTTOMLEFT")
			_G[druid[name].rebirth.bar:GetName().."Texture"]:ClearAllPoints()
			_G[druid[name].rebirth.bar:GetName().."Texture"]:SetPoint("BOTTOMLEFT", druid[name].rebirth.bar, "BOTTOMLEFT")
		end
	end
	
	local x = 0
	local height = self.db.profile.bar.height + self.db.profile.bar.spacing
	if ( self.db.profile.bar.growUp ) then
		height = -height
	end
	for _,name in pairs(sortedlist) do
		self:Debug("Updating bars for: "..name)
		self:UpdateBar(name, druid[name].innervate, x * height )		
		self:UpdateBar(name, druid[name].rebirth, x * height )
		x = x + 1
	end
end
function Rebirther:ChangeGrowDir()
	if ( self.db.profile.bar.growUp ) then
		_G[Window.innervates:GetName().."Icon"]:SetPoint("CENTER", Window.innervates, "BOTTOMRIGHT", -14, 0)
		_G[Window.rebirths:GetName().."Icon"]:SetPoint("CENTER", Window.rebirths, "BOTTOMRIGHT", -14, 0)
	else		
		_G[Window.innervates:GetName().."Icon"]:SetPoint("CENTER", Window.innervates, "TOPRIGHT", -14, 0)
		_G[Window.rebirths:GetName().."Icon"]:SetPoint("CENTER", Window.rebirths, "TOPRIGHT", -14, 0)
	end
end








-- Bar related functions

function Rebirther:CreateBar(name, parent, spell)
	local padding = self:GetPadding()
	local bar = {}
	local fname = name.."_SpellIs"..spell.enname.."_"..parent:GetName().."Bar"
	local propername = self:GetProperName(name)
	if ( _G[fname] ) then
		self:Debug("Creating bar: "..fname.." (already exists: showing)")
		bar.frame = _G[fname]
		bar.frame:Show()
	else
		self:Debug("Creating bar: "..fname)
		bar.frame = CreateFrame("FRAME", fname, parent, "BarTemplate")
		bar.frame:SetSize(self.db.profile.bar.width, ( self.db.profile.bar.height + self.db.profile.bar.spacing ) )
		local r, g, b, a = self.db.profile.backgroundColour.r, self.db.profile.backgroundColour.g, self.db.profile.backgroundColour.b, self.db.profile.backgroundColour.a	
		bar.background = _G[fname.."Background"]
		bar.background:SetTexture(r, g, b, a)
		bar.animation = _G[fname.."TextureAnimation"]
		bar.animation:SetDuration(spell.cooldown)
		bar.animation.max = self.db.profile.bar.width
		_G[fname.."TextureCasting"].max = self.db.profile.bar.width
		bar.texture = _G[fname.."Texture"]
		bar.texture:SetVertexColor(self.db.profile.bar.readyColour.r, self.db.profile.bar.readyColour.g, self.db.profile.bar.readyColour.b, self.db.profile.bar.opacity);
		bar.texture:SetTexture(self.db.profile.bar.texturePath)
		bar.texture:SetSize(self.db.profile.bar.width, self.db.profile.bar.height)
		bar.name = _G[fname.."Name"]
		--local p, r, rp = bar.name:GetPoint()
		--bar.name:SetPoint(p, r, rp, padding, padding)
		bar.name:SetFontObject(nameFont)
		bar.name:SetText(propername)
		bar.target = _G[fname.."Target"]
		bar.target:Hide()
		bar.target:SetFontObject(targetFont)
		bar.time = _G[fname.."Time"]
		--local p, r, rp = bar.time:GetPoint()
		--bar.time:SetPoint(p, r, rp, -padding, padding)
		bar.time:SetFontObject(timeFont)
		bar.time:SetText(L["Ready"])
		bar.time:SetWidth(0)
		
		bar.frame:EnableMouseWheel(true)
		
		bar.name:ClearAllPoints()
		bar.name:SetPoint("BOTTOM", bar.texture, "BOTTOM", padding, padding)
		bar.name:SetPoint("LEFT", bar.frame, "LEFT", padding, padding)

		bar.time:ClearAllPoints()
		bar.time:SetPoint("BOTTOM", bar.texture, "BOTTOM", -padding, padding)
		bar.time:SetPoint("RIGHT", bar.frame, "RIGHT", -padding, padding)
		
		--bar.name:SetPoint("BOTTOMLEFT", padding, padding)
		--bar.time:SetPoint("BOTTOMRIGHT", -padding, padding)
		bar.name:SetHeight(self.db.profile.font.nameSize)
		bar.name:SetJustifyH("LEFT")
		bar.target:SetJustifyH("LEFT")
		bar.time:SetJustifyH("RIGHT")	
		bar.name:SetWidth(0)
		bar.name:SetWidth(math.min(bar.name:GetWidth(), self.db.profile.bar.width - bar.time:GetWidth() - self:GetPadding()*2))
	end
	return bar.frame
end
function Rebirther:UpdateBar(player, spell, yOffset)
	local p, r, rp, xOffset, _ = spell.bar:GetPoint()
	spell.bar:SetPoint(p, r, rp, xOffset, -yOffset)
end
function Rebirther:AnimationFinished(texture)
	local name = string.sub(texture:GetName(), 1, string.find(texture:GetName(), "_")-1)
	local player = druid[name]
	self:Debug("Animation finished on bar: "..texture:GetParent():GetName())
	self:Debug("Texture: "..texture:GetName())
	self:Debug("Player: "..name)
	local spell = {}
	if ( string.find(texture:GetName(), "SpellIs"..SpellTemplate.innervate.enname) ) then
		self:Debug("Assuming innervate")
		spell = player.innervate
		druid[name].innervate.target = "Unknown"
	else
		self:Debug("Assuming rebirth")
		spell = player.rebirth
		druid[name].rebirth.target = "Unknown"
	end
	spell.time = "Ready"
	if ( UnitIsDeadOrGhost(player.name) or not UnitIsConnected(player.name) ) then
		self:SetDruidAlive(player.name, false)
	else	
		self:SetDruidAlive(player.name, true)
	end			
	_G[spell.bar:GetName().."Texture"]:SetWidth( spell.bar:GetWidth() )
	_G[spell.bar:GetName().."Texture"]:SetTexCoord(0, 1, 0, 1)
	_G[spell.bar:GetName().."Target"]:Hide()
end
function Rebirther:BarClicked(bar, button)	-- Fires when a bar is clicked
	local name = string.sub(bar:GetName(), 1, string.find(bar:GetName(), "_")-1)
	self:Debug("Bar clicked: "..bar:GetName())
	self:Debug("Name: "..name)
	if ( string.find(bar:GetName(), "SpellIs"..SpellTemplate.innervate.enname) ) then
		self:Debug("Assuming innervate")
		self:Request(name, SpellTemplate.innervate.name, "player")
	elseif ( string.find(bar:GetName(), "SpellIs"..SpellTemplate.rebirth.name) ) then
		self:Debug("Assuming rebirth")
		self:Request(name, SpellTemplate.rebirth.name, "123")
	end
end
function Rebirther:MouseWheel(bar, delta)
	if ( self.db.profile.bar.allowScroll ) then
		local name = string.sub(bar:GetName(), 1, string.find(bar:GetName(), "_")-1)
		local x = 0
		for key,val in pairs(sortedlist) do
			if ( val == name ) then
				x = key
			end
		end
		self:Debug("Delta: "..delta)
		if ( x - delta > 0 and x - delta <= size(sortedlist) ) then
			local temp = sortedlist[x] 
			sortedlist[x] = sortedlist[x-delta]
			sortedlist[x-delta] = temp
		end
		self:UpdateBars()
	end
end
function Rebirther:StartCooldown(spell, spelltime, source, target)	-- Starts a cooldown on spell. Note that spell in this particular case is a reference to a table (e.g. druid.innervate) and not the name of the spell. (inconsistent, I know)
	--self:Debug(source)
	--self:Debug(target)
	--self:Debug(spell.enname)
	if ( not spell.time ) then	-- I'm not sure about this check
		self:Debug("False cooldown: "..spell.name)
		-- This person isn't in the raid
		return
	end
	if ( spelltime ) then	-- note that spelltime is the remaining cooldown for the spell
		if ( spelltime > 0 and spelltime < spell.cooldown ) then
			self:Debug("Cooldown started: "..spell.name.." / Bar = "..spell.bar:GetName().." / Remaining time: "..spelltime)
			spell.time = GetTime() - ( spell.cooldown - spelltime )
			local r, g, b, a = self.db.profile.bar.cooldownColour.r, self.db.profile.bar.cooldownColour.g, self.db.profile.bar.cooldownColour.b, self.db.profile.bar.opacity
			_G[spell.bar:GetName().."Texture"]:SetVertexColor( r, g, b, a )
			_G[spell.bar:GetName().."TextureAnimation"]:SetDuration( spelltime )
			_G[spell.bar:GetName().."TextureAnimation"].max = self.db.profile.bar.width * ( spelltime / spell.cooldown )
			_G[spell.bar:GetName().."TextureAnimation"]:Play()	
		end
	else
		self:Debug("Cooldown started: "..spell.name.." / Bar = "..spell.bar:GetName())
		spell.time = GetTime()
		local r, g, b, a = self.db.profile.bar.cooldownColour.r, self.db.profile.bar.cooldownColour.g, self.db.profile.bar.cooldownColour.b, self.db.profile.bar.opacity
		_G[spell.bar:GetName().."Texture"]:SetVertexColor( r, g, b, a )
		_G[spell.bar:GetName().."TextureAnimation"]:SetDuration(spell.cooldown)
		_G[spell.bar:GetName().."TextureAnimation"].max = self.db.profile.bar.width
		_G[spell.bar:GetName().."TextureAnimation"]:Play()
	end
	if ( target ) then
		spell.target = target
		_G[spell.bar:GetName().."Target"]:SetText(" ("..self:GetProperName(target)..")")
		if ( self.db.profile.showtarget ) then
			_G[spell.bar:GetName().."Target"]:Show()
		end
		if ( spell.enname == SpellTemplate.innervate.enname and source ~= UnitName("player") ) then
			self:InnervateOut(L["X innervated Y"](self:ColourByClass(source), self:ColourByClass(target)))
		elseif ( spell.enname == SpellTemplate.rebirth.enname and source ~= UnitName("player") ) then
			self:RebirthOut(L["X ressed Y"](self:ColourByClass(source), self:ColourByClass(target)))
		else
			self:Debug("Unknown spell: "..spell.enname)
			--_G[spell.bar:GetName().."Target"]:SetText(" (Unknown)")
		end
	else
		self:Debug("No target specified")
	end
	self:SendSync("StartCooldown", source, spell.enname, target)
	return spell
end
function Rebirther:StartCasting(spell, target)
	if ( not spell.time ) then	-- I'm not sure about this check
		self:Debug("False cooldown: "..spell.name)
		-- This person isn't in the raid
		return
	end
	local r, g, b, a = self.db.profile.bar.cooldownColour.r, self.db.profile.bar.cooldownColour.g, self.db.profile.bar.cooldownColour.b, self.db.profile.bar.opacity
	_G[spell.bar:GetName().."Texture"]:SetVertexColor( r, g, b, a )
	_G[spell.bar:GetName().."TextureCasting"]:Play()
	if ( target and self.db.profile.showtarget ) then
		_G[spell.bar:GetName().."Target"]:SetText(" ("..self:GetProperName(target)..")")
		_G[spell.bar:GetName().."Target"]:Show()
	end
end
function Rebirther:CastingFinished(texture)
	local name = string.sub(texture:GetName(), 1, string.find(texture:GetName(), "_")-1)	-- This shit is crude, but it works
	local player = druid[name]	-- kinda pointless, just put it there cause I copy-pasted and couldn't be arsed changing a few lines
	local spell = {}
	if ( string.find(texture:GetName(), "SpellIs"..SpellTemplate.innervate.enname) ) then
		self:Debug("Assuming innervate")
		spell = player.innervate
	else	-- This could probably go awry
		self:Debug("Assuming rebirth")
		spell = player.rebirth
	end
	if ( spell.time == "Ready" ) then
		self:SetDruidAlive(name, druid[name].alive)
		_G[spell.bar:GetName().."Target"]:SetText(" (Unknown)")
		_G[spell.bar:GetName().."Target"]:Hide()
		_G[spell.bar:GetName().."Texture"]:SetTexCoord(0, 1, 0, 1)
	end
end












-- Player communication

function Rebirther:Request(name, spell, target)	-- This function may not work properly
	unitname = self:GetFullName(target)
	if ( self.db.profile.bar.allowClick and spell == SpellTemplate.innervate.name and druid[name].innervate.time == "Ready" and not UnitIsDeadOrGhost(name) and not UnitIsDeadOrGhost(unitname) ) then
		SendChatMessage(L["Innervate me!"], "WHISPER", nil, name)		
		self:Debug("Innervate requested")
	elseif ( self.db.profile.bar.allowClick and target == "123" and spell == SpellTemplate.rebirth.name and druid[name].rebirth.time == "Ready" and (IsRaidLeader() or IsRaidOfficer()) and not UnitIsDeadOrGhost(name)) then
		SendChatMessage(L["Your turn to res!"], "WHISPER", nil, name)		
		self:Debug("Rebirth requests on random")
	elseif ( spell == SpellTemplate.rebirth.name and druid[name].rebirth.time == "Ready" and (IsRaidLeader() or IsRaidOfficer()) and not UnitIsDeadOrGhost(name) and UnitIsDead(unitname)) then
		SendChatMessage(L["Combat res %t!"](unitname), "WHISPER", nil, name)
		self:Debug("Rebirth requested on specific")
	else		
		self:Debug("Unknown request: Name = "..name.. " / Spell = "..spell.." / Target = "..target)
	end
end
function Rebirther:Announce(spellName, destName)
	if ( destName == "Unknown" or not destName ) then
		return false
	end
	local group = self:GroupType()
	if ( (group == "BATTLEGROUND" and self.db.profile.announceToBG) or (group == "RAID" and self.db.profile.announceToRaid) or (group == "PARTY" and self.db.profile.announceToParty) ) then
		if ( spellName == SpellTemplate.innervate.name and self.db.profile.announceOnInnervate ) then
			local message = string.gsub(self.db.profile.innervateGroup, "%%t", destName)
			message = string.gsub(message, "%%s", spellName)
			if ( destName == UnitName("player") ) then
				if ( self.db.profile.announceOnSelf ) then
					SendChatMessage(message, group, nil, nil)
				end
			else
				SendChatMessage(message, group, nil, nil)
			end
		elseif ( spellName == SpellTemplate.rebirth.name and self.db.profile.announceOnRebirth ) then
			local message = string.gsub(self.db.profile.rebirthGroup, "%%t", destName)
			message = string.gsub(message, "%%s", spellName)
			SendChatMessage(message, group, nil, nil)
		elseif ( self.db.profile.announceOnNormal ) then
			local message = string.gsub(self.db.profile.normalGroup, "%%t", destName)
			message = string.gsub(message, "%%s", spellName)
			SendChatMessage(message, group, nil, nil)			
		end
	end
	if ( self.db.profile.announceToTarget and destName ~= UnitName("player") ) then
		if ( spellName == SpellTemplate.innervate.name ) then
			local message = string.gsub(self.db.profile.innervateWhisper, "%%t", destName)
			message = string.gsub(message, "%%s", spellName)
			SendChatMessage(message, "WHISPER", nil, destName)
		elseif ( spellName == SpellTemplate.rebirth.name ) then
			local message = string.gsub(self.db.profile.rebirthWhisper, "%%t", destName)
			message = string.gsub(message, "%%s", spellName)
			SendChatMessage(message, "WHISPER", nil, destName)
		elseif ( self.db.profile.announceOnNormal ) then
			local message = string.gsub(self.db.profile.normalWhisper, "%%t", destName)
			message = string.gsub(message, "%%s", spellName)
			SendChatMessage(message, "WHISPER", nil, destName)			
		end
	end
end











-- Group related functions

function Rebirther:GroupType(test)
	if ( test ) then
		if ( test == "BATTLEGROUND" and UnitInBattleground("player") ) then
			self:Debug("Group test POSTIVIVE for: "..test)
			return true
		elseif ( test == "RAID" and GetRealNumRaidMembers() > 0 ) then
			self:Debug("Group test POSTIVIVE for: "..test)
			return true
		elseif ( test == "PARTY" and GetRealNumPartyMembers() > 0 and GetRealNumRaidMembers() == 0 ) then
			self:Debug("Group test POSTIVIVE for: "..test)
			return true
		elseif ( test == "SOLO" and GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0 ) then
			self:Debug("Group test POSTIVIVE for: "..test)
			return true
		else
			self:Debug("Group test NEGATIVE for: "..test)
			return false
		end
	else
		if ( UnitInBattleground("player") ) then	-- Battleground
			return "BATTLEGROUND"
		elseif ( GetRealNumRaidMembers() > 0 ) then	-- Raid
			return "RAID"
		elseif ( GetNumRaidMembers() > 0 ) then	-- Battleground ( guess we're in a battleground afterall )
			return "BATTLEGROUND"
		elseif ( GetRealNumPartyMembers() > 0 ) then	-- Party
			return "PARTY"
		else
			return "SOLO"
		end
	end
end
function Rebirther:CheckGroupStatus()	-- Find new druids
	self:Debug("Checking group status")
	if ( UnitAffectingCombat("player") ) then	-- Don't update if the player is in combat! Dunno why but something bugged when stuff happened in combat (or was it something else?)
		RosterUpdate = true
		self:Debug("You are in combat: Waiting")
	elseif ( testmode ) then		
		self:Debug("You are in testing mode: Waiting")
	else
		self:Debug("Number of raid members: "..GetNumRaidMembers())
		self:Debug("Number of real raid members: "..GetRealNumRaidMembers())
		self:Debug("Number of real party members: "..GetRealNumPartyMembers())
		RosterUpdate = false
		--RosterLastUpdate = time()
		tmpa = NoDruids()
		if ( self:GroupType() == "RAID" ) then	-- Raid
			self:Debug("You are in a raid")
			local x, n, d = 1, GetRealNumRaidMembers(), GetRaidDifficulty()
			if ( d % 2 == 0 ) then -- 25 man
				d = 25
			else -- 10 man
				d = 10
			end
			self:Debug("Number of raid members: "..n)
			while x <= n do
				local name, _, subgroup, _, class, _, _, _, _, _, _ = GetRaidRosterInfo(x)
				if ( name ) then
					--self:Debug("Raid member #"..x..": "..name)
					if ( class == L["Druid"] ) then
						self:AddDruid(name)
					end
				end
				x = x + 1
			end
			self:Debug("Size of raid: "..d)
			--[[
			if ( not self.db.profile.showExtraGroups ) then
				self:Debug("Checking for redundant druids")
				x = 1
				while x <= n do
					local name, _, subgroup, _, class, _, _, _, _, _, _ = GetRaidRosterInfo(x)
					self:Debug("Name: "..name)			
					self:Debug("Subgroup: "..subgroup)			
					self:Debug("Class: "..class)
					if ( druid[name] and ((d == 25 and subgroup > 5) or (d == 10 and subgroup > 2)) ) then
						self:RemoveDruid(name)
						tmpa = 1000
					end
					x = x + 1
				end	
			end
			]]
			if ( not self.db.profile.showExtraGroups ) then
				self:Debug("Checking for redundant druids")
				x = 1
				while x <= n do
					local name, _, subgroup, _, class, _, _, _, _, _, _ = GetRaidRosterInfo(x)
					if ( name ) then
						--self:Debug("Name: "..name)
						--self:Debug("Subgroup: "..subgroup)			
						--self:Debug("Class: "..class)
						if ( druid[name] and ((d == 25 and subgroup > 5) or (d == 10 and subgroup > 2)) ) then
							self:RemoveDruid(name)
						end
					end
					x = x + 1
				end	
			end
		elseif ( self:GroupType() == "BATTLEGROUND" ) then	-- Battleground
			self:Debug("You are in a battleground")
			local x, n = 1, GetNumRaidMembers()			
			while x <= n do
				local name, _, _, _, class, _, _, _, _, _, _ = GetRaidRosterInfo(x)
				if ( name ) then
					--self:Debug("Raid member #"..x..": "..name)
					if ( class == L["Druid"] ) then
						self:AddDruid(name)
					end
				end
				x = x + 1
			end	
		elseif ( self:GroupType() == "PARTY" ) then	-- Party
			self:Debug("You are in a party")
			local x, n = 1, GetNumPartyMembers()
			while x <= n do
				local name,class = self:GetFullName("party"..x), UnitClass("party"..x)
				if ( name ) then
					--self:Debug("Party member #"..x..": "..name)
					if ( class == L["Druid"] ) then
						self:AddDruid(name)
					end
				end
				x = x + 1
			end
			if ( UnitClass("player") == L["Druid"] ) then	-- If the player is a druid, add him to the list
				self:AddDruid(UnitName("player"))	
				self:Debug("Adding yourself as a druid")
			end	
		else	-- All alone
			self:Debug("You are solo")
			if ( UnitClass("player") == L["Druid"] ) then	-- If the player is a druid, add him to the list
				self:AddDruid(UnitName("player"))
				self:Debug("Adding yourself as a druid")
			end	
		end
		for key,val in pairs(druid) do	-- Remove the druids who aren't in your group anymore
			if ( not (UnitInBattleground(val.name) or UnitInRaid(val.name) or UnitInParty(val.name) or UnitName("player") == val.name) ) then
				self:Debug(val.name.." is considered to NOT be in your group")
				self:RemoveDruid(val.name)
			else
				self:Debug(val.name.." is considered to be in your group")
			end
		end	
		--[[
		if ( tmpa - size(druid) ~= 0 ) then	-- If the number of druids changed (i.e. a druid joined or left)
			self:Debug("A druid has joined or left the group")
			if ( tmpa < size(druid) ) then
				self:RequestSync()	-- If a druid joined we want to see if he has any cooldowns to sync (this probably spams the shit out of the addon channel: find better solution)
			end
			local x = 0
			local height = self.db.profile.bar.height + self.db.profile.bar.spacing
			for key,val in pairs(druid) do
				self:Debug("Updating bars for: "..val.name)
				self:UpdateBar(val, val.innervate, x * height )		
				self:UpdateBar(val, val.rebirth, x * height )	
				x = x + 1
			end
		end
		]]
		if ( tmpa < NoDruids() ) then
			self:RequestSync()	-- If a druid joined we want to see if he has any cooldowns to sync (this probably spams the shit out of the addon channel: find better solution)
		end
		--[[
		local x = 0
		local height = self.db.profile.bar.height + self.db.profile.bar.spacing
		for key,val in pairs(druid) do
			if ( val.show ) then
				self:Debug("Updating bars for: "..val.name)
				self:UpdateBar(val, val.innervate, x * height )		
				self:UpdateBar(val, val.rebirth, x * height )
				x = x + 1
			end
		end
		]]
		self:UpdateBars()
		self:SetNames()
		
		
		self:Debug("Number of druids: "..NoDruids())
		self:Debug("Group type: "..self:GroupType())
		if ( self.db.profile.autoshow ) then		
			self:Debug("Auto show: on")
		else	
			self:Debug("Auto show: off")
		end		
		if ( self.db.profile.showInBG ) then		
			self:Debug("showInBG: on")
		else	
			self:Debug("showInBG: off")
		end		
		if ( self.db.profile.showInRaid) then		
			self:Debug("showInRaid: on")
		else	
			self:Debug("showInRaid: off")
		end		
		if ( self.db.profile.showInParty ) then		
			self:Debug("showInParty: on")
		else	
			self:Debug("showInParty: off")
		end	
		if ( self.db.profile.showWhenSolo ) then		
			self:Debug("showWhenSolo: on")
		else	
			self:Debug("showWhenSolo: off")
		end			
		
		
		
		if ( self.db.profile.autoshow ) then
			if ( (self:GroupType() == "BATTLEGROUND" and self.db.profile.showInBG and NoDruids() > 0) or (self:GroupType() == "RAID" and self.db.profile.showInRaid and NoDruids() > 0) or (self:GroupType() == "PARTY" and self.db.profile.showInParty and NoDruids() > 0) or (self:GroupType() == "SOLO" and self.db.profile.showWhenSolo) ) then
				self:Show(MasterWindow, true)
				self:Debug("Showing")
			else
				self:Show(MasterWindow, false)
				self:Debug("Hiding")
			end
		end
	end	
end













-- Events

function Rebirther:COMBAT_LOG_EVENT_UNFILTERED (eventName, ...)	
	-- I hope this isn't a resource hog (is there a better way of finding out if a spell has been cast?)
	local _,clevent,_,sourceName,_,_,destName,_,_,spellName = ...
	--[==[
	if ( druid[sourceName] and not druid[sourceName].alive) then
		--[[
		if ( UnitIsFriend("player", destName) and not clevent == "_ENERGIZE" and not clevent == "_FAILED" and not strfind(clevent, "DAMAGE_") and not strfind(clevent, "SPELL_PERIODIC") and not strfind(clevent, "AURA_REMOVED") ) then	-- Hots might still be ticking after a druid is dead
			self:Debug("Assuming druid is alive: Name = "..sourceName.." / Event = "..clevent.." / Spell = "..spellName)
			self:SetDruidAlive(sourceName, true)	
			self:SendSync("UnitAlive", sourceName, "nil", "nil")	
		end
		]]
		if ( clevent == "SPELL_CAST_SUCCESS" and time() - druid[sourceName].timeofdeath > 1 ) then
			self:Debug("Assuming druid is alive: Name = "..sourceName.." / Event = "..clevent.." / Spell = "..spellName)
			self:SetDruidAlive(sourceName, true)	
			self:SendSync("UnitAlive", sourceName, "nil", "nil")	
		end
	end
	]==]
	--[===[@debug@
	--[[
	if ( clevent == "SPELL_HEAL" and spellName == "Nourish" ) then
		self:Cout(L["X ressed Y"](sourceName, destName))
		self:StartCooldown(druid[sourceName].rebirth, nil, sourceName, destName)
	end
	]]
	--@end-debug@]===]
	if ( clevent == "SPELL_CAST_SUCCESS" ) then
		if ( spellName == SpellTemplate.innervate.name ) then
			--self:Cout(L["X innervated Y"](sourceName, destName))
			if ( druid[sourceName] ) then
				self:StartCooldown(druid[sourceName].innervate, nil, sourceName, destName)
				--self:SendSync("StartCooldown", sourceName, spellName, destName)	
				if ( sourceName == UnitName("player") ) then
					self:Announce(spellName, destName)
				end
			end
		end
	--[[
	elseif ( clevent == "UNIT_DIED") then
		if ( druid[destName] ) then
			self:SetDruidAlive(destName, false)
			self:SendSync("UnitDead", destName, "nil", "nil")
		end
	]]
	elseif ( clevent == "SPELL_RESURRECT" ) then
		if ( spellName == SpellTemplate.rebirth.name ) then
			--self:Cout(L["X ressed Y"](sourceName, destName))
			if ( druid[sourceName] ) then
				self:StartCooldown(druid[sourceName].rebirth, nil, sourceName, destName)	
				--self:SendSync("StartCooldown", sourceName, spellName, destName)
			end
		end
		--[[
		if ( druid[destName] and not druid[destName].alive ) then
			self:SetDruidAlive(destName, true)
			self:SendSync("UnitAlive", destName, "nil", "nil")	
		end
		]]
	elseif ( clevent == "SPELL_CAST_START" ) then
		if ( spellName == SpellTemplate.rebirth.name ) then
			if ( druid[sourceName] and  sourceName ~= UnitName("player") ) then
				if ( UnitName(sourceName.."-target") and UnitName(sourceName.."-target") ~= sourceName.."-target" and UnitIsFriend(sourceName, UnitName(sourceName.."-target")) ) then
					self:RebirthOut(L["X is ressing Y"](self:ColourByClass(sourceName), self:ColourByClass(sourceName.."-target")))
				else
					self:RebirthOut(L["X is ressing"](self:ColourByClass(sourceName)))
				end
				self:StartCasting(druid[sourceName].rebirth, self:GetFullName(sourceName.."-target"))
			end
		end
		--[===[@debug@
		--[[
		if ( spellName == "Nourish" ) then
			self:Cout(L["X is ressing"](sourceName))	-- Is it possible to see who he's casting on?			
			if ( sourceName == UnitName("player") ) then
				self:Announce(spellName)
			end
		end
		]]
		--@end-debug@]===]
	elseif ( clevent == "SPELL_AURA_APPLIED" ) then
		if ( spellName == "Soulstone Resurrection" ) then
			self:Cout(L["X is soulstoned"](self:ColourByClass(destName)))
		end
	end	
end

function Rebirther:UNIT_SPELLCAST_SENT(eventName, unitID, spell, rank, target)
	unitname = UnitName(unitID)
	if ( spell == SpellTemplate.rebirth.name and druid[unitname] ) then
		--self:Cout(L["X is ressing Y"](self:ColourByClass(unitname), self:ColourByClass(target)))
		self:StartCasting(druid[unitname].rebirth, target)
		self:Announce(spell, target)
	elseif ( spell == L["Redemption"] or spell == L["Resurrection"] or spell == L["Revive"] or spell == L["Ancestral Spirit"] ) then
		self:Announce(spell, target)
	end
end

function Rebirther:GroupChanged(eventName, ...)
	self:Debug("Event: "..eventName)
	RosterUpdate = true
end

--[[
-- I sense that this shit will spam
function Rebirther:RAID_ROSTER_UPDATE (eventName, ...)	-- Does this fire for every person in the raid when you join a raid? If so: fix
	--self:CheckGroupStatus()
	RosterUpdate = true
	if ( RosterUpdate ) then
		self:Debug("RosterUpdate: true")
	else
		self:Debug("RosterUpdate: false")
	end
	self:Debug("Event: "..eventName)
end
function Rebirther:PARTY_MEMBERS_CHANGED (eventName, ...)	-- Does RAID_ROSTER_UPDATE also fire with this event? If so: remove
	--self:CheckGroupStatus()
	RosterUpdate = true
	self:Debug("Event: "..eventName)
end

function Rebirther:PLAYER_ENTERING_BATTLEGROUND (eventName, ...)
	--self:CheckGroupStatus()
	RosterUpdate = true
	self:Debug("Event: "..eventName)
end

function Rebirther:PLAYER_ENTERING_WORLD (eventName, ...)
	--self:CheckGroupStatus()
	RosterUpdate = true
	self:Debug("Event: "..eventName)
end
]]

function Rebirther:PLAYER_REGEN_DISABLED (eventName, ...)	-- Probably never gonna use this
	self:Debug("Event: "..eventName)
end

function Rebirther:PLAYER_REGEN_ENABLED (eventName, ...)	-- Coming out of combat
	if ( RosterUpdate ) then
		--self:CheckGroupStatus()		
		--RosterUpdate = false
	end
	self:Debug("Event: "..eventName)
end










-- Syncing

function Rebirther:SendSync (event, name, spell, target)
	if ( self.db.profile.sync and self:GroupType() ~= "SOLO" ) then
		local PossibleGroups = { "RAID", "BATTLEGROUND", "PARTY" }
		for _,val in pairs(PossibleGroups) do
			if ( self:GroupType(val) ) then
				self:SendCommMessage( AddonCommPrefix, self:Serialize(event,name,spell,target), val )
				self:Debug("Sending sync: Event = "..event.." / Name = "..name.." / Channel = "..val)
			end
		end
	end
end
function Rebirther:RequestSync()
	if ( self.db.profile.sync and self:GroupType() ~= "SOLO" ) then
		local PossibleGroups = { "RAID", "BATTLEGROUND", "PARTY" }
		for _,val in pairs(PossibleGroups) do
			if ( self:GroupType(val) ) then
				self:SendCommMessage( AddonCommPrefix, self:Serialize("BroadcastRequest"), val )
				self:Debug("Requesting sync: Channel = "..val)
			end
		end		
	end
end
function Rebirther:OnCommReceived (prefix, message, distribution, sender)	-- When we receive a message from another client
	if ( self.db.profile.sync and self:GroupType() ~= "SOLO" and sender ~= UnitName("player")  ) then	-- Only use syncing if syncing is enabled and if we're not solo
		self:Debug("Recieved CommMessage: "..message)
		self:Debug("Channel: "..distribution)
		local success, event, name, spell, target = self:Deserialize(message)
		if ( success) then
			--self:Debug("Event = "..event.." / Name = "..name.." / Spell = "..spell)
			self:Debug("Event = "..event)
			if ( event == "StartCooldown" ) then
				if ( druid[name] ) then
					self:Debug("Druid exists!")
					if ( spell == SpellTemplate.innervate.enname and druid[name].innervate.time == "Ready" ) then
						self:StartCooldown(druid[name].innervate, nil, name, target)
					elseif ( spell == SpellTemplate.rebirth.enname and druid[name].rebirth.time == "Ready" ) then
						self:StartCooldown(druid[name].rebirth, nil, name, target)
					else
						self:Debug("Unknown spell or druid on CD: "..spell)
					end
				else				
					self:Debug("Druid doesn't exist!")
				end
			elseif ( event == "BroadcastRequest" ) then
				for key,val in pairs(druid) do
					if ( val.rebirth.time ~= "Ready" ) then
						--self:SendCommMessage( AddonCommPrefix, self:Serialize("SyncCooldown",val.name,val.rebirth.enname, val.rebirth.cooldown - (GetTime() - val.rebirth.time) ), "WHISPER", sender )					
						self:SendSync("SyncCooldown", val.name, val.rebirth.enname, val.rebirth.cooldown - (GetTime() - val.rebirth.time))
						self:Debug("Sending SyncCooldown event: Name = "..val.name.." / Spell = "..val.rebirth.enname.." / Time remaining on cd = "..(val.rebirth.cooldown - (GetTime() - val.rebirth.time)))
					end
					if ( val.innervate.time ~= "Ready" ) then
						--self:SendCommMessage( AddonCommPrefix, self:Serialize("SyncCooldown",val.name,val.innervate.enname, val.innervate.cooldown - (GetTime() - val.innervate.time) ), "WHISPER", sender )		
						self:SendSync("SyncCooldown", val.name, val.innervate.enname, val.innervate.cooldown - (GetTime() - val.innervate.time))
						self:Debug("Sending SyncCooldown event: Name = "..val.name.." / Spell = "..val.innervate.enname.." / Time remaining on cd = "..(val.innervate.cooldown - (GetTime() - val.innervate.time)))	
					end
				end
			elseif ( event == "SyncCooldown" ) then
				if ( druid[name] and target ) then
					if ( spell == SpellTemplate.innervate.enname and druid[name].innervate.time == "Ready" ) then
						Rebirther:StartCooldown(druid[name].innervate, target, name, nil)
						--druid[name].innervate.time = GetTime() - ( val.innervate.cooldown - cdtime )
					elseif ( spell == SpellTemplate.rebirth.enname and druid[name].rebirth.time == "Ready" ) then
						Rebirther:StartCooldown(druid[name].rebirth, target, name, nil)
						--druid[name].rebirth.time = GetTime() - ( val.rebirth.cooldown - cdtime )
					end
				end
			elseif ( event == "UnitDead" ) then
				if ( druid[name] and druid[name].alive ) then
					self:SetDruidAlive(name, false)
				end
			elseif ( event == "UnitAlive" ) then
				if ( druid[name] and not druid[name].alive ) then
					self:SetDruidAlive(name, true)				
				end
			else
				self:Debug("Unknown event: "..event)
			end
		else
			self:Debug("Error on message received")
		end
	end
end
























-- Options and defaults

function Rebirther:GetDefaults()
	return {
		profile = {
			-- Default settings
			
			enable = true,
			
			-- General
			show = true,
			showtarget = true,
			showServerName = false,
			showExtraGroups = false,
			sync = false,
			verbose = true,
			
			-- Windows
			lock = false,
			showicon = true,
			rebirthShow = true,
			innervateShow = true,
			scale = 1,
			backgroundColour = { r = 0, g = 0, b = 0, a = 0.5 },
			
			-- Announce when...	
			announceOnInnervate = true,
			announceOnRebirth = true,
			announceOnNormal = true,
			announceOnSelf = false,
			announceToBG = false,
			announceToRaid = true,
			announceToParty = true,
			announceToTarget = false,
			rebirthWhisper = L["DefaultRebirthWhisper"],
			rebirthGroup = L["DefaultRebirthGroup"],
			innervateWhisper = L["DefaultInnervateWhisper"],
			innervateGroup = L["DefaultInnervateGroup"],
			normalWhisper = L["DefaultNormalWhisper"],
			normalGroup = L["DefaultNormalGroup"],
						
			-- Show when...			
			autoshow = true,
			showInBG = false,
			showInRaid = true,
			showInParty = true,
			showWhenSolo = false,			
			
			-- Bars
			bar = {
				allowClick = true,
				allowScroll = true,
				readyColour = { r = 0, g = 1, b = 0 },
				deadColour = { r = 0.5, g = 0.5, b = 0.5 },
				cooldownColour = { r = 1, g = 0, b = 0 },
				opacity = 0.75,
				texture = SM:GetDefault("statusbar"),
				texturePath = SM:Fetch("statusbar", SM:GetDefault("statusbar")),
				width = 175,
				height = 20,
				spacing = 1,
				growUp = false,
			},
			
			-- Fonts
			font = {
				file = SM:GetDefault("font"),
				filePath = SM:Fetch("font", SM:GetDefault("font")),
				nameColour = { r = 1, g = 1, b = 1 },
				nameSize = 14,
				targetColour = { r = 1, g = 0.82, b = 0 },
				targetSize = 10,
				timeColour = { r = 1, g = 1, b = 1 },
				timeSize = 10,
				titleSize = 10,
				titleColour = { r = 1, g = 0.82, b = 0 },
			},
		}
	}
end

function Rebirther:GetOptions()
	return {
		name = AddonName,
		childGroups = "tab",
		handler = Rebirther,
		type = "group",
		args = {			
			version = {
				order = 0,
				name = L["Version"].." "..AddonVersion,
				--desc = "testing",
				type = "description",
			},
			enable = {
				name = L["Enable"],
				desc = L["EnablesDesc"],
				type = "toggle",
				order = 1,
				set = function(info,val) if ( self:IsEnabled() ) then self:Disable() else self:Enable() end end,
				get = function(info) return self:IsEnabled() end
			},
			testmode = {
				name = L["Test Mode"],
				desc = L["Test ModeDesc"],
				type = "toggle",
				order = 2,
				set = function(info,val) self:TestMode() end,
				get = function(info) return testmode end,
			},
			requestres = {
				name = L["Request Res"],
				usage = L["requestresusage"],
				desc = L["requestresdesc"],
				type = "input",
				guiHidden = true,
				set = function(info, input) 
						--[==[
						for a,b in pairs(druid) do
							if ( b.show and b.rebirth.time == "Ready" and not UnitIsDeadOrGhost(b.name) --[[and UnitIsDead(unitname)]] ) then
								self:Request(b.name, b.rebirth.name, input)
								break;
							end
						end
						]==]
						for _,name in pairs(sortedlist) do
							if ( druid[name].show and druid[name].rebirth.time == "Ready" and not UnitIsDeadOrGhost(name) --[[and UnitIsDead(unitname)]] ) then
								self:Request(name, druid[name].rebirth.name, input)
								break;
							end
						end
					end
			},
			checkgroup = {
				name = L["Check Group"],
				usage = L["Check GroupUsage"],
				desc = L["Check GroupDesc"],
				type = "input",
				guiHidden = true,
				set = function(info, input) self:CheckGroupStatus() end
			},
			debugme = {
				name = "Debug",
				usage = "Debug",
				desc = "Debug",
				type = "input",
				hidden = true,
				set = function(info, input) if (Debug) then self:Debug("Now shutting up"); Debug = false else Debug = true; self:Debug("Now displaying debug information") end end
			},
			requestinnervate = {
				name = "Request Innervate",
				desc = L["requestinnervatedesc"],
				type = "input",
				guiHidden = true,
				set = function(info, input) 
						if ( true or IsRaidLeader() or IsRaidOfficer() ) then
							--[[
							for a,b in pairs(druid) do
								if ( b.show and b.innervate.time == "Ready" and not UnitIsDeadOrGhost(b.name) and not UnitIsDead("player") ) then
									self:Request(b.name, b.innervate.name, "player")
									break;
								end
							end
							]]
							for _,name in pairs(sortedlist) do
								if ( druid[name].show and druid[name].innervate.time == "Ready" and not UnitIsDeadOrGhost(name) and not UnitIsDead("player") ) then
									self:Request(name, druid[name].innervate.name, "player")
									break;
								end
							end							
						else
							return false
						end
					end
			},
			general = {
				type = "group",
				name = L["General"],
				desc = L["GeneralDesc"],
				order = 4,
				args = {
					showheader = {
						name = L["Show..."],
						type = "header",
						order = 5,						
					},
					--[[
					show = {
						name = L["Show"],
						desc = L["ShowDesc"],
						type = "toggle",
						order = 0,
						set = function(info,val) self.db.profile.show = val; self:Show(MasterWindow, val) end,
						get = function(info) return self.db.profile.show end,
					},]]
					showtarget = {
						name = L["ShowTarget"],
						desc = L["ShowTargetDesc"],
						type = "toggle",
						order = 10,
						set = function(info,val) self.db.profile.showtarget = val; self:ShowTarget(val); self:SetSize() end,
						get = function(info) return self.db.profile.showtarget end,
					},
					showservername = {
						name = L["Show server name"],
						desc = L["Show server nameDesc"],
						type = "toggle",
						order = 15,
						set = function(info,val) self.db.profile.showServerName = val; self:SetNames() end,
						get = function(info) return self.db.profile.showServerName end,
					},
					showextragroups = {
						name = L["Show extra"],
						desc = L["Show extraDesc"],
						type = "toggle",
						order = 20,
						set = function(info,val) self.db.profile.showExtraGroups = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.showExtraGroups end,
					},
					showicon = {
						name = L["ShowIcon"],
						desc = L["ShowIconDesc"],
						type = "toggle",
						order = 25,
						set = function(info,val) self.db.profile.showicon = val; self:SetIcons() end,
						get = function(info) return self.db.profile.showicon end,
					},
					rebirth_window_show = {
						name = L["Show Rebirth Window"],
						desc = L["Show Rebirth WindowDesc"],
						type = "toggle",
						order = 30,
						set = function(info,val) self.db.profile.rebirthShow = val; self:Show(Window.rebirths, val) end,
						get = function(info) return self.db.profile.rebirthShow end,
					},
					innervate_window_show = {
						name = L["Show Innervate Window"],
						desc = L["Show Innervate WindowDesc"],
						type = "toggle",
						order = 35,
						set = function(info,val) self.db.profile.innervateShow = val; self:Show(Window.innervates, val) end,
						get = function(info) return self.db.profile.innervateShow end,
					},
					mischeader = {
						name = L["Miscellaneous"],
						type = "header",
						order = 40,						
					},
					sync = {
						name = L["Sync"],
						desc = L["SyncDesc"],
						type = "toggle",
						order = 45,
						set = function(info,val) self.db.profile.sync = val end,
						get = function(info) return self.db.profile.sync end,
					},
					verbose = {
						name = L["Verbose"],
						desc = L["VerboseDesc"],
						type = "toggle",
						order = 50,
						set = function(info,val) self.db.profile.verbose = val end,
						get = function(info) return self.db.profile.verbose end,
					},--[[
				}
			},
			windows = {
				type = "group",
				name = L["Windows"],
				desc = L["WindowsDesc"],
				order = 5,
				args = {]]
					lock = {
						name = L["Lock"],
						desc = L["LockDesc"],
						type = "toggle",
						order = 55,
						set = function(info,val) self.db.profile.lock = val end,
						get = function(info) return self.db.profile.lock end,
					},
					scale = {
						name = L["Scale"],
						desc = L["ScaleDesc"],
						type = "range",
						min = 0.1,
						max = 2,
						bigStep = 0.05,
						isPercent = true,
						order = 60,
						set = function(info,val) self.db.profile.scale = val; self:SetScale() end,
						get = function(info) return self.db.profile.scale end,
					},
					colour_background = {
						name = L["Background Colour"],
						desc = L["Background ColourDesc"],
						type = "color",
						order = 65,
						hasAlpha = true,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.backgroundColour, r, g, b, a); self:SetBackground() end,
						get = function(info) return self:GetColour(self.db.profile.backgroundColour) end,
					},
				}
			},
			announcewhen = {
				type = "group",
				name = L["Announcements"],
				desc = L["AnnouncementsDesc"],
				order = 8,
				args = {
					announcewhen = {
						name = L["Announce when..."],
						type = "header",
						order = 5,
					},
					castinginnervate = {
						name = L["AnnounceOnInnervate"],
						desc = L["AnnounceOnInnervateDesc"],
						type = "toggle",
						order = 10,
						set = function(info,val) self.db.profile.announceOnInnervate = val end,
						get = function(info) return self.db.profile.announceOnInnervate end,
					},
					castingrebirth = {
						name = L["AnnounceOnRebirth"],
						desc = L["AnnounceOnRebirthDesc"],
						type = "toggle",
						order = 15,
						set = function(info,val) self.db.profile.announceOnRebirth = val end,
						get = function(info) return self.db.profile.announceOnRebirth end,
					},
					castingnormal = {
						name = L["AnnounceOnNormal"],
						desc = L["AnnounceOnNormalDesc"],
						type = "toggle",
						order = 20,
						set = function(info,val) self.db.profile.announceOnNormal = val end,
						get = function(info) return self.db.profile.announceOnNormal end,
					},
					castingonself = {
						name = L["AnnounceOnSelf"],
						desc = L["AnnounceOnSelfDesc"],
						type = "toggle",
						order = 22,
						set = function(info,val) self.db.profile.announceOnSelf = val end,
						get = function(info) return self.db.profile.announceOnSelf end,
					},
					announceto = {
						name = L["Announce to..."],
						type = "header",
						order = 25,
					},
					tobg = {
						name = L["AnnounceToBG"],
						desc = L["AnnounceToBGDesc"],
						type = "toggle",
						order = 30,
						set = function(info,val) self.db.profile.announceToBG = val end,
						get = function(info) return self.db.profile.announceToBG end,
					},
					toraid = {
						name = L["AnnounceToRaid"],
						desc = L["AnnounceToRaidDesc"],
						type = "toggle",
						order = 35,
						set = function(info,val) self.db.profile.announceToRaid = val end,
						get = function(info) return self.db.profile.announceToRaid end,
					},
					toparty = {
						name = L["AnnounceToParty"],
						desc = L["AnnounceToPartyDesc"],
						type = "toggle",
						order = 40,
						set = function(info,val) self.db.profile.announceToParty = val end,
						get = function(info) return self.db.profile.announceToParty end,
					},
					totarget = {
						name = L["AnnounceToTarget"],
						desc = L["AnnounceToTargetDesc"],
						type = "toggle",
						order = 45,
						set = function(info,val) self.db.profile.announceToTarget = val end,
						get = function(info) return self.db.profile.announceToTarget end,
					},
					facebook = {
						name = "Facebook",
						desc = "Guru meditation",
						type = "toggle",
						order = 50,
						disabled = true,
						set = function(info,val) end,
						get = function(info) return true end,
					},
					rebirthannouncement = {
						name = L["Announcements for Rebirth"],
						type = "header",
						order = 55,
					},			
					announcedesc = {
						order = 57,
						name = L["AnnouncementstringDesc"],
						type = "description",
					},
					rebirthwhisper = {
						name = L["RebirthWhisper"],
						desc = L["RebirthWhisperDesc"],
						type = "input",
						width = "full",
						order = 60,
						set = function(info,val) self.db.profile.rebirthWhisper = val end,
						get = function(info) return self.db.profile.rebirthWhisper end,
					},
					rebirthgroup = {
						name = L["RebirthGroup"],
						desc = L["RebirthGroupDesc"],
						type = "input",
						width = "full",
						order = 65,
						set = function(info,val) self.db.profile.rebirthGroup = val end,
						get = function(info) return self.db.profile.rebirthGroup end,
					},
					innervateannouncements = {
						name = L["Announcements for Innervate"],
						type = "header",
						order = 70,
					},
					innervatewhisper = {
						name = L["InnervateWhisper"],
						desc = L["InnervateWhisperDesc"],
						type = "input",
						width = "full",
						order = 75,
						set = function(info,val) self.db.profile.innervateWhisper = val end,
						get = function(info) return self.db.profile.innervateWhisper end,
					},
					innervategroup = {
						name = L["InnervateGroup"],
						desc = L["InnervateGroupDesc"],
						type = "input",
						width = "full",
						order = 80,
						set = function(info,val) self.db.profile.innervateGroup = val end,
						get = function(info) return self.db.profile.innervateGroup end,
					},
					normalannouncements = {
						name = L["Announcements for Normal"],
						type = "header",
						order = 85,
					},
					normalwhisper = {
						name = L["NormalWhisper"],
						desc = L["NormalWhisperDesc"],
						type = "input",
						width = "full",
						order = 90,
						set = function(info,val) self.db.profile.normalWhisper = val end,
						get = function(info) return self.db.profile.normalWhisper end,
					},
					normalgroup = {
						name = L["NormalGroup"],
						desc = L["NormalGroupDesc"],
						type = "input",
						width = "full",
						order = 95,
						set = function(info,val) self.db.profile.normalGroup = val end,
						get = function(info) return self.db.profile.normalGroup end,
					},
				},
			},
			showwhen = {
				type = "group",
				name = L["Show when..."],
				desc = L["Show when...Desc"],
				order = 10,
				args = {
					autoshow = {
						name = L["Auto show"],
						desc = L["Auto showDesc"],
						type = "toggle",
						order = 0,
						set = function(info,val) self.db.profile.autoshow = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.autoshow end,
					},
					showwhen = {
						name = L["Show when..."],
						type = "header",
						order = 2,
					},
					inbg = {
						name = L["ShowInBG"],
						desc = L["ShowInBGDesc"],
						type = "toggle",
						order = 5,
						disabled = function(info) return not self.db.profile.autoshow end,
						set = function(info,val) self.db.profile.showInBG = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.showInBG end,
					},
					inraid = {
						name = L["ShowInRaid"],
						desc = L["ShowInRaidDesc"],
						type = "toggle",
						order = 10,
						disabled = function(info) return not self.db.profile.autoshow end,
						set = function(info,val) self.db.profile.showInRaid = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.showInRaid end,
					},
					inparty = {
						name = L["ShowInParty"],
						desc = L["ShowInPartyDesc"],
						type = "toggle",
						order = 15,
						disabled = function(info) return not self.db.profile.autoshow end,
						set = function(info,val) self.db.profile.showInParty = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.showInParty end,
					},
					solo = {
						name = L["ShowWhenSolo"],
						desc = L["ShowWhenSoloDesc"],
						type = "toggle",
						order = 20,
						disabled = function(info) return not self.db.profile.autoshow end,
						set = function(info,val) self.db.profile.showWhenSolo = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.showWhenSolo end,
					},
				},
			},
			bar = {
				type = "group",
				name = L["Bars"],
				desc = L["BarsDesc"],
				order = 15,
				args = {
					growup = {
						name = L["GrowUp"],
						desc = L["GrowUpDesc"],
						type = "toggle",
						order = 19,
						set = function(info,val) self.db.profile.bar.growUp = val; self:UpdateBars(); self:ChangeGrowDir() end,
						get = function(info) return self.db.profile.bar.growUp end,
					},
					allowclick = {
						name = L["AllowClick"],
						desc = L["AllowClickDesc"],
						type = "toggle",
						order = 20,
						set = function(info,val) self.db.profile.bar.allowClick = val end,
						get = function(info) return self.db.profile.bar.allowClick end,
					},
					allowscroll = {
						name = L["AllowScroll"],
						desc = L["AllowScrollDesc"],
						type = "toggle",
						order = 21,
						set = function(info,val) self.db.profile.bar.allowScroll = val end,
						get = function(info) return self.db.profile.bar.allowScroll end,
					},
					colour_ready = {
						name = L["Ready Colour"],
						desc = L["Ready ColourDesc"],
						type = "color",
						order = 25,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.bar.readyColour, r, g, b, a); self:SetBackground(); self:SetColours() end,
						get = function(info) return self:GetColour(self.db.profile.bar.readyColour) end,
					},
					colour_cooldown = {
						name = L["Cooldown Colour"],
						desc = L["Cooldown ColourDesc"],
						type = "color",
						order = 26,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.bar.cooldownColour, r, g, b, a); self:SetBackground(); self:SetColours() end,
						get = function(info) return self:GetColour(self.db.profile.bar.cooldownColour) end,
					},
					colour_dead = {
						name = L["Dead Colour"],
						desc = L["Dead ColourDesc"],
						type = "color",
						order = 27,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.bar.deadColour, r, g, b, a); self:SetBackground(); self:SetColours() end,
						get = function(info) return self:GetColour(self.db.profile.bar.deadColour) end,
					},
					alpha = {
						name = L["Opacity"],
						desc = L["OpacityDesc"],
						type = "range",
						min = 0,
						max = 1,
						bigStep = 0.05,
						order = 30,
						isPercent = true,
						set = function(info,val) self.db.profile.bar.opacity = val; self:SetBackground(); self:SetColours() end,
						get = function(info) return self.db.profile.bar.opacity end,
					},
					width = {
						name = L["Width"],
						desc = L["WidthDesc"],
						type = "range",
						min = 100,
						max = 500,
						bigStep = 5,
						order = 40,
						set = function(info,val) self.db.profile.bar.width = val; self:SetSize() end,
						get = function(info) return self.db.profile.bar.width end,
					},
					height = {
						name = L["Height"],
						desc = L["HeightDesc"],
						type = "range",
						min = 10,
						max = 50,
						bigStep = 1,
						order = 46,
						set = function(info,val) self.db.profile.bar.height = val; self:SetSize()  end,
						get = function(info) return self.db.profile.bar.height end,
					},
					spacing = {
						name = L["Spacing"],
						desc = L["SpacingDesc"],
						type = "range",
						min = 0,
						max = 10,
						bigStep = 1,
						order = 47,
						set = function(info,val) self.db.profile.bar.spacing = val; self:SetSize()  end,
						get = function(info) return self.db.profile.bar.spacing end,
					},
					bar_texture = {
						name = L["Texture"],
						desc = L["TextureDesc"],
						type = "select",
						--values = SM:List("statusbar");
						
						values = SM:HashTable("statusbar"),
						dialogControl = 'LSM30_Statusbar',
						
						style = "dropdown",
						order = 49,
						set = function(info,val) self.db.profile.bar.texture = val; self.db.profile.bar.texturePath = SM:Fetch("statusbar", self.db.profile.bar.texture); self:SetBackground() end,
						get = function(info) return self.db.profile.bar.texture end,
					},
				}
			},
			font = {
				type = "group",
				name = L["Fonts"],
				desc = L["FontsDesc"],
				order = 20,
				args = {
					font_name_colour = {
						name = L["Name Font Colour"],
						desc = L["Name Font ColourDesc"],
						type = "color",
						order = 55,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.font.nameColour, r, g, b, a); self:SetFonts() end,
						get = function(info) return self:GetColour(self.db.profile.font.nameColour) end,
					},
					font_time_colour = {
						name = L["Time Font Colour"],
						desc = L["Time Font ColourDesc"],
						type = "color",
						order = 65,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.font.timeColour, r, g, b, a); self:SetFonts() end,
						get = function(info) return self:GetColour(self.db.profile.font.timeColour) end,
					},
					font_target_colour = {
						name = L["Target Font Colour"],
						desc = L["Target Font ColourDesc"],
						type = "color",
						order = 72,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.font.targetColour, r, g, b, a); self:SetFonts() end,
						get = function(info) return self:GetColour(self.db.profile.font.targetColour) end,
					},
					font_title_colour = {
						name = L["Title Font Colour"],
						desc = L["Title Font ColourDesc"],
						type = "color",
						order = 74,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.font.titleColour, r, g, b, a); self:SetFonts() end,
						get = function(info) return self:GetColour(self.db.profile.font.titleColour) end,
					},
					font_name_size = {
						name = L["Name Font Size"],
						desc = L["Name Font SizeDesc"],
						type = "range",
						min = 6,
						max = 20,
						bigStep = 1,
						order = 60,
						set = function(info,val) self.db.profile.font.nameSize = val; self:SetFonts(); self:SetSize() end,
						get = function(info) return self.db.profile.font.nameSize end,
					},
					font_time_size = {
						name = L["Time Font Size"],
						desc = L["Time Font SizeDesc"],
						type = "range",
						min = 6,
						max = 20,
						bigStep = 1,
						order = 70,
						set = function(info,val) self.db.profile.font.timeSize = val; self:SetFonts(); self:SetSize() end,
						get = function(info) return self.db.profile.font.timeSize end,
					},
					font_target_size = {
						name = L["Target Font Size"],
						desc = L["Target Font SizeDesc"],
						type = "range",
						min = 6,
						max = 20,
						bigStep = 1,
						order = 73,
						set = function(info,val) self.db.profile.font.targetSize = val; self:SetFonts(); self:SetSize() end,
						get = function(info) return self.db.profile.font.targetSize end,
					},
					font_title_size = {
						name = L["Title Font Size"],
						desc = L["Title Font SizeDesc"],
						type = "range",
						min = 6,
						max = 20,
						bigStep = 1,
						order = 75,
						set = function(info,val) self.db.profile.font.titleSize = val; self:SetFonts(); self:SetSize(); self:SetSize() end,
						get = function(info) return self.db.profile.font.titleSize end,
					},
					font_file = {
						name = L["Font"],
						desc = L["FontDesc"],
						type = "select",
						--values = {"Font1", "Font2"},
						--values = SM:List("font");
						
						values = SM:HashTable("font"),
						dialogControl = 'LSM30_Font',
						
						style = "dropdown",
						order = 80,
						set = function(info,val) self.db.profile.font.file = val; self.db.profile.font.filePath = SM:Fetch("font", self.db.profile.font.file); self:SetFonts() end,
						get = function(info) return self.db.profile.font.file  end,
					},
				},
			},
		},
	}
end







-- Other kinds of events

function Rebirther:OnUpdate(handle, elapsed)
	LastUpdate = LastUpdate + elapsed
	if ( LastUpdate > UpdateInterval ) then
		if ( MustUpdateNames ) then
			self:SetNames()
			MustUpdateNames = false
		end
		LastUpdate = 0
		if ( RosterUpdate ) then
			self:CheckGroupStatus()			
		end
		if ( not testmode ) then
			for _,val in pairs(druid) do
				if ( val.show ) then
					if ( UnitIsConnected(val.name) and not UnitIsDeadOrGhost(val.name) and not val.alive ) then
						self:SetDruidAlive(val.name, true)
					elseif ( not UnitIsConnected(val.name) and val.alive ) then
						self:SetDruidAlive(val.name, false, true)
					elseif ( UnitIsDeadOrGhost(val.name) and val.alive ) then
						self:SetDruidAlive(val.name, false)
					end
				end
			end
		end
	end
end

function Rebirther:OnEnable()

	self:RegisterEvent("UNIT_SPELLCAST_SENT")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", "GroupChanged")
	self:RegisterEvent("RAID_ROSTER_UPDATE", "GroupChanged")
	self:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND", "GroupChanged")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "GroupChanged")
	self:RegisterEvent("PLAYER_DIFFICULTY_CHANGED", "GroupChanged")

	--[[
	for key,val in pairs (AddonEvents) do
		self:RegisterEvent(AddonEvents[key])
	end
	]]
	
	self:SetSize()
	self:SetScale()
	self:SetBackground()
	self:SetIcons()
	self:ChangeGrowDir()
	
	self:RegisterComm(AddonCommPrefix)
	
	self:HookScript(SuperWindow, "OnUpdate")
	
	self:Show(Window.rebirths, self.db.profile.rebirthShow)
	self:Show(Window.innervates, self.db.profile.innervateShow)
	self:Show(MasterWindow, self.db.profile.show)
end

function Rebirther:OnDisable()			
	self:Show(Window.rebirths, false)
	self:Show(Window.innervates, false)
	self:Show(MasterWindow, false)
end
function Rebirther:ProfileChanged()
	self:SetFonts()	
	self:SetSize()
	self:SetScale()
	self:SetBackground()
	self:SetIcons()	
	self:SetNames()
	self:SetColours()
	self:CheckGroupStatus()
end
function Rebirther:ChatCommand(input)
    if ( not input or input:trim() == "" ) then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0").HandleCommand(Rebirther, "Rebirther", "Rebirther", input)
    end
end
function Rebirther:OnInitialize()	-- This function is run when the ADDON_LOADED event is fired
	local AddonDefaults = self:GetDefaults()
	self.db = LibStub("AceDB-3.0"):New(AddonDBName, AddonDefaults, true)
	self.db.RegisterCallback(self, "OnProfileChanged", "ProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "ProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "ProfileChanged")
	local AddonOptions = self:GetOptions()	
	AddonOptions.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	--LibStub("AceConfig-3.0"):RegisterOptionsTable(AddonName, AddonOptions, AddonSlash)
	LibStub("AceConfig-3.0"):RegisterOptionsTable(AddonName, AddonOptions)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(AddonName)
	for _,cmd in pairs(AddonSlash) do
		self:RegisterChatCommand(cmd, "ChatCommand")
	end
	
	if ( not SuperWindow ) then
		SuperWindow = CreateFrame("FRAME", "SUPERWINDOW", UIParent, "ParentFrameTemplate")
	end
	if ( not MasterWindow ) then
		MasterWindow = CreateFrame("FRAME", AddonName, MasterWindow, "ParentFrameTemplate")
	end
	self:SetFonts()
	if ( not Window.rebirths ) then
		Window.rebirths = self:CreateWindow(L["Rebirths"], "Interface\\ICONS\\Spell_Nature_Reincarnation")
	end
	if ( not Window.innervates ) then
		Window.innervates = self:CreateWindow(L["Innervates"], "Interface\\ICONS\\Spell_Nature_Lightning")
	end
	--[[
	SuperWindow = CreateFrame("FRAME", "SUPERWINDOW", UIParent, "ParentFrameTemplate")
	MasterWindow = CreateFrame("FRAME", AddonName, MasterWindow, "ParentFrameTemplate")
	self:SetFonts()	
	Window.rebirths = self:CreateWindow(L["Rebirths"], "Interface\\ICONS\\Spell_Nature_Reincarnation")
	Window.innervates = self:CreateWindow(L["Innervates"], "Interface\\ICONS\\Spell_Nature_Lightning")
	self:SetSize()
	self:SetScale()
	self:SetBackground()
	self:SetIcons()
	]]
	
	ClassColour = Rebirther:GetLocalizedClassesWithColours()
end