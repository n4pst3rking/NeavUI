local abt = abtNS

abt.PresetsFrame = CreateFrame('Frame', 'ABTPresetsFrame', InterfaceOptionsFramePanelContainer)
abt.PresetsFrame:Hide()
abt.PresetsFrame.name = 'ActionButtonText'

abt.newEntryValue = 'New ActionButtonText'

function abt.PresetsFrame:CreatePresetsDropdown()
  self.PresetsDropdown = CreateFrame('Frame', 'ABT_PresetsDropdown', self, 'UIDropDownMenuTemplate')
  self.PresetsDropdown:SetPoint('TOPLEFT', self.Title, 'BOTTOMLEFT', 0, 0)

  self.PresetsDropdown.Initialize = function()
    local DropdownEle_OnClick = function()
      UIDropDownMenu_SetSelectedValue(self.PresetsDropdown, this.value)
      InterfaceOptionsFrame_OpenToFrame(abt.CreateFrame.name)
    end

    local items = {}
    if ABT_SpellDB then
      for spell in pairs(ABT_SpellDB) do
        items.text = spell
        items.func = DropdownEle_OnClick
        items.value = spell
        items.checked = false
        UIDropDownMenu_AddButton(items)
      end
    end
    items.text = 'New ActionButtonText'
    items.func = DropdownEle_OnClick
    items.value = abt.newEntryValue
    items.checked = false
    UIDropDownMenu_AddButton(items)
  end

  UIDropDownMenu_SetWidth(180, self.PresetsDropdown)
  UIDropDownMenu_JustifyText('LEFT', self.PresetsDropdown)
end

function abt.PresetsFrame:CreateAboutText()
  self.AboutText = CreateFrame('SimpleHTML', 'ABT_AboutText', self.PresetsDropdown)
  self.AboutText:SetFontObject('P' , GameFontHighlightSmall)
  self.AboutText:SetFontObject('H1', GameFontHighlightLarge)
  self.AboutText:SetFontObject('H2', GameFontHighlight)
  self.AboutText:SetPoint('TOPLEFT', self.PresetsDropdown, 'BOTTOMLEFT', 25, -15)
  self.AboutText:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -40, 15)
  self.AboutText:SetPoint('BOTTOM', self, 'BOTTOM', -5)
  self.AboutText:SetWidth(300)
  self.AboutText:SetHeight(40)
  self.AboutText:SetText(abt.configtext)
end

function abt.PresetsFrame:Refresh()
  UIDropDownMenu_Initialize(self.PresetsDropdown, self.PresetsDropdown.Initialize)
  self.AboutText:Show()
end

function abt.PresetsFrame:Init()
  self.Title = self:CreateFontString(nil, nil, 'GameFontNormalLarge')
  self.Title:SetPoint('TOPLEFT', 16, -16)
  self.Title:SetText(abt.con0)
  self:CreatePresetsDropdown()
  self:CreateAboutText()
  self:Refresh()
end

abt.PresetsFrame:SetScript('OnShow', function(self)
  self:Init()
  self:SetScript('OnShow', nil)
end)

InterfaceOptions_AddCategory(abt.PresetsFrame)