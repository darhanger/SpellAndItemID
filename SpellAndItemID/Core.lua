local LastBaa = 0;
local cleartime = 0;
local melee = 0;
local annoying = true;
local L = LibStub("AceLocale-3.0"):GetLocale("SpellAndItemID")

local function onUpdate(self,elapsed) 
  if self.time < GetTime() - 2 then
    if self:GetAlpha() == 0 then self:Hide() else self:SetAlpha(self:GetAlpha() - .05) end
  end
end

local messanger = CreateFrame("Frame",nil,UIParent) 
messanger:SetSize(ChatFrame1:GetWidth(),30)
messanger:Hide()
--messanger:SetScript("OnUpdate",onUpdate)
messanger:SetPoint("CENTER",0,70)
messanger.text = messanger:CreateFontString(nil,"OVERLAY","MovieSubtitleFont")
messanger.text:SetAllPoints()
messanger.texture = messanger:CreateTexture()
messanger.texture:SetAllPoints()
--messanger.time = 0

function messanger:message(message) 
  self.text:SetText(message)
  self:SetAlpha(1)
  --self.time = GetTime()
  self:Show() 
end

local MouseoverFrame = CreateFrame("Frame");
MouseoverFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
MouseoverFrame:SetScript("OnEvent", function(self,event,...)
	if event == "UPDATE_MOUSEOVER_UNIT" then
	    if (UnitExists("mouseover") == 1) then
		GameTooltip:ClearLines();
		GameTooltip:SetUnit("mouseover")
        local guildName, guildRank = GetGuildInfo("mouseover");
			if guildName ~= nil and guildRank ~= nil then
				--GameTooltip:AddLine("|cffffffff"..guildName);
				GameTooltip:AddLine("|cffffffffGuild Rank: "..guildRank);
				if UnitExists("mouseover-target") then
					GameTooltip:AddLine("|cffffffffTargeting: "..UnitName("mouseover-target"));
				end
				GameTooltip:Show();
			end
		end
    end
end);

local select, UnitBuff, UnitDebuff, UnitAura, tonumber, strfind, hooksecurefunc =
	select, UnitBuff, UnitDebuff, UnitAura, tonumber, strfind, hooksecurefunc

local function addLine(self,id,isItem,Caster)
	if isItem then
		self:AddDoubleLine(L["ItemID:"],"|cffffffff"..id)
	elseif Caster then
		self:AddDoubleLine(L["Applied by:"],"|cffffffff"..id)
	else
		self:AddDoubleLine(L["SpellID:"],"|cffffffff"..id)
	end
	self:Show()
end

-- Spell Hooks ----------------------------------------------------------------
hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
	local id = select(11,UnitBuff(...))
	local name = select(8, UnitBuff(...))
	if id then addLine(self,id) end
	if name then 
		local exactname = UnitName(name);
		addLine(self,exactname,nil,true);
	end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
	local id = select(11,UnitDebuff(...));
	local name = select(8, UnitDebuff(...));
	if id then addLine(self,id) end
	if name then 
		local exactname = UnitName(name);
		addLine(self,exactname,nil,true);
	end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(11,UnitAura(...));
	local name = select(8, UnitAura(...));
	if id then addLine(self,id) end
	if name then 
		local exactname = UnitName(name);
		addLine(self,exactname,nil,true);
	end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select(3,self:GetSpell())
	if id then addLine(self,id) end
end)

hooksecurefunc("SetItemRef", function(link, ...)
	local id = tonumber(link:match("spell:(%d+)"))
	if id then addLine(ItemRefTooltip,id) end
end)

-- Item Hooks -----------------------------------------------------------------

local function attachItemTooltip(self)
	local link = select(2,self:GetItem())
	if not link then return end
	local id = select(3,strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
	if id then addLine(self,id,true) end
end

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip3:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip3:HookScript("OnTooltipSetItem", attachItemTooltip)

SlashCmdList["READYCHECK"] = function() DoReadyCheck() end
SLASH_READYCHECK1 = '/rc'