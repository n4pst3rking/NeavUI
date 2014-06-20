local gsub = string.gsub

hooksecurefunc('ActionButton_UpdateHotkeys', function(actionButtonType)
  if (not actionButtonType) then
    actionButtonType = "ACTIONBUTTON"
  end

  local hotkey = _G[this:GetName()..'HotKey']
  local key = GetBindingKey(actionButtonType..this:GetID()) or
              GetBindingKey("CLICK "..this:GetName()..":LeftButton")
  local text = GetBindingText(key, 'KEY_', 1)
  

  text = gsub(text, '(s%-)', 'S-')
  text = gsub(text, '(a%-)', 'A-')
  text = gsub(text, '(c%-)', 'C-')
  text = gsub(text, '(st%-)', 'C-') -- german control 'Steuerung'

  for i = 1, 5 do
    text = gsub(text, _G['KEY_BUTTON'..i], 'M'..i)
  end

  for i = 1, 9 do
      text = gsub(text, _G['KEY_NUMPAD'..i], 'Nu'..i)
  end

  text = gsub(text, KEY_NUMPADDECIMAL, 'Nu.')
  text = gsub(text, KEY_NUMPADDIVIDE, 'Nu/')
  -- text = gsub(text, KEY_NUMPADMULTIPLY, 'Nu*')
  text = gsub(text, KEY_NUMPADMULTIPLY, 'Nu') -- how can we threat the * as a literal character?
  text = gsub(text, KEY_NUMPADPLUS, 'Nu+')
  text = gsub(text, KEY_NUMPADMINUS, 'Nu-')

  text = gsub(text, KEY_MOUSEWHEELUP, 'MU')
  text = gsub(text, KEY_MOUSEWHEELDOWN, 'MD')
  text = gsub(text, KEY_NUMLOCK, 'NuL')
  text = gsub(text, KEY_NUMLOCK_MAC, 'NuC')
  text = gsub(text, KEY_PAGEUP, 'PU')
  text = gsub(text, KEY_PAGEDOWN, 'PD')
  text = gsub(text, KEY_SPACE, '_')
  text = gsub(text, KEY_INSERT, 'Ins')
  text = gsub(text, KEY_HOME, 'Hm')
  text = gsub(text, KEY_DELETE, 'Del')

  hotkey:SetText(text)
end)
