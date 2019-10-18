function addline_itemid()
	itemName,itemLink = ItemRefTooltip:GetItem()
	if itemLink ~= nil then
		local itemString = string.match(itemLink, "item[%-?%d:]+")
		local _, itemId, enchantId, jewelId1, jewelId2, jewelId3, 
		jewelId4, suffixId, uniqueId, linkLevel, reforgeId = strsplit(":", itemString)

		ItemRefTooltip:AddLine("ItemID:"..itemId)
		ItemRefTooltip:Show();
	end
end

function addline_gametip()
	itemName,itemLink = GameTooltip:GetItem()
	if itemLink ~= nil then	   
		local itemString = string.match(itemLink, "item[%-?%d:]+")
		local _, itemId, enchantId, jewelId1, jewelId2, jewelId3, 
		jewelId4, suffixId, uniqueId, linkLevel, reforgeId = strsplit(":", itemString)

		GameTooltip:AddLine("ItemID:"..itemId)
		GameTooltip:Show();
	end
end

ItemRefTooltip:SetScript("OnShow", addline_itemid)
GameTooltip:SetScript("OnShow",addline_gametip)

hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
	local id = select(11,UnitBuff(...))
	if id then
		self:AddDoubleLine("SpellID:",id)
		self:Show()
	end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
	local id = select(11,UnitDebuff(...))
	if id then
		self:AddDoubleLine("SpellID:",id)
		self:Show()
	end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(11,UnitAura(...))
	if id then
		self:AddDoubleLine("SpellID:",id)
		self:Show()
	end
end)

hooksecurefunc("SetItemRef", function(link, text, button, chatFrame)
	if string.find(link,"^spell:") then
		local id = string.sub(link,7)
		ItemRefTooltip:AddDoubleLine("SpellID:",id)
		ItemRefTooltip:Show()
	end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select(3,self:GetSpell())
	if id then
		self:AddDoubleLine("SpellID:",id)
		self:Show()
	end
end)