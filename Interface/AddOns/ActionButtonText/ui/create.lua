local abt = abtNS

local playerClass = select(2, UnitClass('player'))

local _G = _G
local find = string.find
local GameTooltip = GameTooltip

local function BlankToNil(val)
  if not val or find(val, '^ *$') then -- string is either '' or all spaces
    return nil
  else
    return val
  end
end

local function FalseToNil(val)
  if val and val == 1 then
    return true
  else
    return nil
  end
end

local function NilIf(val, limit)
  if val == limit then
    return nil
  else
    return val
  end
end

abt.CreateFrame = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
abt.CreateFrame:Hide()
abt.CreateFrame.name = 'Create/Edit'
abt.CreateFrame.parent = abt.PresetsFrame.name

abt.CreateFrame.SelectedPreset = ''
abt.CreateFrame.SelectedPresetValues = {}

function abt.CreateFrame:CreateForm()
  -- Spell name input
  self.SpellnameEdit = CreateFrame('Editbox', 'ABT_SpellnameEdit', self, 'InputBoxTemplate')
  self.SpellnameEdit:SetAutoFocus(false)
  self.SpellnameEdit:SetWidth(180)
  self.SpellnameEdit:SetHeight(32)
  self.SpellnameEdit:SetFontObject(GameFontHighlightSmall)
  self.SpellnameEdit:SetPoint('TOPLEFT', self.Title, 'BOTTOMLEFT', 0, 0)
  function self.SpellnameEdit:GetFilteredText()
    return gsub(self:GetText(), '(.*)#', '')
  end
  self.SpellnameEdit:SetScript('OnTextChanged', function(self)
    local newValue = strupper(self:GetText())
    self:SetText(newValue)
    abt.CreateFrame.SaveButton:Enable()
    self.Error:SetText('')
    -- if the spell name was changed and a preset with the same name is present
    -- show error message and disable save button
    if newValue ~= abt.CreateFrame.SelectedPreset then
      if ABT_SpellDB and ABT_SpellDB[newValue] then
        abt.CreateFrame.SaveButton:Disable()
        self.Error:SetText(abt.err1)
      else
      end
    end
    -- if no spell name was provided, show an error mesage
    if newValue == '' then
      abt.CreateFrame.SaveButton:Disable()
      self.Error:SetText(abt.err2)
    end
    abt.CreateFrame:UpdateExampleButton()
  end)

  self.SpellnameEdit.Error = self.SpellnameEdit:CreateFontString(nil, nil)
  self.SpellnameEdit.Error:SetPoint('CENTER', self.SpellnameEdit, 'CENTER', 0, 5)
  self.SpellnameEdit.Error:SetFontObject(GameFontNormal)
  self.SpellnameEdit.Error:SetTextColor(1, 0, 0)
  self.SpellnameEdit.Error:SetText('')


  -- Checkbox for additional tooltip search
  self.SearchTooltipCheckbox = CreateFrame('CheckButton', 'ABT_SearchTooltipCheckbox', self, 'UICheckButtonTemplate')
  _G[self.SearchTooltipCheckbox:GetName()..'Text']:SetText(abt.searchtt)
  self.SearchTooltipCheckbox:SetPoint('TOPLEFT', self.SpellnameEdit, 'TOPRIGHT', 0, 0)


  self.SecondStepTitle = self:CreateFontString(nil, nil, 'GameFontNormalLarge')
  self.SecondStepTitle:SetPoint('TOPLEFT', self.SpellnameEdit, 'BOTTOMLEFT', 0, 0)
  self.SecondStepTitle:SetText(abt.hint2)



  -- Slider for showing damage/heal or miss (block/parry,dodge)
  self.ShowDamageSlider = CreateFrame('Slider', 'ABT_ShowDamageSlider', self, 'OptionsSliderTemplate')
  self.ShowDamageSlider:SetWidth(90)
  self.ShowDamageSlider:SetMinMaxValues(0, 1)
  self.ShowDamageSlider:SetValueStep(1)
  _G[self.ShowDamageSlider:GetName() .. 'Text']:SetText(abt.showdmg)
  _G[self.ShowDamageSlider:GetName() .. 'Low']:SetText('No')
  _G[self.ShowDamageSlider:GetName() .. 'High']:SetText('Yes')
  self.ShowDamageSlider:SetPoint('TOPLEFT', self.SpellnameEdit, 'BOTTOMLEFT', 0, -35)
  self.ShowDamageSlider:SetScript('OnValueChanged', function() self:UpdateExampleButton() end)


  self.ShowCastsUntilOOMSlider = CreateFrame('Slider', 'ABT_ShowCastsUntilOOMSlider', self, 'OptionsSliderTemplate')
  self.ShowCastsUntilOOMSlider:SetWidth(130)
  self.ShowCastsUntilOOMSlider:SetMinMaxValues(-1, 9)
  self.ShowCastsUntilOOMSlider:SetValueStep(1)
  _G[self.ShowCastsUntilOOMSlider:GetName() .. 'Text']:SetText(abt.ctoom)
  _G[self.ShowCastsUntilOOMSlider:GetName() .. 'Low']:SetText('')
  _G[self.ShowCastsUntilOOMSlider:GetName() .. 'High']:SetText('')
  self.ShowCastsUntilOOMSlider:SetPoint('TOPLEFT', self.ShowDamageSlider, 'TOPRIGHT', 20, 0)
  self.ShowCastsUntilOOMSlider:SetScript('OnValueChanged', function(self)
    local val, text = self:GetValue(), ''
    if val == -1 then
      text = 'No'
    elseif val == 0 then
      text = 'Yes'
    else
      text = 'when '..val..' or less'
    end
    self.Text:SetText(text)
    abt.CreateFrame:UpdateExampleButton()
  end)
  -- disable this slider if not applicable for the player class
  if string.find('WARRIOR:ROGUE', playerClass) then
    self.ShowCastsUntilOOMSlider:EnableMouse(false)
    self.ShowCastsUntilOOMSlider:SetAlpha(0.3)
  end

  self.ShowCastsUntilOOMSlider.Text = self.ShowCastsUntilOOMSlider:CreateFontString(nil, nil)
  self.ShowCastsUntilOOMSlider.Text:SetPoint('CENTER', self.ShowCastsUntilOOMSlider, 'CENTER', 0, -10)
  self.ShowCastsUntilOOMSlider.Text:SetFontObject(GameFontNormalSmall)


  self.ShowComboPointsSlider = CreateFrame('Slider', 'ABT_ShowComboPointsSlider', self, 'OptionsSliderTemplate')
  self.ShowComboPointsSlider:SetWidth(90)
  self.ShowComboPointsSlider:SetMinMaxValues(1, #abt.ShowComboPointsValues)
  self.ShowComboPointsSlider:SetValueStep(1)
  _G[self.ShowComboPointsSlider:GetName() .. 'Text']:SetText(abt.con8)
  _G[self.ShowComboPointsSlider:GetName() .. 'Low']:SetText('')
  _G[self.ShowComboPointsSlider:GetName() .. 'High']:SetText('')
  self.ShowComboPointsSlider:SetPoint('TOPLEFT', self.ShowCastsUntilOOMSlider, 'TOPRIGHT', 20, 0)
  self.ShowComboPointsSlider:SetScript('OnValueChanged', function(self)
    local value = self:GetValue()
    if abt.ShowComboPointsValues[value] then
      self.Text:SetText(abt.ShowComboPointsValues[value])
    end
    abt.CreateFrame:UpdateExampleButton()
  end)
  if not string.find('DRUID:ROGUE', playerClass) then
    self.ShowComboPointsSlider:EnableMouse(false)
    self.ShowComboPointsSlider:SetAlpha(0.3)
  end

  self.ShowComboPointsSlider.Text = self.ShowComboPointsSlider:CreateFontString(nil, nil)
  self.ShowComboPointsSlider.Text:SetPoint('CENTER', self.ShowComboPointsSlider, 'CENTER', 0, -10)
  self.ShowComboPointsSlider.Text:SetFontObject(GameFontNormalSmall)


  self.ShowEnergyDeficitSlider = CreateFrame('Slider', 'ABT_ShowEnergyDeficitSlider', self, 'OptionsSliderTemplate')
  self.ShowEnergyDeficitSlider:SetWidth(110)
  self.ShowEnergyDeficitSlider:SetMinMaxValues(1, #abt.ShowEnergyDeficitValues)
  self.ShowEnergyDeficitSlider:SetValueStep(1)
  _G[self.ShowEnergyDeficitSlider:GetName() .. 'Text']:SetText(abt.edef)
  _G[self.ShowEnergyDeficitSlider:GetName() .. 'Low']:SetText('')
  _G[self.ShowEnergyDeficitSlider:GetName() .. 'High']:SetText('')
  self.ShowEnergyDeficitSlider:SetPoint('TOPLEFT', self.ShowDamageSlider, 'BOTTOMLEFT', 0, -30)
  self.ShowEnergyDeficitSlider:SetScript('OnValueChanged', function(self)
    local value = self:GetValue()
    if abt.ShowEnergyDeficitValues[value] then
      self.Text:SetText(abt.ShowEnergyDeficitValues[value])
    end
    abt.CreateFrame:UpdateExampleButton()
  end)

  self.ShowEnergyDeficitSlider.Text = self.ShowEnergyDeficitSlider:CreateFontString(nil, nil)
  self.ShowEnergyDeficitSlider.Text:SetPoint('CENTER', self.ShowEnergyDeficitSlider, 'CENTER', 0, -10)
  self.ShowEnergyDeficitSlider.Text:SetFontObject(GameFontNormalSmall)
  if not string.find('DRUID:ROGUE', playerClass) then
    self.ShowEnergyDeficitSlider:EnableMouse(false)
    self.ShowEnergyDeficitSlider:SetAlpha(0.3)
  end



  self.ThirdStepTitle = self:CreateFontString(nil, nil, 'GameFontNormalLarge')
  self.ThirdStepTitle:SetPoint('TOPLEFT', self.ShowEnergyDeficitSlider, 'BOTTOMLEFT', 0, -12)
  self.ThirdStepTitle:SetText(abt.hint3)


  self.BuffnameEdit = CreateFrame('Editbox', 'ABT_BuffnameEdit' , self, 'InputBoxTemplate')
  self.BuffnameEdit:SetAutoFocus(false)
  self.BuffnameEdit:SetWidth(150)
  self.BuffnameEdit:SetHeight(32)
  self.BuffnameEdit:SetFontObject(GameFontHighlightSmall)
  self.BuffnameEdit:SetPoint('TOPLEFT', self.ShowEnergyDeficitSlider, 'BOTTOMLEFT', 0, -40)
  subscribe(self.BuffnameEdit, 'OnTextChanged', function(self)
    self:SetText(strupper(self:GetText()))
  end)

  self.BuffnameEdit.Text = self.BuffnameEdit:CreateFontString(nil, nil)
  self.BuffnameEdit.Text:SetPoint('BOTTOMLEFT', self.BuffnameEdit, 'TOPLEFT', 0, -5)
  self.BuffnameEdit.Text:SetFontObject(GameFontNormalSmall)
  self.BuffnameEdit.Text:SetText(abt.con2)


  self.IsDebuffCheckbox = CreateFrame('CheckButton', 'ABT_IsDebuffCheckbox' , self, 'UICheckButtonTemplate')
  _G[self.IsDebuffCheckbox:GetName() .. 'Text']:SetText(abt.con4)
  self.IsDebuffCheckbox:SetPoint('TOPLEFT', self.BuffnameEdit, 'TOPRIGHT', 0, 0)


  self.UnitWatchSlider = CreateFrame('Slider', 'ABT_UnitWatchSlider', self, 'OptionsSliderTemplate')
  self.UnitWatchSlider:SetWidth(80)
  self.UnitWatchSlider:SetMinMaxValues(1, #abt.UnitWatchValues)
  self.UnitWatchSlider:SetValueStep(1)
  _G[self.UnitWatchSlider:GetName() .. 'Text']:SetText('')
  _G[self.UnitWatchSlider:GetName() .. 'Low']:SetText('')
  _G[self.UnitWatchSlider:GetName() .. 'High']:SetText('')
  self.UnitWatchSlider:SetPoint('TOPLEFT', self.IsDebuffCheckbox, 'BOTTOMLEFT', 0, 0)
  self.UnitWatchSlider:SetScript('OnValueChanged', function(self)
    local value = self:GetValue()
    if abt.UnitWatchValues[value] then
      self.Text:SetText(abt.UnitWatchValues[value])
    end
  end)

  self.UnitWatchSlider.Text = self.UnitWatchSlider:CreateFontString(nil, nil)
  self.UnitWatchSlider.Text:SetPoint('CENTER', self.UnitWatchSlider, 'CENTER', 0, -10)
  self.UnitWatchSlider.Text:SetFontObject(GameFontNormalSmall)


  self.HideTimeCheckbox = CreateFrame('CheckButton', 'ABT_HideTimeCheckbox', self, 'UICheckButtonTemplate')
  _G[self.HideTimeCheckbox:GetName() .. 'Text']:SetText(abt.con5)
  self.HideTimeCheckbox:SetPoint('LEFT', _G[self.IsDebuffCheckbox:GetName() .. 'Text'], 'RIGHT', 10, 0)
  self.HideTimeCheckbox:SetScript('OnClick', function() self:UpdateExampleButton() end)


  self.ShowStacksCheckbox = CreateFrame('CheckButton', 'ABT_ShowStacksCheckbox', self, 'UICheckButtonTemplate')
  _G[self.ShowStacksCheckbox:GetName() .. 'Text']:SetText(abt.con6)
  self.ShowStacksCheckbox:SetPoint('TOPLEFT', self.HideTimeCheckbox, 'BOTTOMLEFT', 0, 0)
  self.ShowStacksCheckbox:SetScript('OnClick', function() self:UpdateExampleButton() end)



  self.FourthStepTitle = self:CreateFontString(nil, nil, 'GameFontNormalLarge')
  self.FourthStepTitle:SetPoint('TOPLEFT', self.BuffnameEdit, 'BOTTOMLEFT', 0, -40)
  self.FourthStepTitle:SetText(abt.hint4)


  self.ButtonTextPositionSlider = CreateFrame('Slider', 'ABT_ButtonTextPositionSlider', self, 'OptionsSliderTemplate')
  self.ButtonTextPositionSlider:SetWidth(60)
  self.ButtonTextPositionSlider:SetMinMaxValues(1, #abt.ButtonTextPositionValues)
  self.ButtonTextPositionSlider:SetValueStep(1)
  _G[self.ButtonTextPositionSlider:GetName() .. 'Text']:SetText(abt.spos)
  _G[self.ButtonTextPositionSlider:GetName() .. 'Low']:SetText('')
  _G[self.ButtonTextPositionSlider:GetName() .. 'High']:SetText('')
  self.ButtonTextPositionSlider:SetPoint('TOPLEFT', self.BuffnameEdit, 'BOTTOMLEFT', 0, -75)
  self.ButtonTextPositionSlider:SetScript('OnValueChanged', function(self)
    local value = self:GetValue()
    if abt.ButtonTextPositionValues[value] then
      self.Text:SetText(abt.ButtonTextPositionValues[value])
      abt.CreateFrame:UpdateExampleButton()
    end
  end)

  self.ButtonTextPositionSlider.Text = self.ButtonTextPositionSlider:CreateFontString(nil, nil)
  self.ButtonTextPositionSlider.Text:SetPoint('CENTER', self.ButtonTextPositionSlider, 'CENTER', 0, -10)
  self.ButtonTextPositionSlider.Text:SetFontObject(GameFontNormalSmall)


  self.ButtonTextSizeSlider = CreateFrame('Slider', 'ABT_ButtonTextSizeSlider', self, 'OptionsSliderTemplate')
  self.ButtonTextSizeSlider:SetWidth(70)
  self.ButtonTextSizeSlider:SetMinMaxValues(8, 26)
  self.ButtonTextSizeSlider:SetValueStep(1)
  _G[self.ButtonTextSizeSlider:GetName() .. 'Text']:SetText(abt.fontsize)
  _G[self.ButtonTextSizeSlider:GetName() .. 'Low']:SetText('8')
  _G[self.ButtonTextSizeSlider:GetName() .. 'High']:SetText('26')
  self.ButtonTextSizeSlider:SetPoint('TOPLEFT', self.ButtonTextPositionSlider, 'TOPRIGHT', 20, 0)
  self.ButtonTextSizeSlider:SetScript('OnValueChanged', function(self)
    self.Text:SetText(self:GetValue())
    abt.CreateFrame:UpdateExampleButton()
  end)

  self.ButtonTextSizeSlider.Text = self.ButtonTextSizeSlider:CreateFontString(nil, nil)
  self.ButtonTextSizeSlider.Text:SetPoint('CENTER', self.ButtonTextSizeSlider, 'CENTER', 0, -20)
  self.ButtonTextSizeSlider.Text:SetFontObject(GameFontNormalSmall)


  self.ButtonTextStyleSlider = CreateFrame('Slider', 'ABT_ButtonTextStyleSlider', self, 'OptionsSliderTemplate')
  self.ButtonTextStyleSlider:SetWidth(80)
  self.ButtonTextStyleSlider:SetMinMaxValues(1, #abt.ButtonTextStyleValues)
  self.ButtonTextStyleSlider:SetValueStep(1)
  _G[self.ButtonTextStyleSlider:GetName() .. 'Text']:SetText(abt.fontstyle)
  _G[self.ButtonTextStyleSlider:GetName() .. 'Low']:SetText('')
  _G[self.ButtonTextStyleSlider:GetName() .. 'High']:SetText('')
  self.ButtonTextStyleSlider:SetPoint('TOPLEFT', self.ButtonTextSizeSlider, 'TOPRIGHT', 20, 0)
  self.ButtonTextStyleSlider:SetScript('OnValueChanged', function(self)
    local value = self:GetValue()
    if abt.ButtonTextStyleValues[value] then
      self.Text:SetText(abt.ButtonTextStyleValues[value])
      abt.CreateFrame:UpdateExampleButton()
    end
  end)

  self.ButtonTextStyleSlider.Text = self.ButtonTextStyleSlider:CreateFontString(nil, nil)
  self.ButtonTextStyleSlider.Text:SetPoint('CENTER', self.ButtonTextStyleSlider, 'CENTER', 0, -20)
  self.ButtonTextStyleSlider.Text:SetFontObject(GameFontNormalSmall)


  self.ButtonTextColorPicker = CreateFrame('Button', 'ABT_ButtonTextColorPicker', self)
  self.ButtonTextColorPicker:SetPoint('TOPLEFT', self.ButtonTextStyleSlider, 'TOPRIGHT', 12, 0)
  self.ButtonTextColorPicker:SetWidth(20)
  self.ButtonTextColorPicker:SetHeight(20)
  self.ButtonTextColorPicker.Background = self.ButtonTextColorPicker:CreateTexture(nil, nil)
  self.ButtonTextColorPicker.Background:SetWidth(20)
  self.ButtonTextColorPicker.Background:SetHeight(20)
  self.ButtonTextColorPicker.Background:SetPoint('CENTER')
  subscribe(self.ButtonTextColorPicker, 'OnClick', function(self)
    ColorPickerFrame.func = function()
      local r, g, b = ColorPickerFrame:GetColorRGB()
      self.FontColor = { r, g, b }
      self.Background:SetTexture(unpack(self.FontColor))
      abt.CreateFrame:UpdateExampleButton()
    end

    ColorPickerFrame.cancelFunc = function()
      local r, g, b = unpack(ColorPickerFrame.PreviousColors)
      self.FontColor = {r, g, b}
      self.Background:SetTexture(unpack(self.FontColor))
      abt.CreateFrame:UpdateExampleButton()
    end

    ColorPickerFrame.PreviousColors = self.FontColor
    ColorPickerFrame:SetColorRGB(unpack(ColorPickerFrame.PreviousColors))
    ColorPickerFrame.opacity = 1
    ColorPickerFrame:Show()
  end)


  self.PreviewButton = CreateFrame('CheckButton', 'ABT_PreviewButton', self, 'ActionButtonTemplate')
  SetSize(self.PreviewButton, 36, 36)
  self.PreviewButton:Disable()
  self.PreviewButton:SetPoint('LEFT', self.ButtonTextSizeSlider, 'RIGHT', 150, 0)


  self.SaveButton = CreateFrame('Button', 'ABT_SaveButton', self, 'UIPanelButtonTemplate')
  self.SaveButton:SetWidth(120)
  self.SaveButton:SetHeight(20)
  self.SaveButton:SetPoint('TOPLEFT', self.ButtonTextPositionSlider, 'BOTTOMLEFT', 0, -50)
  self.SaveButton:SetText(abt.con9)
  self.SaveButton:SetScript('OnClick', function(self)
    local frame = abt.CreateFrame
    -- actually save things in here
    local from, to = frame.SelectedPreset, frame.SpellnameEdit:GetText()
    if from ~= to then
      if not ABT_SpellDB then
        ABT_SpellDB = {}
      end
      ABT_SpellDB[to] = {}
      if from then
        for val in pairs(ABT_SpellDB[from]) do
          ABT_SpellDB[to][val] = ABT_SpellDB[from][val]
        end
        ABT_SpellDB[from] = nil
      end
    end

    ABT_SpellDB[to] = {
      SEARCHTT  = FalseToNil(frame.SearchTooltipCheckbox:GetChecked()),
      SHOWDMG   = NilIf(frame.ShowDamageSlider:GetValue(), 0),
      Buff      = BlankToNil(frame.BuffnameEdit:GetText()),
      TARGET    = NilIf(frame.UnitWatchSlider:GetValue(), 1),
      Debuff    = FalseToNil(frame.IsDebuffCheckbox:GetChecked()),
      NoTime    = FalseToNil(frame.HideTimeCheckbox:GetChecked()),
      Stack     = FalseToNil(frame.ShowStacksCheckbox:GetChecked()),
      SPOS      = NilIf(frame.ButtonTextPositionSlider:GetValue(), 1),
      FONTSIZE  = NilIf(frame.ButtonTextSizeSlider:GetValue(), 11),
      FONTSTYLE = NilIf(frame.ButtonTextStyleSlider:GetValue(), 1),
      CP        = NilIf(frame.ShowComboPointsSlider:GetValue(), 1),
      EDEF      = NilIf(frame.ShowEnergyDeficitSlider:GetValue(), 1),
      CTOOM     = NilIf(frame.ShowCastsUntilOOMSlider:GetValue(), -1)
    }
    ABT_SpellDB[to]['FONTCOLR'], ABT_SpellDB[to]['FONTCOLG'], ABT_SpellDB[to]['FONTCOLB'] = unpack(frame.ButtonTextColorPicker.FontColor)
    frame.CancelButton:Click()
  end)


  self.DeleteButton = CreateFrame('Button', 'ABT_DeleteButton', self, 'UIPanelButtonTemplate')
  self.DeleteButton:SetWidth(100)
  self.DeleteButton:SetHeight(20)
  self.DeleteButton:SetText(abt.del1)
  self.DeleteButton:SetPoint('LEFT', self.SaveButton, 'RIGHT', 0, 0)
  self.DeleteButton:SetScript('OnClick', function(self)
    local buttonText = self:GetText()
    if buttonText == abt.del1 then
      self:SetText(abt.del2)
    elseif buttonText == abt.del2 then
      self:SetText(abt.del3)
    elseif buttonText == abt.del3 then
      -- actually delete things in here
      ABT_SpellDB[abt.CreateFrame.SelectedPreset] = nil
      abt.CreateFrame.CancelButton:Click()
    end
  end)


  self.CancelButton = CreateFrame('Button', 'ABT_CancelButton', self, 'UIPanelButtonTemplate')
  self.CancelButton:SetWidth(130)
  self.CancelButton:SetHeight(20)
  self.CancelButton:SetPoint('LEFT', self.DeleteButton, 'RIGHT', 0, 0)
  self.CancelButton:SetText(abt.con10)
  self.CancelButton:SetScript('OnClick', function()
    UIDropDownMenu_ClearAll(abt.PresetsFrame.PresetsDropdown)
    InterfaceOptionsFrame_OpenToFrame(abt.PresetsFrame.name)
  end)
end

function abt.CreateFrame:RegisterHelpTooltips()
  for _, formElement in ipairs({self:GetChildren()}) do
    if (abt.tips[formElement:GetName()]) then
      subscribe(formElement, 'OnEnter', function(self)
        GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT')
        GameTooltip:ClearLines()
        GameTooltip:SetText(abt.tips[self:GetName()])
        GameTooltip:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 10, 10)
        GameTooltip:Show()
      end)
      subscribe(formElement, 'OnLeave', function()
        GameTooltip:Hide()
      end)
    end
  end
end

function abt.CreateFrame:SpellnameChange()
end

function abt.CreateFrame:GetSpellTexture()
  if (self:CheckSpellnameValidity()) then
    local filtered = self.SpellnameEdit:GetFilteredText()
    return select(3, GetSpellInfo(filtered))
  end
  local actionSlot = 1
  if string.find('WARRIOR:DRUID:ROGUE:PRIEST', playerClass) then
    -- a few classes have different 'first' action slots (http://www.wowwiki.com/ActionSlot)
    actionSlot = 73
  end
  return GetActionTexture(actionSlot)
end

function abt.CreateFrame:CheckSpellnameValidity()
  local filtered = self.SpellnameEdit:GetFilteredText()
  local name = GetSpellInfo(filtered)
  return name and name ~= ''
end

function abt.CreateFrame:UpdateValues()
  self.SpellnameEdit:SetText(self.SelectedPreset or '')
  self.SearchTooltipCheckbox:SetChecked(self.SelectedPresetValues['SEARCHTT'] or false)
  self.ShowDamageSlider:SetValue(self.SelectedPresetValues['SHOWDMG'] or 0)
  self.ShowCastsUntilOOMSlider:SetValue(self.SelectedPresetValues['CTOOM'] or -1)
  self.ShowComboPointsSlider:SetValue(self.SelectedPresetValues['CP'] or 1)
  self.ShowEnergyDeficitSlider:SetValue(self.SelectedPresetValues['EDEF'] or 1)
  self.BuffnameEdit:SetText(self.SelectedPresetValues['Buff'] or '')
  self.IsDebuffCheckbox:SetChecked(self.SelectedPresetValues['Debuff'] or false)
  self.UnitWatchSlider:SetValue(self.SelectedPresetValues['TARGET'] or 1)
  self.HideTimeCheckbox:SetChecked(self.SelectedPresetValues['NoTime'] or false)
  self.ShowStacksCheckbox:SetChecked(self.SelectedPresetValues['Stack'] or false)
  self.ButtonTextPositionSlider:SetValue(self.SelectedPresetValues['SPOS'] or 1)
  self.ButtonTextSizeSlider:SetValue(self.SelectedPresetValues['FONTSIZE'] or 11)
  self.ButtonTextStyleSlider:SetValue(self.SelectedPresetValues['FONTSTYLE'] or 0)
  self.ButtonTextColorPicker.FontColor = {
    self.SelectedPresetValues['FONTCOLR'] or 0,
    self.SelectedPresetValues['FONTCOLG'] or 1,
    self.SelectedPresetValues['FONTCOLB'] or 0
  }
  self.ButtonTextColorPicker.Background:SetTexture(unpack(self.ButtonTextColorPicker.FontColor))

  self.DeleteButton:SetText(abt.del1)
  self.DeleteButton:Enable()
  if not self.SelectedPreset then
    self.DeleteButton:Disable()
  end
end

function abt.CreateFrame:UpdateExampleButton()
  if not self.Initialized then return end

  self.PreviewButton:SetDisabledTexture(self:GetSpellTexture())

  abt.ClearText(self.PreviewButton)

  local size = self.ButtonTextSizeSlider:GetValue()
  local position = self.ButtonTextPositionSlider:GetValue()
  local r, g, b = unpack(self.ButtonTextColorPicker.FontColor)
  local style = self.ButtonTextStyleSlider:GetValue()

  local example = ''

  if not self.HideTimeCheckbox:GetChecked() then
    example = '9m'
  end

  if self.ShowDamageSlider:GetValue() == 1 then
    example = abt.NeedSlash(example, 'DDDD')
  end

  if self.ShowStacksCheckbox:GetChecked() then
    example = abt.NeedSlash(example, 'S')
  end

  if self.ShowCastsUntilOOMSlider:GetValue() >= 0 then
    example = abt.NeedSlash(example, 'CC')
  end

  if self.ShowComboPointsSlider:GetValue() > 1 then
    example = abt.NeedSlash(example, 'P')
  end

  if self.ShowEnergyDeficitSlider:GetValue() > 1 then
    example = abt.NeedSlash(example, 'E')
  end

  abt.SetText(self.PreviewButton, position, '|cff' .. string.format('%02x%02x%02x', r * 255, g * 255, b * 255) .. example .. '|r', size, abt.ButtonTextStyleValues[style])
end

function abt.CreateFrame:Refresh()
  self.SelectedPreset, self.SelectedPresetValues = nil, {}
  local selectedPreset = UIDropDownMenu_GetSelectedValue(abt.PresetsFrame.PresetsDropdown)
  if selectedPreset and selectedPreset ~= abt.newEntryValue then
    self.SelectedPreset = selectedPreset
    self.SelectedPresetValues = ABT_SpellDB[selectedPreset]
  end
  self:UpdateValues()
  self:UpdateExampleButton()
end

function abt.CreateFrame:Init()
  self.Initialized = false
  self.Title = self:CreateFontString(nil, nil, 'GameFontNormalLarge')
  self.Title:SetPoint('TOPLEFT', 16, -16)
  self.Title:SetText(abt.hint1)
  if not abt.PresetsFrame.PresetsDropdown then
    abt.PresetsFrame:Init()
  end
  self:CreateForm()
  self:RegisterHelpTooltips()
  self:Refresh()
  self.Initialized = true
end

abt.CreateFrame:SetScript('OnShow', function(self)
  self:Init()
  self:SetScript('OnShow', function(self)
    self:Refresh()
  end)
end)

InterfaceOptions_AddCategory(abt.CreateFrame)