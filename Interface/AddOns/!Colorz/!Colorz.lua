
-- function SetUpAnimation(frame) CancelAnimations(frame) end

-- ManaBarColor[0] = { r = 0.00, g = 0.00, b = 1.00, prefix = MANA };
-- ManaBarColor[1] = { r = 1.00, g = 0.00, b = 0.00, prefix = RAGE_POINTS };
-- ManaBarColor[2] = { r = 1.00, g = 0.50, b = 0.25, prefix = FOCUS_POINTS };
-- ManaBarColor[3] = { r = 1.00, g = 1.00, b = 0.00, prefix = ENERGY_POINTS };
-- ManaBarColor[4] = { r = 0.00, g = 1.00, b = 1.00, prefix = HAPPINESS_POINTS };

ManaBarColor[0].r, ManaBarColor[0].g, ManaBarColor[0].b = 0/255, 0.55, 1

PowerBarColor = {
  MANA = ManaBarColor[0],
  RAGE = ManaBarColor[1],
  FOCUS = ManaBarColor[2],
  ENERGY = ManaBarColor[3]
}

CUSTOM_FACTION_BAR_COLORS = {
    [1] = {r = 1, g = 0, b = 0},
    [2] = {r = 1, g = 0, b = 0},
    [3] = {r = 1, g = 1, b = 0},
    [4] = {r = 1, g = 1, b = 0},
    [5] = {r = 0, g = 1, b = 0},
    [6] = {r = 0, g = 1, b = 0},
    [7] = {r = 0, g = 1, b = 0},
    [8] = {r = 0, g = 1, b = 0},
}

function GameTooltip_UnitColor(unit)
  if not unit then
    return
  end
  
  local r, g, b

  if (UnitIsDead(unit) or UnitIsGhost(unit) or UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) then
      r = 0.5
      g = 0.5
      b = 0.5 
  elseif (UnitIsPlayer(unit)) then
      if (UnitIsFriend(unit, 'player')) then
          local _, class = UnitClass(unit)
          r = RAID_CLASS_COLORS[class].r
          g = RAID_CLASS_COLORS[class].g
          b = RAID_CLASS_COLORS[class].b
      elseif (not UnitIsFriend(unit, 'player')) then
          r = 1
          g = 0
          b = 0
      end
  elseif (UnitPlayerControlled(unit)) then
      if (UnitCanAttack(unit, 'player')) then
          if (not UnitCanAttack('player', unit)) then
              r = 157/255
              g = 197/255
              b = 255/255
          else
              r = 1
              g = 0
              b = 0
          end
      elseif (UnitCanAttack('player', unit)) then
          r = 1
          g = 1
          b = 0
      elseif (UnitIsPVP(unit)) then
          r = 0
          g = 1
          b = 0
      else
          r = 157/255
          g = 197/255
          b = 255/255
      end
  else
      local reaction = UnitReaction(unit, 'player')

      if (reaction) then
          r = CUSTOM_FACTION_BAR_COLORS[reaction].r
          g = CUSTOM_FACTION_BAR_COLORS[reaction].g
          b = CUSTOM_FACTION_BAR_COLORS[reaction].b
      else
          r = 157/255
          g = 197/255
          b = 255/255
      end
  end

  return r, g, b
end
  
UnitSelectionColor = GameTooltip_UnitColor