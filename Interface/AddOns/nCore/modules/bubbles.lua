
local events = {
    CHAT_MSG_SAY = 'chatBubbles', 
    CHAT_MSG_YELL = 'chatBubbles',
    CHAT_MSG_PARTY = 'chatBubblesParty', 
    CHAT_MSG_PARTY_LEADER = 'chatBubblesParty',
    CHAT_MSG_MONSTER_SAY = 'chatBubbles', 
    CHAT_MSG_MONSTER_YELL = 'chatBubbles', 
    CHAT_MSG_MONSTER_PARTY = 'chatBubblesParty',
}

local function SkinFrame(frame)
    for i = 1, select('#', frame:GetRegions()) do
        local region = select(i, frame:GetRegions())
        if (region:GetObjectType() == 'FontString') then
            frame.text = region
        else
            region:Hide()
        end
    end

    frame.text:SetFontObject('GameFontHighlight')
    frame.text:SetJustifyH('LEFT')

    frame:ClearAllPoints()
    frame:SetPoint('TOPLEFT', frame.text, -10, 25)
    frame:SetPoint('BOTTOMRIGHT', frame.text, 10, -10)
    frame:SetBackdrop({
        bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background',
        edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border',
        tileSize = 16,
        edgeSize = 16,
        insets = {left=3, right=3, top=3, bottom=3},
    })
    frame:SetBackdropColor(0, 0, 0, 1)
    frame:SetBackdropBorderColor(.5, .5, .5, 0.9)

    frame.sender = frame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    frame.sender:SetPoint('BOTTOMLEFT', frame.text, 'TOPLEFT', 0, 4)
    frame.sender:SetJustifyH('LEFT')

    frame:SetScript('OnHide', function() 
        frame.inUse = false 
    end)
end

local function UpdateFrame(frame, name)
    if (not frame.text) then 
        SkinFrame(frame) 
    end
    frame.inUse = true

    local class
    if (name ~= nil and name ~= '') then
        _, class = UnitClass(name)
    end

    if (name) then
        local color = RAID_CLASS_COLORS[class] or { r = 0.5, g = 0.5, b = 0.5 }
        frame.sender:SetText(('|cFF%2x%2x%2x%s|r'):format(color.r * 255, color.g * 255, color.b * 255, name))
        if frame.text:GetWidth() < frame.sender:GetWidth() then
            frame.text:SetWidth(frame.sender:GetWidth() + (frame.sender:GetWidth() - frame.text:GetWidth()))
        end
    end
end

local function FindFrame(msg)
    for i = 1, WorldFrame:GetNumChildren() do
        local frame = select(i, WorldFrame:GetChildren())
        if (not frame:GetName() and not frame.inUse) then
            for i = 1, select('#', frame:GetRegions()) do
                local region = select(i, frame:GetRegions())
                if region:GetObjectType() == 'FontString' and region:GetText() == msg then
                    return frame
                end
            end
        end
    end
end

local f = CreateFrame('Frame')
for event, cvar in pairs(events) do
    f:RegisterEvent(event) 
end

f:SetScript('OnEvent', function(self, event, msg, sender)
    if (GetCVar(events[event]) == '1') then
        f.elapsed = 0
        f:SetScript('OnUpdate', function(self, elapsed)
            self.elapsed = self.elapsed + elapsed
            local frame = FindFrame(msg)
            if (frame or self.elapsed > 0.3) then
                f:SetScript('OnUpdate', nil)
                if (frame) then 
                    UpdateFrame(frame, sender) 
                end
            end
        end)
    end
end)