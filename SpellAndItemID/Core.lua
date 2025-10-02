local format, strmatch, tonumber, tostring, ipairs = format, strmatch, tonumber, tostring, ipairs;
local GetLocale, UnitName, UnitGUID, GetGlyphSocketInfo = GetLocale, UnitName, UnitGUID, GetGlyphSocketInfo;
local UnitBuff, UnitDebuff, UnitAura, UnitIsPlayer = UnitBuff, UnitDebuff, UnitAura, UnitIsPlayer;
local CreateFrame, hooksecurefunc = CreateFrame, hooksecurefunc;

local types = {
	spell       = "Spell ID:",
	aplied		= "Applied by:",
	item        = "Item ID:",
	unit        = "NPC ID:",
	quest       = "Quest ID:",
	achievement = "Achievement ID:",
	glyph 		= "Glyph ID:",
};

if (GetLocale() == "ruRU") then
	types.spell       = "ID заклинания:"
	types.aplied      = "Наложено:"
	types.item        = "ID предмета:"
	types.unit        = "ID НПЦ:"
	types.quest       = "ID задания:"
	types.achievement = "ID достижения:"
	types.glyph		  = "ID символа:"
end;

-- Lightweight caches ----------------------------------------------------------
local glyphIdCache = {};
local linkToItemIdCache = {};
local unitIdCache = {};
local spellIdCache = {};

-- Cache size limits to prevent memory leaks
local MAX_CACHE_SIZE = 1000;
local function trimCache(cache)
    local count = 0;
    for k in pairs(cache) do
        count = count + 1;
        if count > MAX_CACHE_SIZE then
            cache[k] = nil;
        end
    end
end

-- Precompiled patterns --------------------------------------------------------
local ITEM_ID_PATTERN = "item:(%d+)";

local function addLine(tooltip, id, type)
    if not id then return; end
    local tooltipName = tooltip:GetName();
    local num = tooltip:NumLines() or 0;
    local startLine = (num > 5) and (num - 4) or 1;
    
    for i = startLine, num do
        local frame = _G[tooltipName.."TextLeft"..i];
        local text = frame and frame:GetText();
        if text == type then
            return;
        end
    end
    tooltip:AddDoubleLine(type, format("|cffffffff%s", id));
    tooltip:Show();
end;

local function addSpacerLine(tooltip, type)
    local num = tooltip:NumLines() or 0
    if num == 0 then
        tooltip:AddLine(" ");
        tooltip:Show();
        return
    end
    local last = _G[tooltip:GetName().."TextLeft"..num]
    local text = last and last:GetText()
    if text ~= " " then
        tooltip:AddLine(" ");
        tooltip:Show();
    end 
end;

-- For Linked Tooltips --------------------------------------------------------
local INTERESTED = { spell = true, enchant = true, trade = true, quest = true, achievement = true }
local function onSetHyperlink(self, link)
    local t, id = strmatch(link, "^(%a+):(%d+)")
    if not (t and id and INTERESTED[t]) then return end
    if (t == "spell" or t == "enchant" or t == "trade") then
        addSpacerLine(self, types.spell);
        addLine(self, id, types.spell);
    elseif t == "quest" then
        addSpacerLine(self, types.quest);
        addLine(self, id, types.quest);
    elseif t == "achievement" then
        addSpacerLine(self, types.achievement);
        addLine(self, id, types.achievement);
    end
end;
hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)

-- Spell Hooks ----------------------------------------------------------------
local function attachAura(self, getter, ...)
    local name, _, _, _, _, _, _, unitCaster, _, _, spellId = getter(...)
    if spellId then
        addSpacerLine(self, types.spell);
        addLine(self, spellId, types.spell);
    end
    if unitCaster then
        local exactname = UnitName(unitCaster);
        addLine(self, exactname, types.aplied, true);
    end 
end
hooksecurefunc(GameTooltip, "SetUnitBuff",   function(self, ...) attachAura(self, UnitBuff,   ...) end);
hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self, ...) attachAura(self, UnitDebuff, ...) end);
hooksecurefunc(GameTooltip, "SetUnitAura",   function(self, ...) attachAura(self, UnitAura,   ...) end);
local tooltip = ItemRefTooltip;
hooksecurefunc("SetItemRef", function(link, ...)
	local cached = spellIdCache[link];
	local id = cached;
	if id == nil then
		id = tonumber(link:match("spell:(%d+)")) or false;
		spellIdCache[link] = id;
	end
	if id and id ~= false then 
		addSpacerLine(tooltip, types.spell);
		addLine(tooltip, id, types.spell);
	end
end)
GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local _, _, id = self:GetSpell();
	if id then 
		addSpacerLine(self, types.spell);
		addLine(self, id, types.spell) 
	end
end);

-- NPCs Hooks ----------------------------------------------------------------
GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    local _, unit = self:GetUnit();
    if not unit then return; end
    
    local guid = UnitGUID(unit);
    if not guid then return; end
    
    local id = unitIdCache[guid];
    if id == nil then
        local guidType = guid:match("^(%a+)");
        if not UnitIsPlayer(unit) then
            id = tonumber(guid:sub(-11, -7), 16) or false;
        else
            id = false;
        end
        unitIdCache[guid] = id;
    end
    
    if id and id ~= false then 
        addSpacerLine(self, types.unit);
        addLine(self, id, types.unit);
    end
end);

-- Items Hooks ----------------------------------------------------------------
local function attachItemTooltip(self)
	local _, link = self:GetItem();
    if link then
        local id = linkToItemIdCache[link];
		if id == nil then
            id = tonumber(strmatch(link, ITEM_ID_PATTERN)) or false;
			linkToItemIdCache[link] = id;
		end
		if id == false then 
			return 
		end
		if id then
			addSpacerLine(self, types.item);
			addLine(self, id, types.item);
		end
	end
end;

-- Glyphs Hooks ----------------------------------------------------------------
hooksecurefunc(GameTooltip, "SetGlyph", function(self, ...)
	local arg1, arg2 = ...;
	local key = tostring(arg1) .. ":" .. tostring(arg2);
	local id = glyphIdCache[key];
	if id == nil then
		local _, _, resolvedId = GetGlyphSocketInfo(arg1, arg2);
		glyphIdCache[key] = resolvedId or false;
		id = resolvedId;
	end
	if id then 
		addSpacerLine(self, types.glyph);
		addLine(self, id, types.glyph);
	end
end);
GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip);
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip);
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip);
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip);
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip);
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip);

-- Cache cleanup timer --------------------------------------------------------
local cleanupTimer = CreateFrame("Frame");
local cleanupCounter = 0;
cleanupTimer:SetScript("OnUpdate", function(self, elapsed)
    cleanupCounter = cleanupCounter + elapsed;
    if cleanupCounter >= 300 then
        cleanupCounter = 0;
        trimCache(glyphIdCache);
        trimCache(linkToItemIdCache);
        trimCache(unitIdCache);
        trimCache(spellIdCache);
    end
end);

-- Achievement Frame Hooks -----------------------------------------------------
local achievementFrameHooked = false;
local f = CreateFrame("frame");
f:RegisterEvent("ADDON_LOADED");
f:SetScript("OnEvent", function(_, _, what)
	if what == "Blizzard_AchievementUI" and not achievementFrameHooked then
		achievementFrameHooked = true;
		local container = AchievementFrameAchievementsContainer;
		if container and container.buttons then
			for i, button in ipairs(container.buttons) do
				if button.id then
					button:HookScript("OnEnter", function()
						GameTooltip:SetOwner(button, "ANCHOR_NONE");
						GameTooltip:SetPoint("TOPLEFT", button, "TOPRIGHT", 0, 0);
						addLine(GameTooltip, button.id, types.achievement);
						GameTooltip:Show();
					end);
					button:HookScript("OnLeave", function() GameTooltip:Hide() end);
				end
			end
		end
	end
end);