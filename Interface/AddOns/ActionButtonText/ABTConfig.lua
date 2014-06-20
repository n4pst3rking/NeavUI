local abt = abtNS

local playerClass = select(2, UnitClass('player'))

local _G = _G

local gsub = string.gsub
local find = string.find

local GetSpellInfo = GetSpellInfo

local GetActionTexture = GetActionTexture

function abt:UpdateExample()
  _G['obiexample']:SetDisabledTexture(GetActionTexture(1))

  local spell = gsub(_G['obicon1']:GetText(), '(.*)#', '')
  if spell then
    local _, _, texture = GetSpellInfo(spell)

    if texture then
      _G['obiexample']:SetDisabledTexture(texture)
    end
  end

  if _G['obifontsize']:GetValue() > 0 then
    local example = ''

    if _G['obicon5']:GetChecked() then
    else
      example = '9m'
    end

    if _G['obishowdmg']:GetValue() == 1 then
      example = abt.NeedSlash(example,'DDDD')
    end

    if _G['obicon6']:GetChecked() then
      example = abt.NeedSlash(example,'S')
    end

    if _G['obictoom']:GetValue() >= 0 then
      example = abt.NeedSlash(example,'CC')
    end

    if _G['obicon8']:GetValue() > 0 then
      example = abt.NeedSlash(example,'P')
    end

    if _G['obiedef']:GetValue() > 0 then
      example = abt.NeedSlash(example,'E')
    end

    abt.ClearText(_G['obiexample'])
    abt.SetText(_G['obiexample'],_G['obispos']:GetValue(),'|cff' .. string.format('%02x%02x%02x',(_G['obifontcolor'].fontr or 0) * 255,(_G['obifontcolor'].fontg or 0) * 255,(_G['obifontcolor'].fontb or 2) * 255) .. example .. '|r',_G['obifontsize']:GetValue(),abt.fontStyleValues[_G['obifontstyle']:GetValue()])
  end
end

local function Dropdown_OnShow()
  UIDropDownMenu_SetWidth(180, this)
  UIDropDownMenu_JustifyText('LEFT', this)
  _G[this:GetName()..'Text']:SetText(' ')
  UIDropDownMenu_Initialize(this, this.Initialize)
end

local function BlankToNil(val)
  if not val or find(val,'^ *$') then -- string is either '' or all spaces
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

local function NilIf(val,limit)
  if val == limit then
    return nil
  else
    return val
  end
end

local function NewSpellClick()
  _G['obicon0'].value = nil
  --_G['obipresets']:Show()
  _G['obicon1']:SetText('')
  _G['obisearchtt']:SetChecked(false)
  _G['obishowdmg']:SetValue(0)
  _G['obicon2']:SetText('')
  _G['obitarget']:SetValue(1)
  _G['obicon4']:SetChecked(false)
  _G['obinotmine']:SetChecked(false)
  _G['obicon5']:SetChecked(false)
  _G['obicon6']:SetChecked(false)
  _G['obicon8']:SetValue(0)
  _G['obicon9']:Disable()
  _G['obicon11']:Hide()
  _G['obiedef']:SetValue(0)
  _G['obictoom']:SetValue(-1)
  _G['obispos']:SetValue(1)
  _G['obifontsize']:SetValue(11)
  _G['obifontstyle']:SetValue(1)
  _G['obifontcolor'].fontr = 0
  _G['obifontcolor'].fontg = 1
  _G['obifontcolor'].fontb = 0
  _G['obifontcolor'].bg:SetTexture(_G['obifontcolor'].fontr,_G['obifontcolor'].fontg,_G['obifontcolor'].fontb)
  abt:UpdateExample()
  _G['obicon0']:Hide()
  _G['obicon1']:Show()
end
abt.newspell_click = NewSpellClick

function abt.ConfigInit()
  abt.configpanel = CreateFrame('Frame', 'OBIConfig', UIParent)
  abt.configpanel:SetWidth(608)
  abt.configpanel:SetHeight(440)
  abt.configpanel:SetPoint('CENTER')

  local spelldd = CreateFrame('Frame', 'obicon0' , abt.configpanel, 'UIDropDownMenuTemplate')
  local text = spelldd:CreateFontString(nil, 'BACKGROUND')
  text:SetPoint('BOTTOMLEFT', spelldd, 'TOPLEFT', 21, 0)
  text:SetFontObject('GameFontNormalSmall')
  text:SetText(abt.con0)
  spelldd:SetScript('OnShow', Dropdown_OnShow)
  spelldd:SetPoint('TOPLEFT', 25, -100)
  function spelldd.Initialize()
    local function Button_OnClick()
      UIDropDownMenu_SetSelectedValue(spelldd, this.value)
      spelldd.value = this.value
      --_G['obipresets']:Hide()
      _G['obicon1']:SetText(this.value or ' ')
      _G['obisearchtt']:SetChecked(ABT_SpellDB[this.value]['SEARCHTT'] or false)
      _G['obishowdmg']:SetValue(ABT_SpellDB[this.value]['SHOWDMG'] or 0)
      _G['obicon2']:SetText(ABT_SpellDB[this.value]['Buff'] or ' ')
      _G['obitarget']:SetValue(ABT_SpellDB[this.value]['TARGET'] or 1)
      _G['obicon4']:SetChecked(ABT_SpellDB[this.value]['Debuff'] or false)
      _G['obinotmine']:SetChecked(ABT_SpellDB[this.value]['NOTMINE'] or false)
      _G['obicon5']:SetChecked(ABT_SpellDB[this.value]['NoTime'] or false)
      _G['obicon6']:SetChecked(ABT_SpellDB[this.value]['Stack'] or false)
      _G['obicon8']:SetValue(ABT_SpellDB[this.value]['CP'] or 0)
      _G['obiedef']:SetValue(ABT_SpellDB[this.value]['EDEF'] or 0)
      _G['obictoom']:SetValue(ABT_SpellDB[this.value]['CTOOM'] or -1)
      _G['obicon11']:SetText(abt.del1)
      _G['obicon11']:Show()
      _G['obispos']:SetValue(ABT_SpellDB[this.value]['SPOS'] or 1)
      _G['obifontsize']:SetValue(ABT_SpellDB[this.value]['FONTSIZE'] or 11)
      _G['obifontstyle']:SetValue(ABT_SpellDB[this.value]['FONTSTYLE'] or 1)
      _G['obifontcolor'].fontr = ABT_SpellDB[this.value]['FONTCOLR'] or 0
      _G['obifontcolor'].fontg = ABT_SpellDB[this.value]['FONTCOLG'] or 1
      _G['obifontcolor'].fontb = ABT_SpellDB[this.value]['FONTCOLB'] or 0
      _G['obifontcolor'].bg:SetTexture(_G['obifontcolor'].fontr,_G['obifontcolor'].fontg,_G['obifontcolor'].fontb)
      abt:UpdateExample()
      _G['obicon0']:Hide()
      _G['obicon1']:Show()
    end
    local items = {}
    if ABT_SpellDB then
      for spell in pairs(ABT_SpellDB) do
        items.text = spell
        items.func = Button_OnClick
        items.value = spell
        items.checked = false
        UIDropDownMenu_AddButton(items)
      end
    end
    items.text = 'New ActionButtonText'
    items.func = NewSpellClick
    items.value = 'New ActionButtonText'
    items.checked = false
    UIDropDownMenu_AddButton(items)
  end

  local about = CreateFrame('SimpleHTML','obiconfigtext',spelldd)
  about:SetFontObject('P' ,GameFontHighlightSmall)
  about:SetFontObject('H1',GameFontHighlightLarge)
  about:SetFontObject('H2',GameFontHighlight)
  about:SetPoint('TOPLEFT',spelldd,'BOTTOMLEFT',25,-15)
  about:SetPoint('TOPRIGHT',abt.configpanel,'TOPRIGHT',-40,15)
  about:SetPoint('BOTTOM',abt.configpanel,'BOTTOM',-5)
  about:SetWidth(500)
  about:SetHeight(40)
  about:SetText(abt.configtext)
  about:Show()

  local function SpellChange()
    this:SetText(strupper(this:GetText()))
    _G['obicon9']:Enable()
    this.error:SetText('')
    newtext = this:GetText()
    if newtext ~= _G['obicon0'].value then
      if ABT_SpellDB and ABT_SpellDB[newtext] then
        _G['obicon9']:Disable()
        this.error:SetText(abt.err1)
      else
      end
    end
    if this:GetText() == '' then
      _G['obicon9']:Disable()
      this.error:SetText(abt.err2)
    end
    abt:UpdateExample()
  end

  local function ShowTip(self)
    local tooltip = GameTooltip
    tooltip:SetOwner(self, 'ANCHOR_TOPRIGHT') -- without this, tooltip can fail 'randomly'
    tooltip:ClearLines()
    tooltip:SetText(abt.tips[self:GetName()] or '')
    tooltip:SetPoint('BOTTOMLEFT', self, 'TOPLEFT',10,10)
    tooltip:Show()
  end

  local function HideTip()
    GameTooltip:Hide()
  end

  local spellnm = CreateFrame('Editbox', 'obicon1' , abt.configpanel,'InputBoxTemplate')
  spellnm:SetAutoFocus(nil)
  spellnm:SetWidth(180)
  spellnm:SetHeight(32)
  spellnm:SetFontObject('GameFontHighlightSmall')
  spellnm:SetPoint('TOPLEFT', spelldd, 'TOPLEFT', 21, -10)
  spellnm:SetScript('OnTextChanged',SpellChange)
  local text = spellnm:CreateFontString(nil, 'BACKGROUND')
  text:SetPoint('BOTTOMLEFT', spellnm, 'TOPLEFT', 0, -5)
  text:SetFontObject('GameFontNormalSmall')
  text:SetText(abt.con1)
  local text2 = spellnm:CreateFontString(nil, 'BACKGROUND')
  text2:SetPoint('TOPLEFT', spellnm, 'BOTTOMLEFT', 0, 5)
  text2:SetFontObject('GameFontNormal')
  text2:SetTextColor(1,0,0)
  text2:SetText('')
  spellnm.error = text2
  spellnm:Hide()

  local text = spellnm:CreateFontString(nil, 'BACKGROUND')
  text:SetPoint('TOPLEFT', spellnm, 'TOPLEFT', -20, 30)
  text:SetFont(GameFontNormal:GetFont(),16, 'OUTLINE')
  text:SetTextColor(0,1,0)
  text:SetText(abt.hint1)

  local searchtt = CreateFrame('CheckButton', 'obisearchtt' , spellnm ,'UICheckButtonTemplate')
  _G[searchtt:GetName() .. 'Text']:SetText(abt.searchtt)
  searchtt:SetPoint('TOPLEFT', spellnm, 'TOPRIGHT', 0,0)


  local presets = CreateFrame('Frame', 'obipresets' , spellnm, 'UIDropDownMenuTemplate')
  local text = presets:CreateFontString(nil, 'BACKGROUND')
  text:SetPoint('BOTTOMLEFT', presets, 'TOPLEFT', 21, 0)
  text:SetFontObject('GameFontNormalSmall')
  text:SetText(abt.choose)
  presets:SetScript('OnShow', Dropdown_OnShow)
  presets:SetPoint('TOPLEFT', spellnm, 'TOPRIGHT',130,0)
  presets:Hide()

  function presets.Initialize()
    local function Button_OnClick()
      UIDropDownMenu_SetSelectedValue(presets, this.value)
      presets.value = this.value
      spell = this.value
      preset = abt.examples[spell]
      _G['obicon1']:SetText(spell)
      _G['obisearchtt']:SetChecked(preset['SEARCHTT'] or false)
      _G['obishowdmg']:SetValue(preset['SHOWDMG'] or 0)
      _G['obicon2']:SetText(preset['Buff'] or ' ')
      _G['obitarget']:SetValue(preset['TARGET'] or 1)
      _G['obicon4']:SetChecked(preset['Debuff'] or false)
      _G['obinotmine']:SetChecked(preset['NOTMINE'] or false)
      _G['obicon5']:SetChecked(preset['NoTime'] or false)
      _G['obicon6']:SetChecked(preset['Stack'] or false)
      _G['obicon8']:SetValue(preset['CP'] or 0)
      _G['obiedef']:SetValue(preset['EDEF'] or 0)
      _G['obictoom']:SetValue(preset['CTOOM'] or -1)
      _G['obicon11']:SetText(abt.del1)
      _G['obifontsize']:SetValue(preset['FONTSIZE'] or 11)
      _G['obifontstyle']:SetValue(preset['FONTSTYLE'] or 1)
      _G['obifontcolor'].fontr = preset['FONTCOLR'] or 0
      _G['obifontcolor'].fontg = preset['FONTCOLG'] or 1
      _G['obifontcolor'].fontb = preset['FONTCOLB'] or 0
      _G['obifontcolor'].bg:SetTexture(_G['obifontcolor'].fontr,_G['obifontcolor'].fontg,_G['obifontcolor'].fontb)
      abt:UpdateExample()
    end
    local items = {}
    for spell in pairs(abt.examples) do
      _,_,items.text = string.find(spell,'(.*)#')
      items.func = Button_OnClick
      items.value = spell
      items.checked = false
      UIDropDownMenu_AddButton(items)
    end
  end

  local showdmg = CreateFrame('Slider','obishowdmg', spellnm,'OptionsSliderTemplate')
  showdmg:SetWidth(90)
  showdmg:SetMinMaxValues(0,1)
  showdmg:SetValueStep(1)
  _G[showdmg:GetName() .. 'Text']:SetText(abt.showdmg)
  _G[showdmg:GetName() .. 'Low']:SetText('No')
  _G[showdmg:GetName() .. 'High']:SetText('Yes')
  showdmg:SetPoint('TOPLEFT', spellnm, 'BOTTOMLEFT', 0, -50)
  showdmg:SetScript('OnValueChanged', function()
    abt:UpdateExample()
  end)

  relto = showdmg

  local text = showdmg:CreateFontString(nil, 'BACKGROUND')
  text:SetPoint('TOPLEFT', showdmg, 'TOPLEFT', -20, 35)
  text:SetFont(GameFontNormal:GetFont(),16, 'OUTLINE')
  text:SetTextColor(0,1,0)
  text:SetText(abt.hint2)

  local ctoom = CreateFrame('Slider','obictoom', spellnm,'OptionsSliderTemplate')
  ctoom:SetWidth(130)
  ctoom:SetMinMaxValues(-1,9)
  ctoom:SetValueStep(1)
  _G[ctoom:GetName() .. 'Text']:SetText(abt.ctoom)
  _G[ctoom:GetName() .. 'Low']:SetText('')
  _G[ctoom:GetName() .. 'High']:SetText('')
  ctoom:SetPoint('TOPLEFT', relto, 'TOPRIGHT', 20, 0)
  ctoom:SetScript('OnValueChanged', function()
    val = this:GetValue()
    txt = ''
    if val == -1 then
      txt = 'No'
    elseif val == 0 then
      txt = 'Yes'
    else
      txt = 'when ' .. val .. ' or less'
    end
    this.valtext:SetText(txt)
    abt:UpdateExample()
  end)

  local text = ctoom:CreateFontString(nil, 'BACKGROUND')
  text:SetPoint('CENTER', ctoom, 'CENTER', 0, -10)
  text:SetFontObject('GameFontNormalSmall')
  ctoom.valtext = text
  if string.find('WARRIOR:ROGUE', playerClass) then
    ctoom:Hide()
  else
    relto = ctoom
  end

  local function ComboChange()
    vals = abt.combovals
    if this:GetValue() then
      this.valtext:SetText(vals[this:GetValue()+1])
      abt:UpdateExample()
    end
  end

  local combop = CreateFrame('Slider','obicon8', spellnm,'OptionsSliderTemplate')
  combop:SetWidth(90)
  combop:SetMinMaxValues(0,2)
  combop:SetValueStep(1)
  _G[combop:GetName() .. 'Text']:SetText(abt.con8)
  _G[combop:GetName() .. 'Low']:SetText('')
  _G[combop:GetName() .. 'High']:SetText('')
  combop:SetPoint('TOPLEFT', relto, 'TOPRIGHT', 20, 0)
  combop:SetScript('OnValueChanged',ComboChange)
  local text = combop:CreateFontString(nil, 'BACKGROUND')
  text:SetPoint('CENTER', combop, 'CENTER', 0, -10)
  text:SetFontObject('GameFontNormalSmall')
  combop.valtext = text
  if not string.find('DRUID:ROGUE', playerClass) then
    combop:Hide()
  else
    relto = combop
  end

  local edef = CreateFrame('Slider','obiedef', spellnm,'OptionsSliderTemplate')
  edef:SetWidth(110)
  edef:SetMinMaxValues(0,2)
  edef:SetValueStep(1)
  _G[edef:GetName() .. 'Text']:SetText(abt.edef)
  _G[edef:GetName() .. 'Low']:SetText('')
  _G[edef:GetName() .. 'High']:SetText('')
  edef:SetPoint('TOPLEFT', relto, 'TOPRIGHT', 20, 0)
  edef:SetScript('OnValueChanged', function()
    vals = abt.edefvals
    if this:GetValue() then
      this.valtext:SetText(vals[this:GetValue()+1])
      abt:UpdateExample()
    end
  end)

  local text = edef:CreateFontString(nil, 'BACKGROUND')
  text:SetPoint('CENTER', edef, 'CENTER', 0, -10)
  text:SetFontObject('GameFontNormalSmall')
  edef.valtext = text
  if not string.find('DRUID:ROGUE', playerClass) then
    edef:Hide()
  end


  local buffnm = CreateFrame('Editbox', 'obicon2' , spellnm,'InputBoxTemplate')
  buffnm:SetAutoFocus(nil)
  buffnm:SetWidth(200)
  buffnm:SetHeight(32)
  buffnm:SetFontObject('GameFontHighlightSmall')
  buffnm:SetPoint('TOPLEFT', showdmg, 'BOTTOMLEFT', 0, -55)
  buffnm:SetScript('OnTextChanged',function()
    this:SetText(strupper(this:GetText()))
  end)

  local text = buffnm:CreateFontString(nil, 'BACKGROUND')
  text:SetPoint('BOTTOMLEFT', buffnm, 'TOPLEFT', 0, -5)
  text:SetFontObject('GameFontNormalSmall')
  text:SetText(abt.con2)

  local text = showdmg:CreateFontString(nil, 'BACKGROUND')
  text:SetPoint('TOPLEFT', buffnm, 'TOPLEFT', -20, 30)
  text:SetFont(GameFontNormal:GetFont(),16, 'OUTLINE')
  text:SetTextColor(0,1,0)
  text:SetText(abt.hint3)

  local isdebuff = CreateFrame('CheckButton', 'obicon4' , spellnm,'UICheckButtonTemplate')
  _G[isdebuff:GetName() .. 'Text']:SetText(abt.con4)
  isdebuff:SetPoint('TOPLEFT', buffnm, 'TOPRIGHT', 0,0)

  local notmine = CreateFrame('CheckButton', 'obinotmine' , isdebuff,'UICheckButtonTemplate')
  _G[notmine:GetName() .. 'Text']:SetText(abt.notmine)
  notmine:SetPoint('LEFT', obicon4Text, 'RIGHT', 0,0)

  local target = CreateFrame('Slider','obitarget', spellnm,'OptionsSliderTemplate')
  target:SetWidth(80)
  target:SetMinMaxValues(1,3)
  target:SetValueStep(1)
  _G[target:GetName() .. 'Text']:SetText('')
  _G[target:GetName() .. 'Low']:SetText('')
  _G[target:GetName() .. 'High']:SetText('')
  target:SetPoint('TOPLEFT', notmine, 'TOPRIGHT', 60, 0)
  target:SetScript('OnValueChanged', function()
    vals = abt.targetValues
    if this:GetValue() then
      this.valtext:SetText(vals[this:GetValue()])
      abt:UpdateExample()
    end
  end)

  local text = target:CreateFontString(nil, 'BACKGROUND')
  text:SetPoint('CENTER', target, 'CENTER', 0, -10)
  text:SetFontObject('GameFontNormalSmall')
  target.valtext = text

  local notime = CreateFrame('CheckButton', 'obicon5' , spellnm, 'UICheckButtonTemplate')
  _G[notime:GetName() .. 'Text']:SetText(abt.con5)
  notime:SetPoint('TOPLEFT', isdebuff, 'BOTTOMLEFT', 0, 10)
  notime:SetScript('OnClick', function()
    abt:UpdateExample()
  end)

  local stack = CreateFrame('CheckButton', 'obicon6' , spellnm,'UICheckButtonTemplate')
  _G[stack:GetName() .. 'Text']:SetText(abt.con6)
  stack:SetPoint('TOPLEFT', notime, 'TOPRIGHT', 70 ,0)
  stack:SetScript('OnClick', function()
    abt:UpdateExample()
  end)

  local spos = CreateFrame('Slider','obispos', spellnm,'OptionsSliderTemplate')
  spos:SetWidth(70)
  spos:SetMinMaxValues(1,3)
  spos:SetValueStep(1)
  _G[spos:GetName() .. 'Text']:SetText(abt.spos)
  _G[spos:GetName() .. 'Low']:SetText('')
  _G[spos:GetName() .. 'High']:SetText('')
  spos:SetPoint('TOPLEFT', buffnm, 'BOTTOMLEFT', 0, -60)
  spos:SetScript('OnValueChanged', function()
    vals = abt.sposvals
    if this:GetValue() then
      this.valtext:SetText(vals[this:GetValue()])
      abt:UpdateExample()
    end
  end)

  local text = spos:CreateFontString(nil, 'BACKGROUND')
  text:SetPoint('CENTER', spos, 'CENTER', 0, -10)
  text:SetFontObject('GameFontNormalSmall')
  spos.valtext = text

  local text = spos:CreateFontString(nil, 'BACKGROUND')
  text:SetPoint('TOPLEFT', spos, 'TOPLEFT', -20, 35)
  text:SetFont(GameFontNormal:GetFont(),16, 'OUTLINE')
  text:SetTextColor(0,1,0)
  text:SetText(abt.hint4)

  local fontsize = CreateFrame('Slider','obifontsize', spellnm,'OptionsSliderTemplate')
  fontsize:SetWidth(80)
  fontsize:SetMinMaxValues(8,26)
  fontsize:SetValueStep(1)
  _G[fontsize:GetName() .. 'Text']:SetText(abt.fontsize)
  _G[fontsize:GetName() .. 'Low']:SetText('8')
  _G[fontsize:GetName() .. 'High']:SetText('26')
  fontsize:SetPoint('TOPLEFT', spos, 'TOPRIGHT', 20, 0)
  fontsize:SetScript('OnValueChanged', function()
    this.valtext:SetText(this:GetValue())
    abt:UpdateExample()
  end)

  local text = fontsize:CreateFontString(nil, 'BACKGROUND')
  text:SetPoint('CENTER', fontsize, 'CENTER', 0, -20)
  text:SetFontObject('GameFontNormalSmall')
  fontsize.valtext = text

  local fontstyle = CreateFrame('Slider','obifontstyle', spellnm,'OptionsSliderTemplate')
  fontstyle:SetWidth(90)
  fontstyle:SetMinMaxValues(0,2)
  fontstyle:SetValueStep(1)
  _G[fontstyle:GetName() .. 'Text']:SetText(abt.fontstyle)
  _G[fontstyle:GetName() .. 'Low']:SetText('')
  _G[fontstyle:GetName() .. 'High']:SetText('')
  fontstyle:SetPoint('TOPLEFT', fontsize, 'TOPRIGHT', 20, 0)
  fontstyle:SetScript('OnValueChanged', function()
    vals = abt.fontStyleValues
    if this:GetValue() then
      this.valtext:SetText(vals[this:GetValue()])
      abt:UpdateExample()
    end
  end)

  local text = fontstyle:CreateFontString(nil, 'BACKGROUND')
  text:SetPoint('CENTER', fontstyle, 'CENTER', 0, -20)
  text:SetFontObject('GameFontNormalSmall')
  fontstyle.valtext = text

  local fontcolor = CreateFrame('Button','obifontcolor',spellnm)
  fontcolor:SetPoint('TOPLEFT', fontstyle, 'TOPRIGHT', 20, 0)
  fontcolor:SetWidth(20)
  fontcolor:SetHeight(20)
  --fontcolor:SetNormalTexture('Interface/ChatFrame/ChatFrameColorSwatch')
  local bg = fontcolor:CreateTexture(nil, 'BACKGROUND')
  bg:SetWidth(20)
  bg:SetHeight(20)
  bg:SetPoint('CENTER')
  fontcolor.bg = bg
  fontcolor:SetScript('OnClick', function(fontColor)
    ColorPickerFrame.func = function()
      r,g,b = ColorPickerFrame:GetColorRGB()
      fontcolor.fontr = r
      fontcolor.fontg = g
      fontcolor.fontb = b
      fontcolor.bg:SetTexture(r,g,b)
      abt:UpdateExample()
    end

    ColorPickerFrame.cancelFunc = function()
      r,g,b = ColorPickerFrame.prevr,ColorPickerFrame.prevg,ColorPickerFrame.prevb
      fontcolor.fontr = r
      fontcolor.fontg = g
      fontcolor.fontb = b
      fontcolor.bg:SetTexture(r,g,b)
      abt:UpdateExample()
    end

    ColorPickerFrame.prevr = fontcolor.fontr
    ColorPickerFrame.prevg = fontcolor.fontg
    ColorPickerFrame.prevb = fontcolor.fontb
    ColorPickerFrame:SetColorRGB(fontcolor.fontr,fontcolor.fontg,fontcolor.fontb)
    ColorPickerFrame.opacity = 1
    ColorPickerFrame:Show()
  end)


  local testbutton = CreateFrame('CheckButton', 'obiexample', spellnm, 'ActionBarButtonTemplate')
  SetSize(testbutton, 36, 36)
  testbutton:Disable()
  testbutton:SetPoint('TOPLEFT', fontcolor, 50, 10)

  local function CancelClick()
    _G['obicon1'].error:SetText('')
    _G['obicon1']:Hide()
    _G['obicon0']:Show()
  end

  local function SaveClick()
    -- actually save things in here
    to,from = _G['obicon1']:GetText() , _G['obicon0'].value
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
      spelldd.Initialize()
    end

    ABT_SpellDB[to]['SEARCHTT'] = FalseToNil(_G['obisearchtt']:GetChecked())
    ABT_SpellDB[to]['SHOWDMG'] = NilIf(_G['obishowdmg']:GetValue(),0)
    ABT_SpellDB[to]['Buff'] = BlankToNil(_G['obicon2']:GetText())
    ABT_SpellDB[to]['TARGET'] = NilIf(_G['obitarget']:GetValue(),1)
    ABT_SpellDB[to]['Debuff'] = FalseToNil(_G['obicon4']:GetChecked())
    ABT_SpellDB[to]['NOTMINE'] = FalseToNil(_G['obinotmine']:GetChecked())
    ABT_SpellDB[to]['NoTime'] = FalseToNil(_G['obicon5']:GetChecked())
    ABT_SpellDB[to]['Stack'] = FalseToNil(_G['obicon6']:GetChecked())
    ABT_SpellDB[to]['SPOS'] = NilIf(_G['obispos']:GetValue(),1)
    ABT_SpellDB[to]['FONTSIZE'] = NilIf(_G['obifontsize']:GetValue(),11)
    ABT_SpellDB[to]['FONTSTYLE'] = NilIf(_G['obifontstyle']:GetValue(),1)
    ABT_SpellDB[to]['FONTCOLR'] = NilIf(_G['obifontcolor'].fontr,0)
    ABT_SpellDB[to]['FONTCOLG'] = NilIf(_G['obifontcolor'].fontg,1)
    ABT_SpellDB[to]['FONTCOLB'] = NilIf(_G['obifontcolor'].fontb,0)
    ABT_SpellDB[to]['CP'] = NilIf(_G['obicon8']:GetValue(),0)
    ABT_SpellDB[to]['EDEF'] = NilIf(_G['obiedef']:GetValue(),0)
    ABT_SpellDB[to]['CTOOM'] = NilIf(_G['obictoom']:GetValue(),-1)
    CancelClick()
  end

  local function DeleteClick()
    btntext = this:GetText()
    if btntext == abt.del1 then
      this:SetText(abt.del2)
    elseif btntext == abt.del2 then
      this:SetText(abt.del3)
    elseif btntext == abt.del3 then
      -- actually delete things in here
      ABT_SpellDB[_G['obicon0'].value] = nil
      CancelClick()
    end
  end

  local saveButton = CreateFrame('Button','obicon9', spellnm,'UIPanelButtonTemplate')
  saveButton:SetWidth(120)
  saveButton:SetHeight(20)
  saveButton:SetPoint('BOTTOMLEFT', abt.configpanel, 'BOTTOMLEFT', 30, 20)
  saveButton:SetText(abt.con9)
  saveButton:SetScript('OnClick', SaveClick)

  local cancelButton = CreateFrame('Button','obicon10', spellnm,'UIPanelButtonTemplate')
  cancelButton:SetWidth(120)
  cancelButton:SetHeight(20)
  cancelButton:SetPoint('TOPLEFT', saveButton, 'TOPRIGHT', 20, 0)
  cancelButton:SetText(abt.con10)
  cancelButton:SetScript('OnClick', CancelClick)

  local deleteButton = CreateFrame('Button','obicon11', spellnm,'UIPanelButtonTemplate')
  deleteButton:SetWidth(200)
  deleteButton:SetHeight(20)
  deleteButton:SetPoint('TOPLEFT', cancelButton, 'TOPRIGHT', 80, 0)
  deleteButton:SetScript('OnClick', DeleteClick)

  local widgets = {_G['obicon1'],_G['obicon1']:GetChildren()}
  for _,id in ipairs(widgets) do
    subscribe(id, 'OnEnter', ShowTip)
    subscribe(id, 'OnLeave', HideTip)
  end

  local titleRegion = abt.configpanel:CreateTitleRegion()
  titleRegion:SetWidth(525)
  titleRegion:SetHeight(20)
  titleRegion:SetPoint('TOPLEFT', mainFrame, 'TOPLEFT', 50, -10)

  local texture = abt.configpanel:CreateTexture(nil, 'BACKGROUND')
  texture:SetTexture('Interface\\FriendsFrame\\FriendsFrameScrollIcon')
  texture:SetWidth(64)
  texture:SetHeight(64)
  texture:SetPoint('TOPLEFT', abt.configpanel, 'TOPLEFT', 8, 1)

  texture = abt.configpanel:CreateTexture(nil, 'ARTWORK')
  texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft')
  texture:SetWidth(256)
  texture:SetHeight(256)
  texture:SetPoint('TOPLEFT')

  texture = abt.configpanel:CreateTexture(nil, 'ARTWORK')
  texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft')
  texture:SetWidth(128)
  texture:SetHeight(256)
  texture:SetPoint('TOPLEFT', abt.configpanel, 'TOPLEFT', 256, 0)
  texture:SetTexCoord(0.38, 0.88, 0, 1)

  texture = abt.configpanel:CreateTexture(nil, 'ARTWORK')
  texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-TopLeft')
  texture:SetWidth(128)
  texture:SetHeight(256)
  texture:SetPoint('TOPLEFT', abt.configpanel, 'TOPLEFT', 384, 0)
  texture:SetTexCoord(0.45, 0.95, 0, 1)

  texture = abt.configpanel:CreateTexture(nil, 'ARTWORK')
  texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-TopRight')
  texture:SetWidth(100)
  texture:SetHeight(256)
  texture:SetPoint('TOPRIGHT')
  texture:SetTexCoord(0, 0.78125, 0, 1)

  texture = abt.configpanel:CreateTexture(nil, 'ARTWORK')
  texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft')
  texture:SetWidth(256)
  texture:SetHeight(184)
  texture:SetPoint('BOTTOMLEFT')
  texture:SetTexCoord(0, 1, 0, 0.71875)

  texture = abt.configpanel:CreateTexture(nil, 'ARTWORK')
  texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft')
  texture:SetWidth(128)
  texture:SetHeight(184)
  texture:SetPoint('BOTTOMLEFT', abt.configpanel, 'BOTTOMLEFT', 256, 0)
  texture:SetTexCoord(0.5, 1, 0, 0.71875)

  texture = abt.configpanel:CreateTexture(nil, 'ARTWORK')
  texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft')
  texture:SetWidth(128)
  texture:SetHeight(184)
  texture:SetPoint('BOTTOMLEFT', abt.configpanel, 'BOTTOMLEFT', 384, 0)
  texture:SetTexCoord(0.5, 1, 0, 0.71875)

  texture = abt.configpanel:CreateTexture(nil, 'ARTWORK')
  texture:SetTexture('Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight')
  texture:SetWidth(100)
  texture:SetHeight(184)
  texture:SetPoint('BOTTOMRIGHT')
  texture:SetTexCoord(0, 0.78125, 0, 0.71875)

  local fontString = abt.configpanel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
  fontString:SetText('ActionButtonText - Configuratron!')
  fontString:SetPoint('TOP', abt.configpanel, 'TOP', 0, -18)

  local frame = CreateFrame('Button', nil, abt.configpanel, 'UIPanelCloseButton')
  frame:SetPoint('TOPRIGHT', abt.configpanel, 'TOPRIGHT', -3, -8)

  table.insert(UISpecialFrames, abt.configpanel:GetName()) -- closes window on [ESCAPE]
  abt.configpanel:Hide()

end