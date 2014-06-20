
    -- THANKS & CREDITS GOES TO Freebaser (oUF_Freebgrid)
    -- http://www.wowinterface.com/downloads/info12264-oUF_Freebgrid.html

local ns = oUFNeavRaid
local oUF = ns.oUF or oUF

local spellcache = setmetatable({}, {__index=function(t,v)
    local a = {GetSpellInfo(v)}
    if (GetSpellInfo(v)) then
        t[v] = a
    end

    return a
end})

local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

    -- instance name and the instance ID,
    -- find out the instance ID by typing this in the chat "/run print(GetCurrentMapAreaID())"
    -- Note: Just must be in this instance, when you run the script above

local L = {
    ['Siege of Orgrimmar'] = 953,
    ['Throne of Thunder'] = 930,
    ['Terrace of Endless Spring'] = 886,
    ['Heart of Fear'] = 897,
    ['Mogu\'shan Vaults'] = 896,

    ['Baradin Hold'] = 752,
    ['Blackwing Descent'] = 754,
    ['The Bastion of Twilight'] = 758,
    ['Throne of the Four Winds'] = 773,
    ['Firelands'] = 800,
    ['Dragon Soul'] = 824,

    -- ['Ulduar'] = 529,
    ['ToC'] = 543,
    ['Naxxramas'] = 535,
    ['Ruby Sanctum'] = 531,
    ['Icecrown'] = 604,

    -- ['Tol Barad'] = 708,
    -- ['Lost City Tol'vir'] = 747,
    -- ['Deadmines'] = 756,
    -- ['Grim Batol'] = 757,
    -- ['Shadowfang'] = 764,
    -- ['Throne of Tides'] = 767,

    -- ['Zul'Gurub'] = 697 or 793,
    -- ['Zul'Aman'] = 781,
}

ns.auras = {

        -- Ascending aura timer
        -- Add spells to this list to have the aura time count up from 0
        -- NOTE: This does not show the aura, it needs to be in one of the other list too.

    ascending = {
        -- [GetSpellInfo(89421)] = true, -- Wrack
    },

        -- General debuffs

    debuffs = {
        -- [GetSpellInfo(115804)] = 9, -- Mortal Wounds
        -- [GetSpellInfo(113746)] = 9, -- Weakened Armor
        -- [GetSpellInfo(51372)] = 1, -- Daze
        [GetSpellInfo(5246)] = 5, -- Intimidating Shout
        [GetSpellInfo(6788)] = 16, -- Weakened Soul
    },

        -- Buffs

    buffs = {
        [GetSpellInfo(871)] = 15, -- Shield Wall
        -- [GetSpellInfo(61336)] = 15, -- Survival Instincts
        -- [GetSpellInfo(31850)] = 15, -- Ardent Defender
        [GetSpellInfo(498)] = 15, -- Divine Protection
        [GetSpellInfo(33206)] = 15, -- Pain Suppression
    },

        -- Raid Debuffs

    instances = {

            -- Icecrown

        [L['Icecrown']] = {
            -- [GetSpellInfo(69057)] = 9, -- Bone Spike Graveyard
            -- [GetSpellInfo(72410)] = 9, -- Rune of Blood
            -- [GetSpellInfo(72293)] = 10, -- Mark of the Fallen Champion, Deathbringer Saurfang

            -- [GetSpellInfo(69674)] = 9, -- Mutated Infection, Rotface
            -- [GetSpellInfo(72272)] = 9, -- Vile Gas, Festergut
            -- [GetSpellInfo(69279)] = 8, -- Gas Spore, Festergut

            -- [GetSpellInfo(70126)] = 9, -- Frost Beacon, Sindragosa

            -- [GetSpellInfo(70337)] = 9, -- Necrotic Plague, Lich King
            -- [GetSpellInfo(70541)] = 6, -- Infest, Lich King
            -- [GetSpellInfo(72754)] = 8, -- Defile, Lich King
            -- [GetSpellInfo(68980)] = 10, -- Harvest Soul, Lich King
        },
    },
}
