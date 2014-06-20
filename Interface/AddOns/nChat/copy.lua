local select = select
local tostring = tostring
local concat = table.concat

-- First, we create the copy frame
local f = CreateFrame('Frame', nil, UIParent)
SetSize(f, 220, 200)
f:SetBackdropColor(0, 0, 0, 1)
f:SetPoint('BOTTOMLEFT', ChatFrameEditBox, 'TOPLEFT', 3, 10)
f:SetPoint('BOTTOMRIGHT', ChatFrameEditBox, 'TOPRIGHT', -3, 10)
f:SetFrameStrata('DIALOG')
f:CreateBeautyBorder(12)
f:SetBackdrop({
    bgFile = 'Interface\\DialogFrame\\UI-DialogBox-Background',
    edgeFile = '',
    tile = true, tileSize = 16, edgeSize = 16,
    insets = {left = 3, right = 3, top = 3, bottom = 3
}})
f:Hide()

f.t = f:CreateFontString(nil, 'OVERLAY')
f.t:SetFont('Fonts\\ARIALN.ttf', 18)
f.t:SetPoint('TOPLEFT', f, 8, -8)
f.t:SetTextColor(1, 1, 0)
f.t:SetShadowOffset(1, -1)
f.t:SetJustifyH('LEFT')

f.b = CreateFrame('EditBox', nil, f)
f.b:SetMultiLine(true)
f.b:SetMaxLetters(20000)
SetSize(f.b, 450, 270)
f.b:SetScript('OnEscapePressed', function()
    f:Hide() 
end)

f.s = CreateFrame('ScrollFrame', '$parentScrollBar', f, 'UIPanelScrollFrameTemplate')
f.s:SetPoint('TOPLEFT', f, 'TOPLEFT', 8, -30)
f.s:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -30, 8)
f.s:SetScrollChild(f.b)

f.c = CreateFrame('Button', nil, f, 'UIPanelCloseButton')
f.c:SetPoint('TOPRIGHT', f, 'TOPRIGHT', 0, -1)

local lines = {}
local function GetChatLines(...)
    local count = 1
    for i = select('#', ...), 1, -1 do
        local region = select(i, ...)
        if (region:GetObjectType() == 'FontString') then
            lines[count] = tostring(region:GetText())
            count = count + 1
        end
    end

    return count - 1
end

local function copyChat(chat)
    local _, fontSize = chat:GetFont()

    FCF_SetChatWindowFontSize(chat, 0.1)
    local lineCount = GetChatLines(chat:GetRegions())
    FCF_SetChatWindowFontSize(chat, fontSize)

    if (lineCount > 0) then
      f:Show()
      f.t:SetText(_G[chat:GetName()..'Tab']:GetText())

      local f1, f2, f3 = ChatFrame1:GetFont()
      f.b:SetFont(f1, f2, f3)

      local text = concat(lines, '\n', 1, lineCount)
      f.b:SetText(text)
    end
end

local function CreateCopyButton(chat)
    chat.Copy = CreateFrame('Button', 'CopyChatButton', _G[chat:GetName()])
    SetSize(chat.Copy, 20, 20)
    chat.Copy:SetPoint('TOPRIGHT', chat, -5, -5)

    chat.Copy:SetNormalTexture('Interface\\AddOns\\nChat\\media\\textureCopyNormal')
    SetSize(chat.Copy:GetNormalTexture(), 20, 20)

    chat.Copy:SetHighlightTexture('Interface\\AddOns\\nChat\\media\\textureCopyHighlight')
    chat.Copy:GetHighlightTexture():SetAllPoints(chat.Copy:GetNormalTexture())

    local tab = _G[chat:GetName()..'Tab']
    hooksecurefunc(tab, 'SetAlpha', function()
        chat.Copy:SetAlpha(tab:GetAlpha() * 0.55)
    end)
    
    subscribe(chat.Copy, 'OnMouseDown', function(self)
      self:GetNormalTexture():ClearAllPoints()
      self:GetNormalTexture():SetPoint('CENTER', 1, -1)
    end)
    
    subscribe(chat.Copy, 'OnMouseUp', function(self)
        self:GetNormalTexture():ClearAllPoints()
        self:GetNormalTexture():SetPoint('CENTER')
        
        if (IsMouseOver(self)) then
          copyChat(chat)
        end
    end)
    
    chat.Copy:SetAlpha(0)
end

local function EnableCopyButton()
  for i = 1, NUM_CHAT_WINDOWS do
    local chat = _G['ChatFrame'..i]
    if (chat and not chat.Copy) then
      CreateCopyButton(chat)
    end
  end
end
EnableCopyButton()
