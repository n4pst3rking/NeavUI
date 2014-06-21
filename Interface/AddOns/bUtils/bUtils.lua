function SetSize(frame, width, height)
  frame:SetWidth(width)
  frame:SetHeight(height)
end

function GetSize(frame)
  return frame:GetWidth(), frame:GetHeight()
end

function IsMouseOver(frame)
  return frame == GetMouseFocus()
end

function HideAndUnregister(frame)
  frame:Hide()
  frame:UnregisterAllEvents()
end

function wipe(t)
  for k,v in pairs(t) do
    t[k] = nil
  end
end

function count_t(t)
  local count = 0
  for _, v in pairs(t) do
    count = count + 1
  end
  return count
end

local subscribtions = {}

function subscribe(frame, event, handler)
  if not frame or not frame.GetName or not frame.SetScript then
    return
  end
  if not subscribtions[frame:GetName()] then
    subscribtions[frame:GetName()] = {}
  end

  if not subscribtions[frame:GetName()][event] then
    subscribtions[frame:GetName()][event] = {}
    frame:SetScript(event, function(...)
      local self = ...
      for _, callback in pairs(subscribtions[self:GetName()][event]) do
        callback(...)
      end
    end)
  end

  local id = count_t(subscribtions[frame:GetName()][event])
  subscribtions[frame:GetName()][event][id] = handler;
  return id
end

function unsubscribe(frame, event, id)
  subscribtions[frame:GetName()][event][id] = nil
end

local QuestDifficultyColors = {
  trivial = {r = 0.5, g = 0.5, b = 0.43},
  standard = {r = 0, g = 0.87, b = 0},
  difficult = {r = 0.94, g = 0.75, b = 0.07},
  verydifficult = {r = 0.94, g = 0.5, b = 0},
  impossible = {r = 0.95, g = 0, b = 0}
}

function GetQuestDifficultyColor(level)
  return GetRelativeDifficultyColor(UnitLevel('player'), level)
end

function GetRelativeDifficultyColor(unitLevel, challengeLevel)
  local levelDiff = challengeLevel - unitLevel;
  local color;
  if ( levelDiff >= 5 ) then
    return QuestDifficultyColors["impossible"];
  elseif ( levelDiff >= 3 ) then
    return QuestDifficultyColors["verydifficult"];
  elseif ( levelDiff >= -2 ) then
    return QuestDifficultyColors["difficult"];
  elseif ( -levelDiff <= GetQuestGreenRange() ) then
    return QuestDifficultyColors["standard"];
  else
    return QuestDifficultyColors["trivial"];
  end
end

function ToggleGameMenu_Public()
  if ( securecall("StaticPopup_EscapePressed") ) then
  elseif ( OptionsFrame:IsShown() ) then
    OptionsFrameCancel:Click();
  elseif ( GameMenuFrame:IsShown() ) then
    PlaySound("igMainMenuQuit");
    HideUIPanel(GameMenuFrame);
  elseif ( HelpFrame:IsShown() ) then
    if ( HelpFrame.back and HelpFrame.back.Click ) then
      HelpFrame.back:Click();
    end
  elseif ( InterfaceOptionsFrame:IsShown() ) then
    InterfaceOptionsFrameCancel:Click();
  elseif ( TimeManagerFrame and TimeManagerFrame:IsShown() ) then
    TimeManagerCloseButton:Click();
  elseif ( securecall("CloseMenus") ) then
  elseif ( securecall("CloseAllWindows") ) then
  else
    PlaySound("igMainMenuOpen");
    ShowUIPanel(GameMenuFrame);
  end
end

function UnitHasMana(unit)
  return UnitPowerType(unit) == 0
end