local cfg = nChat.Config

local _G = _G
local type = type
local select = select
local unpack = unpack

local gsub = string.gsub
local format = string.format

_G.CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
_G.CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0

_G.CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 0.5
_G.CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0

_G.CHAT_FRAME_FADE_OUT_TIME = 0.25
_G.CHAT_FRAME_FADE_TIME = 0.1

_G.CHAT_FONT_HEIGHTS = {
    [1] = 8,
    [2] = 9,
    [3] = 10,
    [4] = 11,
    [5] = 12,
    [6] = 13,
    [7] = 14,
    [8] = 15,
    [9] = 16,
    [10] = 17,
    [11] = 18,
    [12] = 19,
    [13] = 20,
}

--[[
_G.CHAT_SAY_GET = '%s:\32'
_G.CHAT_YELL_GET = '%s:\32'

_G.CHAT_WHISPER_GET = '[from] %s:\32'
_G.CHAT_WHISPER_INFORM_GET = '[to] %s:\32'

_G.CHAT_BN_WHISPER_GET = '[from] %s:\32'
_G.CHAT_BN_WHISPER_INFORM_GET = '[to] %s:\32'
--]]

_G.CHAT_FLAG_AFK = '[AFK] '
_G.CHAT_FLAG_DND = '[DND] '
_G.CHAT_FLAG_GM = '[GM] '

_G.CHAT_GUILD_GET = '(|Hchannel:Guild|hG|h) %s:\32'
_G.CHAT_OFFICER_GET = '(|Hchannel:o|hO|h) %s:\32'

_G.CHAT_PARTY_GET = '(|Hchannel:party|hP|h) %s:\32'
_G.CHAT_PARTY_LEADER_GET = '(|Hchannel:party|hPL|h) %s:\32'
_G.CHAT_PARTY_GUIDE_GET = '(|Hchannel:party|hDG|h) %s:\32'
_G.CHAT_MONSTER_PARTY_GET = '(|Hchannel:raid|hR|h) %s:\32'

_G.CHAT_RAID_GET = '(|Hchannel:raid|hR|h) %s:\32'
_G.CHAT_RAID_WARNING_GET = '(RW!) %s:\32'
_G.CHAT_RAID_LEADER_GET = '(|Hchannel:raid|hL|h) %s:\32'

_G.CHAT_BATTLEGROUND_GET = '(|Hchannel:Battleground|hBG|h) %s:\32'
_G.CHAT_BATTLEGROUND_LEADER_GET = '(|Hchannel:Battleground|hBL|h) %s:\32'

_G.CHAT_INSTANCE_CHAT_GET = '|Hchannel:INSTANCE_CHAT|h[I]|h %s:\32';
_G.CHAT_INSTANCE_CHAT_LEADER_GET = '|Hchannel:INSTANCE_CHAT|h[IL]|h %s:\32';

--[[
local channelFormat
do
    local a, b = '.*%[(.*)%].*', '%%[%1%%]'
    channelFormat = {
        [1] = {gsub(CHAT_BATTLEGROUND_GET, a, b), '[BG]'},
        [2] = {gsub(CHAT_BATTLEGROUND_LEADER_GET, a, b), '[BGL]'},

        [3] = {gsub(CHAT_GUILD_GET, a, b), '[G]'},
        [4] = {gsub(CHAT_OFFICER_GET, a, b), '[O]'},

        [5] = {gsub(CHAT_PARTY_GET, a, b), '[P]'},
        [6] = {gsub(CHAT_PARTY_LEADER_GET, a, b), '[PL]'},
        [7] = {gsub(CHAT_PARTY_GUIDE_GET, a, b), '[PL]'},

        [8] = {gsub(CHAT_RAID_GET, a, b), '[R]'},
        [9] = {gsub(CHAT_RAID_LEADER_GET, a, b), '[RL]'},
        [10] = {gsub(CHAT_RAID_WARNING_GET, a, b), '[RW]'},

        [11] = {gsub(CHAT_FLAG_AFK, a, b), '[AFK] '},
        [12] = {gsub(CHAT_FLAG_DND, a, b), '[DND] '},
        [13] = {gsub(CHAT_FLAG_GM, a, b), '[GM] '},
    }
end
]]

local AddMessage = ChatFrame1.AddMessage
local function FCF_AddMessage(self, text, ...)
    if (type(text) == 'string') then
        text = gsub(text, '(|HBNplayer.-|h)%[(.-)%]|h', '%1%2|h')
        text = gsub(text, '(|Hplayer.-|h)%[(.-)%]|h', '%1%2|h')
        text = gsub(text, '%[(%d0?)%. (.-)%]', '(%1)')

        --[[
        for i = 1, #channelFormat  do
            text = gsub(text, channelFormat[i][1], channelFormat[i][2])
        end
        --]]
    end

    return AddMessage(self, text, ...)
end

-- Hide the menu
ChatFrameMenuButton:SetAlpha(0)
ChatFrameMenuButton:EnableMouse(false)

-- Tab text colors for the tabs
hooksecurefunc('FCF_DockUpdate', function()
  for i = 1, NUM_CHAT_WINDOWS do
    local chatTab = _G['ChatFrame'..i..'Tab']
    if (_G[SELECTED_CHAT_FRAME:GetName()..'Tab'] == chatTab) then
      chatTab:GetFontString():SetTextColor(0, 0.75, 1)
    else
      chatTab:GetFontString():SetTextColor(1, 1, 1)
    end
  end
end)

-- Modify the chat tabs

local function SkinTab(self)
    local chat = _G[self]

    local tab = _G[self..'Tab']
    for i = 1, select('#', tab:GetRegions()) do
        local texture = select(i, tab:GetRegions())
        if (texture and texture:GetObjectType() == 'Texture') then
            texture:SetTexture(nil)
        end
    end

    local tabText = _G[self..'TabText']
    tabText:SetJustifyH('CENTER')
    tabText:SetWidth(60)
    if (cfg.tab.fontOutline) then
        tabText:SetFont('Fonts\\ARIALN.ttf', cfg.tab.fontSize, 'THINOUTLINE')
        tabText:SetShadowOffset(0, 0)
    else
        tabText:SetFont('Fonts\\ARIALN.ttf', cfg.tab.fontSize)
        tabText:SetShadowOffset(1, -1)
    end

    local a1, a2, a3, a4, a5 = tabText:GetPoint()
    tabText:SetPoint(a1, a2, a3, a4, 1)

    local s1, s2, s3 = unpack(cfg.tab.specialColor)
    local e1, e2, e3 = unpack(cfg.tab.selectedColor)
    local n1, n2, n3 = unpack(cfg.tab.normalColor)

    local tabFlash = _G[self..'TabFlash']
    hooksecurefunc(tabFlash, 'Show', function()
        tabText:SetTextColor(s1, s2, s3, CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA)
    end)

    hooksecurefunc(tabFlash, 'Hide', function()
        tabText:SetTextColor(n1, n2, n3)
    end)

    tab:SetScript('OnEnter', function()
        tabText:SetTextColor(s1, s2, s3, tabText:GetAlpha())
    end)

    tab:SetScript('OnLeave', function()
        local hasNofication = tabFlash:IsShown()

        local r, g, b
        if (_G[self] == SELECTED_CHAT_FRAME and chat.isDocked) then
            r, g, b = e1, e2, e3
        elseif (hasNofication) then
            r, g, b = s1, s2, s3
        else
            r, g, b = n1, n2, n3
        end

        tabText:SetTextColor(r, g, b)
    end)

    hooksecurefunc(tab, 'Show', function()
        if (not tab.wasShown) then
            local hasNofication = tabFlash:IsShown()
            
            chat:EnableMouse(true)
            if (IsMouseOver(chat)) then
                tab:SetAlpha(CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA)
            else
                tab:SetAlpha(CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA)
            end

            local r, g, b
            if (_G[self] == SELECTED_CHAT_FRAME and chat.isDocked) then
                r, g, b = e1, e2, e3
            elseif (hasNofication) then
                r, g, b = s1, s2, s3
            else
                r, g, b = n1, n2, n3
            end

            tabText:SetTextColor(r, g, b)

            tab.wasShown = true
        end
    end)
end

local function ModChat(self)
    local chat = _G[self]

    if (not cfg.chatOutline) then
        chat:SetShadowOffset(1, -1)
    end

    SkinTab(self)

    local font, fontsize, fontflags = chat:GetFont()
    chat:SetFont(font, fontsize, cfg.chatOutline and 'THINOUTLINE' or fontflags)
    chat:SetClampedToScreen(false)

    chat:SetClampRectInsets(0, 0, 0, 0)
    chat:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
    chat:SetMinResize(150, 25)

    if (self ~= 'ChatFrame2') then
        chat.AddMessage = FCF_AddMessage
    end

    local buttonUp = _G[self..'UpButton']
    buttonUp:SetAlpha(0)
    buttonUp:EnableMouse(false)

    local buttonDown = _G[self..'DownButton']
    buttonDown:SetAlpha(0)
    buttonDown:EnableMouse(false)

    local buttonBottom = _G[self..'BottomButton']
    buttonBottom:SetAlpha(0)
    buttonBottom:EnableMouse(false)

    -- for _, texture in pairs({
        -- 'ButtonFrameBackground',
        -- 'ButtonFrameTopLeftTexture',
        -- 'ButtonFrameBottomLeftTexture',
        -- 'ButtonFrameTopRightTexture',
        -- 'ButtonFrameBottomRightTexture',
        -- 'ButtonFrameLeftTexture',
        -- 'ButtonFrameRightTexture',
        -- 'ButtonFrameBottomTexture',
        -- 'ButtonFrameTopTexture',
    -- }) do
      -- _G[self..texture]:SetTexture(nil)
    -- end
end

local function SetChatStyle()
  for i = 1, NUM_CHAT_WINDOWS do
    local chat = _G['ChatFrame'..i]
    if (chat and not chat.hasModification) then
        ModChat(chat:GetName())
        chat.hasModification = true
    end
  end

  -- Modify the editbox

  for k = 6, 8 do
    select(k, _G['ChatFrameEditBox']:GetRegions()):SetTexture(nil)
  end

  _G['ChatFrameEditBox']:SetAltArrowKeyMode(false)

  if (cfg.showInputBoxAbove) then
    _G['ChatFrameEditBox']:ClearAllPoints()
    _G['ChatFrameEditBox']:SetPoint('BOTTOMLEFT', 'ChatFrame1', 'TOPLEFT', 2, 33)
    _G['ChatFrameEditBox']:SetPoint('BOTTOMRIGHT', 'ChatFrame1', 'TOPRIGHT', 0, 33)
  end
  _G['ChatFrameEditBox']:SetBackdrop({
      bgFile = 'Interface\\Buttons\\WHITE8x8',
      insets = {
          left = 3, right = 3, top = 2, bottom = 2
      },
  })
  _G['ChatFrameEditBox']:SetBackdropColor(0, 0, 0, 0.5)
  _G['ChatFrameEditBox']:CreateBeautyBorder(11)
  _G['ChatFrameEditBox']:SetBeautyBorderPadding(-2, -1, -2, -1, -2, -1, -2, -1)

  if (cfg.enableBorderColoring) then
      _G['ChatFrameEditBox']:SetBeautyBorderTexture('white')

      hooksecurefunc('ChatEdit_UpdateHeader', function(editBox)
          local type = editBox:GetAttribute('chatType')
          if (not type) then
              return
          end

          local info = ChatTypeInfo[type]
          _G['ChatFrameEditBox']:SetBeautyBorderColor(info.r, info.g, info.b)
      end)
  end
end
SetChatStyle()

-- Chat menu, just a middle click on the chatframe 1 tab
ChatFrame1Tab:RegisterForClicks('AnyUp')
ChatFrame1Tab:HookScript('OnClick', function(self, button)
    if (button == 'MiddleButton' or button == 'Button4' or button == 'Button5') then
        if (ChatMenu:IsShown()) then
            ChatMenu:Hide()
        else
            ChatMenu:Show()
        end
    else
        ChatMenu:Hide()
    end
end)

    -- Modify the gm chatframe and add a sound notification on incoming whispers

local f = CreateFrame('Frame')
f:RegisterEvent('ADDON_LOADED')
f:RegisterEvent('CHAT_MSG_WHISPER')
f:RegisterEvent('CHAT_MSG_BN_WHISPER')
f:SetScript('OnEvent', function(_, event)
    if (event == 'ADDON_LOADED' and arg1 == 'Blizzard_GMChatUI') then
        GMChatFrame:EnableMouseWheel(true)
        GMChatFrame:SetScript('OnMouseWheel', ChatFrame1:GetScript('OnMouseWheel'))
        GMChatFrame:SetHeight(200)

        GMChatFrameUpButton:SetAlpha(0)
        GMChatFrameUpButton:EnableMouse(false)

        GMChatFrameDownButton:SetAlpha(0)
        GMChatFrameDownButton:EnableMouse(false)

        GMChatFrameBottomButton:SetAlpha(0)
        GMChatFrameBottomButton:EnableMouse(false)
    end

    if (event == 'CHAT_MSG_WHISPER' or event == 'CHAT_MSG_BN_WHISPER') then
        PlaySoundFile('Sound\\Spells\\Simongame_visual_gametick.wav')
    end
end)

local combatLog = {
    text = 'CombatLog',
    colorCode = '|cffFFD100',
    isNotRadio = true,

    func = function()
        if (not LoggingCombat()) then
            LoggingCombat(true)
            DEFAULT_CHAT_FRAME:AddMessage(COMBATLOGENABLED, 1, 1, 0)
        else
            LoggingCombat(false)
            DEFAULT_CHAT_FRAME:AddMessage(COMBATLOGDISABLED, 1, 1, 0)
        end
    end,

    checked = function()
        if (LoggingCombat()) then
            return true
        else
            return false
        end
    end
}

local chatLog = {
    text = 'ChatLog',
    colorCode = '|cffFFD100',
    isNotRadio = true,

    func = function()
        if (not LoggingChat()) then
            LoggingChat(true)
            DEFAULT_CHAT_FRAME:AddMessage(CHATLOGENABLED, 1, 1, 0)
        else
            LoggingChat(false)
            DEFAULT_CHAT_FRAME:AddMessage(CHATLOGDISABLED, 1, 1, 0)
        end
    end,

    checked = function()
        if (LoggingChat()) then
            return true
        else
            return false
        end
    end
}

local origFCF_Tab_OnClick = _G.FCF_Tab_OnClick
local function FCF_Tab_OnClickHook(chatTab, ...)
    origFCF_Tab_OnClick(chatTab, ...)

    combatLog.arg1 = chatTab
    UIDropDownMenu_AddButton(combatLog)

    chatLog.arg1 = chatTab
    UIDropDownMenu_AddButton(chatLog)
end
FCF_Tab_OnClick = FCF_Tab_OnClickHook

if (cfg.enableChatWindowBorder) then
    for i = 1, NUM_CHAT_WINDOWS do
        local cf = _G['ChatFrame'..i]
        if (cf) then
            cf:CreateBeautyBorder(12)
            cf:SetBeautyBorderPadding(5, 5, 5, 5, 5, 8, 5, 8)
        end
    end

    local ct = _G['ChatFrame2']
    if (ct) then
        ct:CreateBeautyBorder(12)
        ct:SetBeautyBorderPadding(5, 29, 5, 29, 5, 8, 5, 8)
    end
end
