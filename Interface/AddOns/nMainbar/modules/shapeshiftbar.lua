local cfg = nMainbar.Config

ShapeshiftBarFrame:SetFrameStrata('HIGH')

ShapeshiftBarFrame:SetScale(cfg.shapeshiftBar.scale)
ShapeshiftBarFrame:SetAlpha(cfg.shapeshiftBar.alpha)

if (cfg.shapeshiftBar.hide) then
  for i = 1, NUM_SHAPESHIFT_SLOTS do
    local button = _G['ShapeshiftButton'..i]
    button:SetAlpha(0)
    button.SetAlpha = function() end

    button:EnableMouse(false)
    button.EnableMouse = function() end
  end
  return
end