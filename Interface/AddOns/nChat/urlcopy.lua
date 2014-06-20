local find, gsub = string.find, string.gsub

local function ColorURL(text, url)
  return ' |Hurl'..':'..tostring(url)..'|h'..'|cff0099FF'..tostring(url)..'|h|r '
end

local function ScanURL(frame, text, ...)
  if not text then
    return
  end
  
  text = tostring(text)
  
  if not find(text:upper(), '%pTINTERFACE%p+') then
    local regexes = {
      '(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)(%s?)', -- 192.168.2.1:1234
      '(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)(%s?)', -- 192.168.2.1
      '(%s?)([%w_-]+%.?[%w_-]+%.[%w_-]+:%d%d%d?%d?%d?)(%s?)', -- www.url.com:3333
      "(%s?)(%a+://[%w_/%.%?%%=~&-'%-]+)(%s?)", -- http://www.google.com
      "(%s?)(www%.[%w_/%.%?%%=~&-'%-]+)(%s?)", -- www.google.com
      '(%s?)([_%w-%.~-]+@[_%w-]+%.[_%w-%.]+)(%s?)' -- url@domain.com
    }
    local found = false
    for _, regex in pairs(regexes) do
      local newText = ''
      newText = gsub(text, regex, ColorURL)
      if newText ~= text then
        text = newText
        break
      end
    end
  end

  frame.add(frame, text, ...)
end

local function EnableURLCopy()
  for i = 1, NUM_CHAT_WINDOWS do
    local chat = _G['ChatFrame'..i]
    if (chat and not chat.hasURLCopy and (chat ~= 'ChatFrame2')) then
      chat.add = chat.AddMessage
      chat.AddMessage = ScanURL
      chat.hasURLCopy = true
    end
  end
end

local orig = ChatFrame_OnHyperlinkShow
function ChatFrame_OnHyperlinkShow(frame, link, text, button)
  local type, value = link:match('(%a+):(.+)')
  if (type:match('url')) then
    local editBox = _G['ChatFrameEditBox']
    if (editBox) then
      editBox:Show()
      editBox:SetText(link)
      editBox:SetFocus()
      editBox:HighlightText()
    end
  else
    orig(frame, link, text, button)
  end
end

EnableURLCopy()
