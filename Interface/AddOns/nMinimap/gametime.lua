local cfg = nMinimap.Config

if (not IsAddOnLoaded('Blizzard_TimeManager')) then
    LoadAddOn('Blizzard_TimeManager')
end

for i = 1, select('#', GameTimeFrame:GetRegions()) do
    local texture = select(i, GameTimeFrame:GetRegions())
    if (texture and texture:GetObjectType() == 'Texture') then
        texture:SetTexture(nil)
    end
end

SetSize(GameTimeFrame, 14, 14)
GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetPoint('TOPRIGHT', Minimap, -3.5, -3.5)

local function setupGameTimeFont()
  local GameTimeFrameFontString = GameTimeFrame:CreateFontString()
  GameTimeFrameFontString:SetFont('Fonts\\ARIALN.ttf', 15, 'OUTLINE')
  GameTimeFrameFontString:SetShadowOffset(0, 0)
  GameTimeFrameFontString:SetPoint('TOPRIGHT', GameTimeFrame)
  GameTimeFrameFontString:SetText(date('%d'))
  
  local texture = TimeManagerAlarmFiredTexture
  texture:SetTexture(nil)

  local classColor = RAID_CLASS_COLORS[select(2, UnitClass('player'))]
  local setupFontColor = function(texture)
    if texture and texture:IsShown() then
      GameTimeFrameFontString:SetTextColor(1, 0, 1)
    elseif cfg.clock.classColor then
      GameTimeFrameFontString:SetTextColor(classColor.r, classColor.g, classColor.b)
    else
      GameTimeFrameFontString:SetTextColor(1, 1, 1)
    end
  end

  hooksecurefunc(texture, 'Show', function()
    setupFontColor()
  end)

  hooksecurefunc(texture, 'Hide', function()
    setupFontColor()
  end)
  
  setupFontColor()
end

setupGameTimeFont()