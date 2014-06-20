local cfg = nBuff.Config

local _G = _G
local unpack = unpack

--[[
_G.DAY_ONELETTER_ABBR = '|cffffffff%dd|r'
_G.HOUR_ONELETTER_ABBR = '|cffffffff%dh|r'
_G.MINUTE_ONELETTER_ABBR = '|cffffffff%dm|r'
_G.SECOND_ONELETTER_ABBR = '|cffffffff%d|r'

_G.DEBUFF_MAX_DISPLAY = 32 -- show more debuffs
_G.BUFF_MIN_ALPHA = 1
--]]

local origSecondsToTimeAbbrev = _G.SecondsToTimeAbbrev
local function SecondsToTimeAbbrevHook(seconds)
    origSecondsToTimeAbbrev(seconds)

    local tempTime
    if (seconds >= 86400) then
        tempTime = ceil(seconds / 86400)
        return '|cffffffff%dd|r', tempTime
    end

    if (seconds >= 3600) then
        tempTime = ceil(seconds / 3600)
        return '|cffffffff%dh|r', tempTime
    end

    if (seconds >= 60) then
        tempTime = ceil(seconds / 60)
        return '|cffffffff%dm|r', tempTime
    end

    return '|cffffffff%d|r', seconds
end
SecondsToTimeAbbrev = SecondsToTimeAbbrevHook

local function GetActiveTempEnchantNum()
  local active = 0
  for i = 1, 2 do
    if (_G['TempEnchant'..i]:IsShown()) then
      active = active + 1
    end
  end
  return active
end

local function ApplySkin(self, button)
  if (button and not button.Shadow) then
    if (button) then
      if (self:match('Debuff')) then
        SetSize(button, cfg.debuffSize, cfg.debuffSize)
        button:SetScale(cfg.debuffScale)
      else
        SetSize(button, cfg.buffSize, cfg.buffSize)
        button:SetScale(cfg.buffScale)
      end
    end
  
    local icon = _G[self..'Icon']
    if (icon) then
      icon:SetTexCoord(0.04, 0.96, 0.04, 0.96)
    end
  
    local duration = _G[self..'Duration']
    if (duration) then
      duration:ClearAllPoints()
      duration:SetPoint('BOTTOM', button, 'BOTTOM', 0, -2)
      if (self:match('Debuff')) then
        duration:SetFont(cfg.durationFont, cfg.debuffFontSize, 'THINOUTLINE')
      else
        duration:SetFont(cfg.durationFont, cfg.buffFontSize, 'THINOUTLINE')
      end
      duration:SetShadowOffset(0, 0)
      duration:SetDrawLayer('OVERLAY')
    end
  
    local count = _G[self..'Count']
    if (count) then
      count:ClearAllPoints()
      count:SetPoint('TOPRIGHT', button)
      if (self:match('Debuff')) then
        count:SetFont(cfg.countFont, cfg.debuffCountSize, 'THINOUTLINE')
      else
        count:SetFont(cfg.countFont, cfg.buffCountSize, 'THINOUTLINE')
      end
      count:SetShadowOffset(0, 0)
      count:SetDrawLayer('OVERLAY')
    end

    local border = _G[self..'Border']
    if (border) then
      border:SetTexture(cfg.borderDebuff)
      border:SetPoint('TOPRIGHT', button, 1, 1)
      border:SetPoint('BOTTOMLEFT', button, -1, -1)
      border:SetTexCoord(0, 1, 0, 1)
    end

    if (button and not border) then
      if (not button.texture) then
        button.texture = button:CreateTexture('$parentOverlay', 'ARTWORK')
        button.texture:SetParent(button)
        button.texture:SetTexture(cfg.borderBuff)
        button.texture:SetPoint('TOPRIGHT', button, 1, 1)
        button.texture:SetPoint('BOTTOMLEFT', button, -1, -1)
        button.texture:SetVertexColor(unpack(cfg.buffBorderColor))
      end
    end

    if (button) then
      if (not button.Shadow) then
        button.Shadow = button:CreateTexture('$parentShadow', 'BACKGROUND')
        button.Shadow:SetTexture('Interface\\AddOns\\nBuff\\media\\textureShadow')
        button.Shadow:SetPoint('TOPRIGHT', button.texture or border, 3.35, 3.35)
        button.Shadow:SetPoint('BOTTOMLEFT', button.texture or border, -3.35, -3.35)
        button.Shadow:SetVertexColor(0, 0, 0, 1)
      end
    end
  end
end

local function CheckSkinning()
  for index = 1, BUFF_ACTUAL_DISPLAY do
    local button = _G['BuffButton'..index]
    if button then
      ApplySkin(button:GetName(), button)
    end
  end
  for index = 1, DEBUFF_ACTUAL_DISPLAY do
    local button = _G['DebuffButton'..index]
    if button then
      ApplySkin(button:GetName(), button)
    end
  end
end

BuffFrame:SetScript('OnUpdate', nil)
hooksecurefunc(BuffFrame, 'Show', function(self)
  self:SetScript('OnUpdate', nil)
end)

-- TemporaryEnchantFrame
TempEnchant1:ClearAllPoints()
TempEnchant1:SetPoint('TOPRIGHT', Minimap, 'TOPLEFT', -15, 0)
-- TempEnchant1.SetPoint = function() end

TempEnchant2:ClearAllPoints()
TempEnchant2:SetPoint('TOPRIGHT', TempEnchant1, 'TOPLEFT', -cfg.paddingX, 0)

local function UpdateFirstButton(self)
  if (self and self:IsShown()) then
    self:ClearAllPoints()
    if (GetActiveTempEnchantNum() > 0) then
      self:SetPoint('TOPRIGHT', _G['TempEnchant'..GetActiveTempEnchantNum()], 'TOPLEFT', -cfg.paddingX, 0)
      return
    else
      self:SetPoint('TOPRIGHT', TempEnchant1)
      return
    end
  end
end

local function CheckFirstButton()
  if (BuffButton1) then
    UpdateFirstButton(BuffButton1)
  end
end

hooksecurefunc('BuffFrame_Update', function()
  -- buff
  local previousBuff, aboveBuff
  local numBuffs = 0
  local numTotal = GetActiveTempEnchantNum()

  for i = 1, BUFF_ACTUAL_DISPLAY do
    local buff = _G['BuffButton'..i]

    numBuffs = numBuffs + 1
    numTotal = numTotal + 1

    buff:ClearAllPoints()
    if (numBuffs == 1) then
      UpdateFirstButton(buff)
    elseif (numBuffs > 1 and mod(numTotal, cfg.buffPerRow) == 1) then
      if (numTotal == cfg.buffPerRow + 1) then
          buff:SetPoint('TOP', TempEnchant1, 'BOTTOM', 0, -cfg.paddingY)
      else
          buff:SetPoint('TOP', aboveBuff, 'BOTTOM', 0, -cfg.paddingY)
      end

      aboveBuff = buff
    else
      buff:SetPoint('TOPRIGHT', previousBuff, 'TOPLEFT', -cfg.paddingX, 0)
    end

    previousBuff = buff
  end
  
  -- debuff

  local rowSpacing
  local debuffSpace = cfg.buffSize + cfg.paddingY
  local numRows = ceil(numTotal / cfg.buffPerRow)

  if (numRows and numRows > 1) then
      rowSpacing = -numRows * debuffSpace
  else
      rowSpacing = -debuffSpace
  end
  if DEBUFF_ACTUAL_DISPLAY then
    for index = 1, DEBUFF_ACTUAL_DISPLAY do
      local debuff = _G['DebuffButton'..index]
      if not debuff then
        break
      end
      debuff:ClearAllPoints()
    
      if (index == 1) then
          debuff:SetPoint('TOP', TempEnchant1, 'BOTTOM', 0, rowSpacing)
      elseif (index >= 2 and mod(index, cfg.buffPerRow) == 1) then
          buff:SetPoint('TOP', _G['DebuffButton'..(index - cfg.buffPerRow)], 'BOTTOM', 0, -cfg.paddingY)
      else
          debuff:SetPoint('TOPRIGHT', _G['DebuffButton'..(index - 1)], 'TOPLEFT', -cfg.paddingX, 0)
      end
    end
  end
  
  CheckSkinning()
end)

for i = 1, 2 do
    local button = _G['TempEnchant'..i]
    button:SetScale(cfg.buffScale)
    SetSize(button, cfg.buffSize, cfg.buffSize)
    
    subscribe(button, 'OnShow', function()
      CheckFirstButton()
    end)

    subscribe(button, 'OnHide', function()
      CheckFirstButton()
    end)

    local icon = _G['TempEnchant'..i..'Icon']
    icon:SetTexCoord(0.04, 0.96, 0.04, 0.96)

    local duration = _G['TempEnchant'..i..'Duration']
    duration:ClearAllPoints()
    duration:SetPoint('BOTTOM', button, 'BOTTOM', 0, -2)
    duration:SetFont(cfg.durationFont, cfg.buffFontSize, 'THINOUTLINE')
    duration:SetShadowOffset(0, 0)
    duration:SetDrawLayer('OVERLAY')

    local border = _G['TempEnchant'..i..'Border']
    border:ClearAllPoints()
    border:SetPoint('TOPRIGHT', button, 1, 1)
    border:SetPoint('BOTTOMLEFT', button, -1, -1)    
    border:SetTexture(cfg.borderDebuff)
    border:SetTexCoord(0, 1, 0, 1)
    border:SetVertexColor(0.9, 0.25, 0.9)

    button.Shadow = button:CreateTexture('$parentBackground', 'BACKGROUND')
    button.Shadow:SetPoint('TOPRIGHT', border, 3.35, 3.35)
    button.Shadow:SetPoint('BOTTOMLEFT', border, -3.35, -3.35)
    button.Shadow:SetTexture('Interface\\AddOns\\nBuff\\media\\textureShadow')
    button.Shadow:SetVertexColor(0, 0, 0, 1)
end