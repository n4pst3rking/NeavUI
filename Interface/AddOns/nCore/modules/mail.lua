local floor = math.floor

-- until we find a way to get all attachments with one click, we will disable this mod
if true then
  return
end

function GetCoinString(money)
  local c = function(str, r, g, b)
    return format('|cff%02x%02x%02x%s|r', r, g, b, str)
  end
  
  local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD))
  local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER)
  local copper = mod(money, COPPER_PER_SILVER)
  
  return gold..c('G ', 229, 207, 95)..silver..c('S ', 160, 160, 160)..copper..c('C ', 153, 87, 53);
end

local f = CreateFrame('Button', nil, InboxFrame, 'UIPanelButtonTemplate')
f:SetPoint('TOPRIGHT', -58, -50)
SetSize(f, 100, 22)
f:SetText(OPENMAIL)

local totalMoney = 0
local processing = false
local function OnEvent()
    if (not MailFrame:IsShown()) then
        return 
    end

    local num = GetInboxNumItems()
    if (processing) then
        if (num == 0) then
            MiniMapMailFrame:Hide()
            processing = false
            return
        end

        for i = num, 1, -1 do
            local _, _, _, _, money, COD, _, item = GetInboxHeaderInfo(i)
            if (item and COD < 1) then
              for _ = item, 1, -1 do
                DEFAULT_CHAT_FRAME:AddMessage('fetching '.._)
                TakeInboxItem(i, _)
              end
            end

            if (money > 0) then
                totalMoney = totalMoney + money
                DEFAULT_CHAT_FRAME:AddMessage('money '..money)
                TakeInboxMoney(i)
            end
        end

        if (totalMoney > 0) then
            local chatWindowFontSize = select(2, GetChatWindowInfo(1))
            DEFAULT_CHAT_FRAME:AddMessage('Total money collected from mailbox was '..GetCoinString(totalMoney)..'.')
        end
    end
end

f:SetScript('OnClick', function(self) 
    if (not processing) then 
        totalMoney = 0
        processing = true 
        OnEvent() 
    end 
end)

f:SetScript('OnHide', function(self) 
    processing = false 
end)
