local cfg = nPlates.Config

-- Local stuff
local len = string.len
local find = string.find
local gsub = string.gsub
local match = string.match

local select = select
local tonumber = tonumber

local UnitName = UnitName
local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local GetSpellInfo = GetSpellInfo

local borderColor = {0.47, 0.47, 0.47}
local noThreatColor = {0, 1, 0}

local overlayTexture = 'Interface\\AddOns\\nPlates\\media\\textureOverlay'
local whiteOverlay = 'Interface\\AddOns\\nPlates\\media\\textureIconOverlay'

-- this table will hold the class information for every targetted or mouseover'd unit
-- to provide class colored nameplates
local classes = {}

local f = CreateFrame('Frame', nil, UIParent)

f.elapsed = 0
f.elapsedLong = 0

-- Totem data and functions
local function TotemRankToRomanNumber(rank)
  if not rank or not (rank ~= '') then
    return rank
  end
  
  local rankNumber = match(rank, RANK..' (%d+)')
  if rankNumber then
    rankNumber = tonumber(rankNumber)
    if rankNumber == 1 then rank = 'I' elseif rankNumber == 2 then rank = 'II'
    elseif rankNumber == 3 then rank = 'III' elseif rankNumber == 4 then rank = 'IV'
    elseif rankNumber == 5 then rank = 'V' elseif rankNumber == 6 then rank = 'VI'
    elseif rankNumber == 7 then rank = 'VII' elseif rankNumber == 8 then rank = 'VIII'
    elseif rankNumber == 9 then rank = 'IX' elseif rankNumber == 10 then rank = 'X' end
  end
  return rank
end

local function TotemName(SpellID)
    local name, rank = GetSpellInfo(SpellID)
    return name..' '..TotemRankToRomanNumber(rank)
end

local function TotemIcon(SpellID)
    local _, _, icon = GetSpellInfo(SpellID)
    return icon
end

local totemData = {
    -- Air
    [TotemName(8835)] = {TotemIcon(8835)},   -- Grace of Air Totem I
    [TotemName(10627)] = {TotemIcon(10627)}, -- Grace of Air Totem II
    [TotemName(25359)] = {TotemIcon(25359)}, -- Grace of Air Totem III
    
    [TotemName(10595)] = {TotemIcon(10595)}, -- Nature Resistance Totem I
    [TotemName(10600)] = {TotemIcon(10600)}, -- Nature Resistance Totem II
    [TotemName(10601)] = {TotemIcon(10601)}, -- Nature Resistance Totem III
    [TotemName(25574)] = {TotemIcon(25574)}, -- Nature Resistance Totem IV
    
    [TotemName(8512)] = {TotemIcon(8512)},   -- Windfury Totem I
    [TotemName(10613)] = {TotemIcon(10613)}, -- Windfury Totem II
    [TotemName(10614)] = {TotemIcon(10614)}, -- Windfury Totem III
    [TotemName(25585)] = {TotemIcon(25585)}, -- Windfury Totem IV
    [TotemName(25587)] = {TotemIcon(25587)}, -- Windfury Totem V
    
    [TotemName(15107)] = {TotemIcon(15107)}, -- Windwall Totem I
    [TotemName(15111)] = {TotemIcon(15111)}, -- Windwall Totem II
    [TotemName(15112)] = {TotemIcon(15112)}, -- Windwall Totem III
    [TotemName(25577)] = {TotemIcon(25577)}, -- Windwall Totem IV
    
    [TotemName(3738)] = {TotemIcon(3738)}, -- Wrath of Air Totem
    
    [TotemName(6495)] = {TotemIcon(6495)}, -- Sentry Totem
    
    [TotemName(8177)] = {TotemIcon(8177)}, -- Grounding Totem
    
    -- Earth
    [TotemName(8071)] = {TotemIcon(8071)},   -- Stoneskin Totem I
    [TotemName(8154)] = {TotemIcon(8154)},   -- Stoneskin Totem II
    [TotemName(8155)] = {TotemIcon(8155)},   -- Stoneskin Totem III
    [TotemName(10406)] = {TotemIcon(10406)}, -- Stoneskin Totem IV
    [TotemName(10407)] = {TotemIcon(10407)}, -- Stoneskin Totem V
    [TotemName(10408)] = {TotemIcon(10408)}, -- Stoneskin Totem VI
    [TotemName(25508)] = {TotemIcon(25508)}, -- Stoneskin Totem VII
    [TotemName(25509)] = {TotemIcon(25509)}, -- Stoneskin Totem VIII
    
    [TotemName(8075)] = {TotemIcon(8075)},   -- Strength of Earth Totem I
    [TotemName(8160)] = {TotemIcon(8160)},   -- Strength of Earth Totem II
    [TotemName(8161)] = {TotemIcon(8161)},   -- Strength of Earth Totem III
    [TotemName(10442)] = {TotemIcon(10442)}, -- Strength of Earth Totem IV
    [TotemName(25361)] = {TotemIcon(25361)}, -- Strength of Earth Totem V
    [TotemName(25528)] = {TotemIcon(25528)}, -- Strength of Earth Totem VI
    
    [TotemName(5730)] = {TotemIcon(5730)},   -- Stoneclaw Totem I
    [TotemName(6390)] = {TotemIcon(6390)},   -- Stoneclaw Totem II
    [TotemName(6391)] = {TotemIcon(6391)},   -- Stoneclaw Totem III
    [TotemName(6392)] = {TotemIcon(6392)},   -- Stoneclaw Totem IV
    [TotemName(10427)] = {TotemIcon(10427)}, -- Stoneclaw Totem V
    [TotemName(10428)] = {TotemIcon(10428)}, -- Stoneclaw Totem VI
    [TotemName(25525)] = {TotemIcon(25525)}, -- Stoneclaw Totem VII
    
    [TotemName(2062)] = {TotemIcon(2062)}, -- Earth Elemental Totem
    
    [TotemName(8143)] = {TotemIcon(8143)}, -- Tremor Totem

    -- Fire
    [TotemName(8227)] = {TotemIcon(8227)},   -- Flametongue Totem I
    [TotemName(8249)] = {TotemIcon(8249)},   -- Flametongue Totem II
    [TotemName(10526)] = {TotemIcon(10526)}, -- Flametongue Totem III
    [TotemName(16387)] = {TotemIcon(16387)}, -- Flametongue Totem IV
    [TotemName(25557)] = {TotemIcon(25557)}, -- Flametongue Totem V
    
    [TotemName(8181)] = {TotemIcon(8181)},   -- Frost Resistance Totem I
    [TotemName(10478)] = {TotemIcon(10478)}, -- Frost Resistance Totem II
    [TotemName(10479)] = {TotemIcon(10479)}, -- Frost Resistance Totem III
    [TotemName(25560)] = {TotemIcon(25560)}, -- Frost Resistance Totem IV
    
    [TotemName(1535)] = {TotemIcon(1535)},   -- Fire Nova Totem I
    [TotemName(8498)] = {TotemIcon(8498)},   -- Fire Nova Totem II
    [TotemName(8499)] = {TotemIcon(8499)},   -- Fire Nova Totem III
    [TotemName(11314)] = {TotemIcon(11314)}, -- Fire Nova Totem IV
    [TotemName(11315)] = {TotemIcon(11315)}, -- Fire Nova Totem V
    [TotemName(25546)] = {TotemIcon(25546)}, -- Fire Nova Totem VI
    [TotemName(25547)] = {TotemIcon(25547)}, -- Fire Nova Totem VII
    
    [TotemName(8190)] = {TotemIcon(8190)},   -- Magma Totem I
    [TotemName(10585)] = {TotemIcon(10585)}, -- Magma Totem II
    [TotemName(10586)] = {TotemIcon(10586)}, -- Magma Totem III
    [TotemName(10587)] = {TotemIcon(10587)}, -- Magma Totem IV
    [TotemName(25552)] = {TotemIcon(25552)}, -- Magma Totem V
    
    [TotemName(3599)] = {TotemIcon(3599)},   -- Searing Totem I
    [TotemName(6363)] = {TotemIcon(6363)},   -- Searing Totem II
    [TotemName(6364)] = {TotemIcon(6364)},   -- Searing Totem III
    [TotemName(6365)] = {TotemIcon(6365)},   -- Searing Totem IV
    [TotemName(10437)] = {TotemIcon(10437)}, -- Searing Totem V
    [TotemName(10438)] = {TotemIcon(10438)}, -- Searing Totem VI
    [TotemName(25533)] = {TotemIcon(25533)}, -- Searing Totem VII
    
    [TotemName(30706)] = {TotemIcon(30706)}, -- Totem of Wrath

    -- Water
    [TotemName(8184)] = {TotemIcon(8184)},   -- Fire Resistance Totem I
    [TotemName(10537)] = {TotemIcon(10537)}, -- Fire Resistance Totem II
    [TotemName(10538)] = {TotemIcon(10538)}, -- Fire Resistance Totem III
    [TotemName(25563)] = {TotemIcon(25563)}, -- Fire Resistance Totem IV
    
    [TotemName(5394)] = {TotemIcon(5394)},   -- Healing Stream Totem I
    [TotemName(6375)] = {TotemIcon(6375)},   -- Healing Stream Totem II
    [TotemName(6377)] = {TotemIcon(6377)},   -- Healing Stream Totem III
    [TotemName(10462)] = {TotemIcon(10462)}, -- Healing Stream Totem IV
    [TotemName(10463)] = {TotemIcon(10463)}, -- Healing Stream Totem V
    [TotemName(25567)] = {TotemIcon(25567)}, -- Healing Stream Totem VI
    
    [TotemName(5675)] = {TotemIcon(5675)},   -- Mana Spring Totem I
    [TotemName(10495)] = {TotemIcon(10495)}, -- Mana Spring Totem II
    [TotemName(10496)] = {TotemIcon(10496)}, -- Mana Spring Totem III
    [TotemName(10497)] = {TotemIcon(10497)}, -- Mana Spring Totem IV
    [TotemName(25570)] = {TotemIcon(25570)}, -- Mana Spring Totem V
    
    [TotemName(16190)] = {TotemIcon(16190)}, -- Mana Tide Totem
    
    [TotemName(8170)] = {TotemIcon(8170)}, -- Disease Cleansing Totem
    
    [TotemName(8166)] = {TotemIcon(8166)}, -- Poison Cleansing Totem
}

-- Some general functions
local function FormatValue(number)
  if (number >= 1e6) then
    return tonumber(format('%.1f', number/1e6))..'m'
  elseif (number >= 1e3) then
    return tonumber(format('%.1f', number/1e3))..'k'
  else
    return number
  end
end

local function RGBHex(r, g, b)
    if (type(r) == 'table') then
        if (r.r) then
            r, g, b = r.r, r.g, r.b
        else
            r, g, b = unpack(r)
        end
    end

    return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

    -- The plate functions

local function GetUnitReaction(r, g, b)
    if (g + b == 0) then
        return true
    end

    return false
end

local function GetUnitCombatStatus(r, g, b)
    if (r >= 0.98) then
        return true
    end

    return false
end

local function IsTarget(self)
    local targetExists = UnitExists('target')
    if (not targetExists) then
        return false
    end

    local targetName = UnitName('target')
    if (targetName == self.Name:GetText() and self:GetAlpha() >= 0.99) then
        return true
    else
        return false
    end
end

local function UpdateTotemIcon(self)
    if (totemData[self.Name:GetText()]) then
        if (not self.Icon) then
            self.Icon = CreateFrame('Frame', nil, self)
            self.Icon:EnableMouse(false)
            SetSize(self.Icon, 24, 24)
            self.Icon:SetPoint('BOTTOM', self.NewName, 'TOP', 0, 1)
        end

        local icon = totemData[self.Name:GetText()]
        self.Icon:SetBackdrop({
            bgFile = icon[1],
            edgeFile = 'Interface\\Buttons\\WHITE8x8',
            edgeSize = 1.5,
            insets = { top = -0, left = -0, bottom = -0, right = -0 },
        })

        local r, g, b = self.Health:GetStatusBarColor()
        self.Icon:SetBackdropBorderColor(r, g, b, 1)
        self.Icon:Show()
    else
        if (self.Icon) then
            self.Icon:SetBackdrop(nil)
            self.Icon:Hide()
            self.Icon = nil
        end
    end
end


local function UpdateHealthText(self)
    local min, max = self.Health:GetMinMaxValues()
    local currentValue = self.Health:GetValue()
    local perc = (currentValue/max)*100

    if (perc >= 100 and currentValue > 5 and cfg.showFullHP) then
        self.Health.Value:SetFormattedText('%s', FormatValue(currentValue))
    elseif (perc < 100 and currentValue > 5) then
        self.Health.Value:SetFormattedText('%s - %.0f%%', FormatValue(currentValue), perc-0.5)
    else
        self.Health.Value:SetText('')
    end
end

local function UpdateHealthColor(self)
  if classes[self.Name:GetText()] then
    local color = RAID_CLASS_COLORS[classes[self.Name:GetText()]]
    self.Health:SetStatusBarColor(color.r, color.g, color.b)
  else
    local r, g, b = self.Health:GetStatusBarColor()
    if (r + g == 0) then
        self.Health:SetStatusBarColor(0, 0.35, 1)
        return
    end
  end
end

local function UpdateCastbarValue(self, curValue)
    local _, maxValue = self:GetMinMaxValues()
    local cast = UnitCastingInfo('target')
    local channel = UnitChannelInfo('target')

    local r, g, b = unpack(borderColor)
    self.Overlay:SetVertexColor(r, g, b, 1 )

    if (channel) then
        self.CastTime:SetFormattedText('%.1fs', curValue)
    else
        self.CastTime:SetFormattedText('%.1fs', maxValue - curValue)
    end

    self.Name:SetText(cast or channel)
end

local function UpdateNameL(self)
    local newName = self.Name:GetText()
    if (cfg.abbrevLongNames) then
        newName = (len(newName) > 20) and gsub(newName, '%s?(.[\128-\191]*)%S+%s', '%1. ') or newName
    end

    self.NewName:SetTextColor(1, 1, 1)
    if (cfg.showLevel) then
        local levelText = self.Level:GetText() or ''
        local levelColor = RGBHex(self.Level:GetTextColor())

        if (self.BossIcon:IsVisible()) then
            self.NewName:SetText('|cffff0000??|r '..newName)
        else
            self.NewName:SetText(levelColor..levelText..'|r '..newName)
        end
    else
        self.NewName:SetText(newName)
    end
end

local function UpdateEliteTexture(self)
    local r, g, b = unpack(borderColor)
    if (self.BossIcon:IsVisible()) then
        self.Overlay:SetGradientAlpha('HORIZONTAL', r, g, b, 1, 1, 1, 0, 1)
    else
        self.Overlay:SetVertexColor(r, g, b, 1)
    end
end

local function UpdatePlate(self)
    if (self.Level) then
        UpdateNameL(self)
    end

    if (cfg.showEliteBorder) then
        UpdateEliteTexture(self)
    else
        local r, g, b = unpack(borderColor)
        self.Overlay:SetVertexColor(r, g, b, 1)
    end

    if (cfg.showTotemIcon) then
        UpdateTotemIcon(self)
    end

    UpdateHealthText(self)
    UpdateHealthColor(self)

    self.Highlight:ClearAllPoints()
    self.Highlight:SetAllPoints(self.Health)

    if (self.Castbar:IsVisible()) then
        self.Castbar:Hide()
    end

    local r, g, b = self.Health:GetStatusBarColor()
    self.Castbar.IconOverlay:SetVertexColor(r, g, b)
end

local function SkinPlate(self)
    self.styled = true
    self.Health, self.Castbar = self:GetChildren()
    self.Castbar.Overlay, self.Castbar.Icon = select(2, self:GetRegions())
    self.Overlay, _, _, self.Highlight, self.Name, self.Level, self.BossIcon, self.RaidIcon = self:GetRegions()

    -- Hide some nameplate objects
    self.BossIcon:SetTexCoord(0, 0, 0, 0)

    self.Name:SetWidth(0.001)
    self.Level:SetWidth(0.0001)

    -- Modify the overlay
    self.Overlay:SetTexCoord(0, 1, 0, 1)
    self.Overlay:ClearAllPoints()
--    self.Overlay:SetPoint('TOPRIGHT', self.Health, 35.66666667, 5.66666667)
    self.Overlay:SetPoint('TOPRIGHT', self.Health, 41, 5)
    self.Overlay:SetPoint('BOTTOMLEFT', self.Health, -43, -5)
    self.Overlay:SetDrawLayer('BORDER')
    self.Overlay:SetTexture(overlayTexture)

    -- Healtbar and background
    self.Health:SetBackdrop({
      bgFile = 'Interface\\Buttons\\WHITE8x8',
      insets = { left = -1, right = -1, top = -1, bottom = -1 }
    })
    self.Health:SetBackdropColor(0, 0, 0, 0.55)

    self.Health:SetScript('OnValueChanged', function()
      UpdateHealthText(self)
      UpdateHealthColor(self)
    end)

    -- Create health value font string
    if (not self.Health.Value) then
      self.Health.Value = self.Health:CreateFontString(nil, 'OVERLAY')
      self.Health.Value:SetPoint('CENTER', self.Health, 0, 0)
      self.Health.Value:SetFont('Fonts\\ARIALN.ttf', 9)
      self.Health.Value:SetShadowOffset(1, -1)
    end

    if (not self.NewName) then
      self.NewName = self:CreateFontString(nil, 'ARTWORK')
      self.NewName:SetFont('Fonts\\ARIALN.ttf', 11, 'THINOUTLINE')
      self.NewName:SetShadowOffset(0, 0)
      self.NewName:SetPoint('BOTTOM', self.Health, 'TOP', 0, 2)
      SetSize(self.NewName, 110, 13)
    end

    -- Castbar
    self.Castbar:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        insets = { left = -1, right = -1, top = -1, bottom = -1 }
    })
    self.Castbar:SetBackdropColor(0.2, 0.2, 0.2, 0.5)

    self.Castbar:ClearAllPoints()
    self.Castbar:SetPoint('TOPRIGHT', self.Health, 'BOTTOMRIGHT', -2, -9)
    self.Castbar:SetPoint('BOTTOMLEFT', self.Health, 'BOTTOMLEFT', 0, -20)

    self.Castbar:SetScript('OnValueChanged', UpdateCastbarValue)

    self.Castbar.Overlay:SetTexCoord(0, 1, 0, 1)
    self.Castbar.Overlay:SetDrawLayer('BORDER')
    self.Castbar.Overlay:SetTexture(overlayTexture)
    self.Castbar.Overlay:ClearAllPoints()
    self.Castbar.Overlay:SetPoint('TOPRIGHT', self.Castbar, 40, 5.66666667)
    self.Castbar.Overlay:SetPoint('BOTTOMLEFT', self.Castbar, -43, -5.66666667)

    -- Castbar casttime font string
    if (not self.Castbar.CastTime) then
      self.Castbar.CastTime = self.Castbar:CreateFontString(nil, 'OVERLAY')
      self.Castbar.CastTime:SetPoint('RIGHT', self.Castbar, 1.6666667, 0)
      self.Castbar.CastTime:SetDrawLayer('OVERLAY')
      self.Castbar.CastTime:SetFont('Fonts\\ARIALN.ttf', 16)   -- , 'THINOUTLINE')
      self.Castbar.CastTime:SetTextColor(1, 1, 1)
      self.Castbar.CastTime:SetShadowOffset(1, -1)
    end

    -- Castbar castname font string
    if (not self.Castbar.Name) then
      self.Castbar.Name = self.Castbar:CreateFontString(nil, 'OVERLAY')
      self.Castbar.Name:SetPoint('LEFT', self.Castbar, 1.5, 0)
      self.Castbar.Name:SetPoint('RIGHT', self.Castbar.CastTime, 'LEFT', -6, 0)
      self.Castbar.Name:SetFont('Fonts\\ARIALN.ttf', 10)
      self.Castbar.Name:SetTextColor(1, 1, 1)
      self.Castbar.Name:SetShadowOffset(1, -1)
      self.Castbar.Name:SetJustifyH('LEFT')
    end

    -- Castbar spellicon and overlay
    self.Castbar.Icon:SetParent(self.Castbar)
    self.Castbar.Icon:ClearAllPoints()
    self.Castbar.Icon:SetPoint('BOTTOMLEFT', self.Castbar, 'BOTTOMRIGHT', 7, 3)
    SetSize(self.Castbar.Icon, 24, 24)
    self.Castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    self.Castbar.Icon:SetDrawLayer('ARTWORK')

    if (not self.Castbar.IconOverlay) then
      self.Castbar.IconOverlay = self.Castbar:CreateTexture(nil, 'OVERLAY', self.Castbar)
      self.Castbar.IconOverlay:SetPoint('TOPLEFT', self.Castbar.Icon, -1, 1)
      self.Castbar.IconOverlay:SetPoint('BOTTOMRIGHT', self.Castbar.Icon, 1, -1)
      self.Castbar.IconOverlay:SetTexture(whiteOverlay)
    end

    -- Mouseover highlight
    self.Highlight:SetTexture(1, 1, 1, 0.2)

    -- Raidicons
    self.RaidIcon:ClearAllPoints()
    self.RaidIcon:SetDrawLayer('OVERLAY')
    self.RaidIcon:SetPoint('CENTER', self.Health, 'TOP', 0, 20)
    SetSize(self.RaidIcon, 16, 16)

    UpdatePlate(self)

    self:SetScript('OnUpdate', nil)
    self:SetScript('OnShow', UpdatePlate)

    self:SetScript('OnHide', function(self)
        self.Highlight:Hide()
    end)

    self:SetScript('OnUpdate', function(_, elapsed)
      f.elapsed = f.elapsed + elapsed
      if (f.elapsed >= 0.1) then

        if (cfg.showTargetBorder) then
          if (IsTarget(self)) then
            if (not self.TargetHighlight) then
              self.TargetHighlight = self:CreateTexture(nil, 'ARTWORK')
              self.TargetHighlight:SetAllPoints(self.Overlay)
              self.TargetHighlight:SetTexture(overlayTexture)
              self.TargetHighlight:Hide()
            end

            if (not self.TargetHighlight:IsVisible()) then
              self.TargetHighlight:Show()
            end
          else
            if (self.TargetHighlight and self.TargetHighlight:IsVisible()) then
              self.TargetHighlight:Hide()
            end
          end
        end

        f.elapsed = 0
      end

      f.elapsedLong = f.elapsedLong + elapsed
      if (f.elapsedLong >= 0.49) then
        UpdateHealthColor(self)
  
        f.elapsedLong = 0
      end
    end)
end

-- Scan the worldframe for nameplates
local function IsNameplateFrame(frame)
  local o = select(2,frame:GetRegions())
  if not o or o:GetObjectType() ~= "Texture" or o:GetTexture() ~= "Interface\\Tooltips\\Nameplate-Border" then 
    frame.styled = true --don't touch this frame again
    return false 
  end    
  return true
end

local lastUpdate = 0

local searchNameplates = function(self, elapsed)
  lastUpdate = lastUpdate + elapsed

  if lastUpdate > 0.1 then
    lastUpdate = 0
    local numFrames = select("#", WorldFrame:GetChildren())
    
    for i = 1, numFrames do
      local frame = select(i, WorldFrame:GetChildren())
      if not frame.styled and IsNameplateFrame(frame) then
        SkinPlate(frame)
      end
    end
  end
end
f:SetScript('OnEvent', function(self, ev)
  if ev == 'PLAYER_LOGIN' then
    self:SetScript('OnUpdate', searchNameplates)
  end
end)

f:RegisterEvent('PLAYER_LOGIN')


if cfg.classBarColor then
  local classWatcher = CreateFrame('Frame', nil, UIParent)
  classWatcher:RegisterEvent('UPDATE_MOUSEOVER_UNIT')
  classWatcher:RegisterEvent('PLAYER_TARGET_CHANGED')
  classWatcher:RegisterEvent('UPDATE_BATTLEFIELD_SCORE')
  
  classWatcher:SetScript('OnEvent', function(self, event, ...)
    if self[event] and self[event](...) then return true end
    return false
  end)
  
  local function AddName(name, class)
    if not class then
      -- if we got no second parameter, we assume name is a valid unit
      local unit = name 
      if UnitIsPlayer(unit) then
        AddName(UnitName(unit), select(2, UnitClass(unit)))
      end
    else
      if name ~= 'UNKNOWN' and RAID_CLASS_COLORS[class] then
        classes[name] = class
      end
    end
  end
  
  function classWatcher:UPDATE_MOUSEOVER_UNIT()
    AddName('mouseover')
  end
  
  function classWatcher:PLAYER_TARGET_CHANGED()
    AddName('target')
  end
  
  function classWatcher:UPDATE_BATTLEFIELD_SCORE()
    for i = 1, GetNumBattlefieldScores() do
      local name, _, _, _, _, _, _, _, _, class = GetBattlefieldScore(i)
      name = ('-'):split(name, 2)
      AddName(name, class)
    end
  end
end