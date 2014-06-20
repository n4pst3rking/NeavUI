
local f = CreateFrame('Frame')

f.Head = CreateFrame('Button', nil, CharacterHeadSlot)
f.Head:SetFrameStrata('HIGH')
SetSize(f.Head, 16, 32)
f.Head:SetPoint('LEFT', CharacterHeadSlot, 'CENTER', 9, 0)

f.Head:SetScript('OnClick', function() 
    ShowHelm(not ShowingHelm()) 
end)

f.Head:SetScript('OnEnter', function(self) 
    GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 13, -10)
    GameTooltip:AddLine(SHOW_HELM)
    GameTooltip:Show()
end)

f.Head:SetScript('OnLeave', function() 
    GameTooltip:Hide()
end)

f.Head:SetNormalTexture('Interface\\AddOns\\nCore\\media\\textureNormal')
f.Head:SetHighlightTexture('Interface\\AddOns\\nCore\\media\\textureHighlight')
f.Head:SetPushedTexture('Interface\\AddOns\\nCore\\media\\texturePushed')

f.Cloak = CreateFrame('Button', nil, CharacterBackSlot)
f.Cloak:SetFrameStrata('HIGH')
SetSize(f.Cloak, 16, 32)
f.Cloak:SetPoint('LEFT', CharacterBackSlot, 'CENTER', 9, 0)

f.Cloak:SetScript('OnClick', function() 
    ShowCloak(not ShowingCloak()) 
end)

f.Cloak:SetScript('OnEnter', function(self) 
    GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 13, -10)
    GameTooltip:AddLine(SHOW_CLOAK)
    GameTooltip:Show()
end)

f.Cloak:SetScript('OnLeave', function() 
    GameTooltip:Hide()
end)

f.Cloak:SetNormalTexture('Interface\\AddOns\\nCore\\media\\textureNormal')
f.Cloak:SetHighlightTexture('Interface\\AddOns\\nCore\\media\\textureHighlight')
f.Cloak:SetPushedTexture('Interface\\AddOns\\nCore\\media\\texturePushed')