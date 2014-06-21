--[[
	SquidMod
	Author: SAM (recoded by Ganders) - (Grafic Patch by Imithat)
	Version: 2.49
]]

SquidMod = {}

local ns = SquidMod

local frame = CreateFrame("Frame")

ns.textures = {
	"hide",
	"griffon",
	"lion",
	"diablo1",
	"diablo1_roth",
	"diablo2",
	"diablo2_roth",
	"murloc",
	"murloc2",
	"hordecrest",
	"orccrest",
	"allianzcrest",
	"huntercrest",
	"druidcrest",
	"pandacrest",
	"nightelfcrest",
	"priestcrest",
	"dkcrest",
	"magecrest",
	"monkcrest",
	"palacrest",
	"roguecrest",
	"shamancrest",
	"shamancrest2",
	"warlockcrest",
	"warriorcrest",
	"worg",
	"bfmage",
	"panda",
	"pandakind",
	"swking",
	"draenei",
	"druidtree",
	"druidbear",
	"lichking",
	"nightelf",
	"onyxia",
	"orc",
	"orc2",
	"ysera",
	"drake",
	"bleach",
	"wowlogo",
	"orbdaemon",
	"yulon",
	"xuen",
	"niuzao",
	"minichi",
	"minidroplet",
	"miniporcupette",
	"minisha",
	"minixuen",
	"miniyulon",
}

local textures = ns.textures

function ns.GetDefault()
	local _, class = UnitClass('player')
	if (class == 'HUNTER') then
		return 13
	elseif class == 'DRUID' then
		return 14
	elseif class == 'PRIEST' then
		return 17
	elseif class == 'MAGE' then
		return 19
	elseif class == 'PALADIN' then
		return 21
  elseif class == 'ROGUE' then
  	return 22
  elseif class == 'SHAMAN' then
  	local _, faction = UnitFaction('player')
  	return faction == 'Alliance' and 23 or 24
  elseif class == 'WARLOCK' then
  	return 25
  elseif class == 'WARRIOR' then
  	return 26
	end
	return 2
end

SquidModDB = ns.GetDefault()

function frame.SlashCommand(msg)
	local self = frame
	if strlen(msg) > 0 then
		local command = string.lower(msg)
		local help = true
		if ( type(command) == "string" ) then
			for i,v in ipairs(textures) do
				if ( command == string.lower(v) ) then
					self:Update(i)
					DEFAULT_CHAT_FRAME:AddMessage("SquidMod: "..string.lower(v))
					help = false
				end
			end
		elseif ( type(command) == "number" ) then
			if textures[command] ~= nil then
				self:Update(command)
				DEFAULT_CHAT_FRAME:AddMessage("SquidMod: "..string.lower(textures[command]))
				help = false
			end
		end

		if ( help == true ) then
			for i,v in ipairs(textures) do
				DEFAULT_CHAT_FRAME:AddMessage("SquidMod: /squid "..v)
			end
		end
	else
		InterfaceOptionsFrame_OpenToFrame(ns.SelectFrame.name)
		-- for i,v in ipairs(textures) do
		-- 	DEFAULT_CHAT_FRAME:AddMessage("SquidMod: /squid "..v)
		-- end
	end
end
		

function frame:Update(toggle)
	if ( toggle == 1 ) then
		MainMenuBarLeftEndCap:Hide()
		MainMenuBarRightEndCap:Hide()
	else
		MainMenuBarLeftEndCap:SetTexture("Interface\\AddOns\\SquidMod\\skin\\"..textures[toggle]..".tga")
		MainMenuBarRightEndCap:SetTexture("Interface\\AddOns\\SquidMod\\skin\\"..textures[toggle]..".tga")
		MainMenuBarLeftEndCap:Show()
		MainMenuBarRightEndCap:Show()
	end
	SquidModDB = toggle
end

frame:SetScript("OnEvent", function() ns.LoadFrame:Update(SquidModDB) end)
frame:RegisterEvent("PLAYER_LOGIN")

SLASH_SQUID1 = "/squid"
SlashCmdList["SQUID"] = frame.SlashCommand

ns.LoadFrame = frame