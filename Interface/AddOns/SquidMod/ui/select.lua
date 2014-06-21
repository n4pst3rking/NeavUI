local ns = SquidMod
local selectFrame = CreateFrame('Frame', 'SquidModSelectFrame', InterfaceOptionsFramePanelContainer)
selectFrame:Hide()
selectFrame.name = 'SquidMod'
selectFrame.default = function(frame)
  frame.Slider:SetValue(ns.GetDefault())
end

function selectFrame:CreateForm()
  self.Slider = CreateFrame('Slider', 'SquidMod_SelectSlider', self, 'OptionsSliderTemplate')
  self.Slider:SetWidth(270)
  self.Slider:SetMinMaxValues(1, #ns.textures)
  self.Slider:SetValueStep(1)
  _G[self.Slider:GetName() .. 'Text']:SetText('Texture')
  _G[self.Slider:GetName() .. 'Low']:SetText('')
  _G[self.Slider:GetName() .. 'High']:SetText('')
  self.Slider:SetPoint('CENTER', self, 'CENTER', 0, 150)
  self.Slider:SetScript('OnValueChanged', function(self)
    local value = self:GetValue()
    if ns.textures[value] then
      self.Text:SetText(ns.textures[value])
      ns.LoadFrame:Update(value)
    end
  end)

  self.Slider.Text = self.Slider:CreateFontString(nil, nil)
  self.Slider.Text:SetPoint('CENTER', self.Slider, 'CENTER', 0, -10)
  self.Slider.Text:SetFontObject(GameFontNormalSmall)


  -- self.DefaultButton = CreateFrame('Button', 'SquidMod_DefaultButton', self, 'UIPanelButtonTemplate')
  -- self.DefaultButton:SetWidth(120)
  -- self.DefaultButton:SetHeight(20)
  -- self.DefaultButton:SetPoint('TOPLEFT', self.Slider, 'BOTTOMLEFT', 0, -50)
  -- self.DefaultButton:SetText('Default')
  -- self.DefaultButton:SetScript('OnClick', function(self)
  --   ns.SelectFrame.Slider:SetValue(ns.GetDefault())
  -- end)
end

function selectFrame:CreateDropdown()
  self.SelectDropdown = CreateFrame('Frame', 'SquidMod_SelectDropdown', self, 'UIDropDownMenuTemplate')
  self.SelectDropdown:SetPoint('TOPLEFT', self.Title, 'BOTTOMLEFT', 0, 0)

  self.SelectDropdown.Initialize = function()
    local DropdownEle_OnClick = function()
      UIDropDownMenu_SetSelectedValue(self.SelectDropdown, this.value)
      SquidModDB = this.value
      ns.LoadFrame:Update(SquidModDB)
    end

    local items = {}
    if ns.textures then
      for _, texture in pairs(ns.textures) do
        items.text = texture
        items.func = DropdownEle_OnClick
        items.value = _
        items.checked = _ == SquidModDB and true or false
        UIDropDownMenu_AddButton(items)
      end
      if SquidModDB then
        UIDropDownMenu_SetSelectedValue(self.SelectDropdown, SquidModDB)
      end
    end
  end

  UIDropDownMenu_SetWidth(180, self.SelectDropdown)
  UIDropDownMenu_JustifyText('LEFT', self.SelectDropdown)
end

function selectFrame:Refresh()
  self.Slider:SetValue(SquidModDB)
  -- UIDropDownMenu_Initialize(self.SelectDropdown, self.SelectDropdown.Initialize, 'MENU')
end

function selectFrame:Init()
  self.Title = self:CreateFontString(nil, nil, 'GameFontNormalLarge')
  self.Title:SetPoint('TOPLEFT', 16, -16)
  self.Title:SetText('SquidMod')
  self:CreateForm()
  self:Refresh()
end

selectFrame:SetScript('OnShow', function(self)
  self:Init()
  self:SetScript('OnShow', nil)
end)

InterfaceOptions_AddCategory(selectFrame)

ns.SelectFrame = selectFrame