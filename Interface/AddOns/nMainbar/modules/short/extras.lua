local cfg = nMainbar.Config

if (not cfg.MainMenuBar.shortBar or not cfg.MainMenuBar.moveableExtraBars) then
  return
end

for _, frame in pairs({
  _G['ShapeshiftBarFrame'],
  _G['PetActionBarFrame']
}) do
  frame:EnableMouse(false)
end

for _, frame in pairs({
  shapeshiftBar = _G['ShapeshiftButton1'],
  petBar = _G['PetActionButton1']
}) do
  local positionCfg = cfg[_].position
  if (positionCfg) then
    frame:ClearAllPoints()
    frame:SetPoint(unpack(positionCfg))
  else
    frame:ClearAllPoints()
    frame:SetPoint('CENTER', UIParent, -100)

    frame:SetMovable(true)
    -- frame:EnableMouse(true)
    frame:SetUserPlaced(true)

    frame:RegisterForDrag('LeftButton')
    
    frame:SetScript('OnDragStart', function(self)
      if (IsShiftKeyDown() and IsAltKeyDown()) then
        self:StartMoving()
      end
    end)

    frame:SetScript('OnDragStop', function(self)
      self:StopMovingOrSizing()
    end)
  end
end
