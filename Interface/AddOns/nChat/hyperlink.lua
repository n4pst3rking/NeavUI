local cfg = nChat.Config

-- Mouseover Itemlinks in the chat
-- Code provided by the Tukui crew (Tukui.org)

if (not cfg.enableHyperlinkTooltip) then 
    return 
end

local orig1, orig2 = {}, {}
local GameTooltip = GameTooltip

local linktypes = {
    item = true, 
    enchant = true, 
    spell = true, 
    quest = true, 
    unit = true, 
    talent = true
}

local function OnHyperlinkEnter(frame, link, ...)
  local linktype = link:match('^([^:]+)')
  if (linktype and linktypes[linktype]) then
    GameTooltip:SetOwner(this, 'ANCHOR_CURSOR', 0, 20)
    GameTooltip:SetHyperlink(link)
    GameTooltip:Show()
  else
    GameTooltip:Hide()
  end

  if (orig1[frame]) then 
    return orig1[frame](frame, link, ...) 
  end
end

local function OnHyperlinkLeave(frame, ...)
  GameTooltip:Hide()

  if (orig2[frame]) then 
    return orig2[frame](frame, ...) 
  end
end

local function EnableItemLinkTooltip()
  for i = 1, NUM_CHAT_WINDOWS do
    local chat = _G['ChatFrame'..i]
    if (chat and not chat.URLCopy) then
        orig1[chat] = chat:GetScript('OnHyperlinkEnter')
        chat:SetScript('OnHyperlinkEnter', OnHyperlinkEnter)

        orig2[chat] = chat:GetScript('OnHyperlinkLeave')
        chat:SetScript('OnHyperlinkLeave', OnHyperlinkLeave)
        chat.URLCopy = true
    end
  end
end
EnableItemLinkTooltip()
