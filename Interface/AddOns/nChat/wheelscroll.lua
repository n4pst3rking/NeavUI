local cfg = nChat.Config
-- Implement mouse wheel scrolling
local function ScrollOnMouseWheel(chat, value)
  local scrollUp = value > 0
  local scrollDown = not scrollUp
  if (IsMouseOver(chat)) then
    if (IsShiftKeyDown() and cfg.scroll.shiftJump) then
      if (scrollUp) then
        chat:ScrollToTop()
      elseif (scrollDown) then
        chat:ScrollToBottom()
      end
    else
      for i = 1, cfg.scroll.speed do
        if (scrollUp) then
          chat:ScrollUp()
        elseif (scrollDown) then
          chat:ScrollDown()
        end
      end
    end
  end
end

for i=1, NUM_CHAT_WINDOWS do
	local frame = _G['ChatFrame'..i]
	frame:EnableMouseWheel(1)
  frame:SetScript('OnMouseWheel', ScrollOnMouseWheel)
end