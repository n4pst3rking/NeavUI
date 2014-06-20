local cfg = nMinimap.Config

if not cfg.clock.show then
  hooksecurefunc(TimeManagerClockButton, 'Show', function()
    TimeManagerClockButton:Hide()
  end)
  return
end

if not cfg.clock.showAlways then
  local function UpdateTimeManagerClock()
    if not IsMouseOver(TimeManagerClockButton) and not IsMouseOver(Minimap) then
      TimeManagerClockButton:Hide()
    elseif not TimeManagerClockButton:IsShown() then
      TimeManagerClockButton:Show()
    end
  end
  hooksecurefunc(TimeManagerClockButton, 'Show', UpdateTimeManagerClock)
  subscribe(Minimap, 'OnEnter', function()
    UpdateTimeManagerClock()
  end)
  subscribe(Minimap, 'OnLeave', function(...)
    UpdateTimeManagerClock()
  end)
end

local classColor = RAID_CLASS_COLORS[select(2, UnitClass('player'))]

local function resetClockColor()
  if not cfg.clock.classColor then
    TimeManagerClockTicker:SetTextColor(1, 1, 1)
  else
    TimeManagerClockTicker:SetTextColor(classColor.r, classColor.g, classColor.b)
  end
end

TimeManagerClockTicker:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
TimeManagerClockTicker:SetShadowOffset(0, 0)
TimeManagerClockButton:GetRegions():Hide()
TimeManagerClockButton:ClearAllPoints()
SetSize(TimeManagerClockButton, 40, 18)
TimeManagerClockButton:SetPoint('BOTTOM', Minimap, 0, 2)
subscribe(TimeManagerClockButton, 'OnClick', function()
  ToggleTimeManager();
end)
resetClockColor()

TimeManagerAlarmFiredTexture:SetTexture(nil)

hooksecurefunc(TimeManagerAlarmFiredTexture, 'Show', function()
    TimeManagerClockTicker:SetTextColor(1, 0, 1)
end)

hooksecurefunc(TimeManagerAlarmFiredTexture, 'Hide', function()
  resetClockColor()
end)