local _, CsAlert = ...

-- Default settings
CsAlert.globalSettings = {
    testMode = true,
    showAllDebuff = false
}
CsAlert.charaSettings = {
    minDebuffDuration = 3,
    shownDebuffType = {
        counterspell=true,
        asleep=true,
        banish=true,
        charm=true,
        disorient=true,
        fear=false,
        incapacitate=true,
        mindcontrol=true,
        polymorph=true,
        root=false,
        silence=true,
        stun=true
    },
    broadcastSettings = {
        party="SAY",
        raid="NONE",
        pvp="YELL"
    }
}

-- EVENT HANDLERS --
function CsAlert.handler(self, event, ...)
    CsAlert.onEvent[event](self, ...)
end

CsAlert.onEvent = {}

function CsAlert.onEvent.COMBAT_LOG_EVENT_UNFILTERED(self)
    local inInstance, instanceType = IsInInstance()

    -- In onEvent, SendChatMessage only works inside instances.
    if not (inInstance or CsAlert.testMode) then
        return
    end

    -- Check if current instance type is set to broadcast, and get broadcast target
    if CsAlert_CharaSettings.broadcastSettings[instanceType] == "NONE" and not CsAlert_GlobalSettings.showAllDebuff then
        return
    end
    local msgTarget = CsAlert_CharaSettings.broadcastSettings[instanceType]

    -- Get payload from CLEU
    local _, eventName, _, _, sourceName, _, sourceRaidFlags, destGUID = CombatLogGetCurrentEventInfo()
    local spellName = select(13, CombatLogGetCurrentEventInfo())

    -- Ignore all spells not targeted at the player
    if destGUID ~= UnitGUID("player") then
        return
    end

    -- Ignore spells not in the database
    if not CsAlert.spellList[spellName] and not CsAlert_GlobalSettings.showAllDebuff then
        return
    end

    -- Ignore spells whose category is disabled
    local ignoreSpell = true
    for spType, include in pairs(CsAlert_CharaSettings.shownDebuffType) do
        if include and CsAlert.spellTypeDb[spType][spellName] then
            ignoreSpell = false
            break
        end
    end
    if ignoreSpell then
        return
    end

    if eventName == "SPELL_INTERRUPT" then
        if CsAlert.spellTypeDb.counterspell[spellName] then
            local extraSpellName = select(16, CombatLogGetCurrentEventInfo())
            local raidFlag = CsAlert.func.getRaidTargetString(sourceRaidFlags)

            -- If GetSpellLossOfControlCooldown is queried now, it won't have the information available yet
            -- Using a different event trigger to get around this until a better way is found
            C_ChatInfo.SendAddonMessage("CsAlert", ("%s|%s|%s|%s|%s"):format(extraSpellName, spellName, sourceName, msgTarget, raidFlag), "SAY")
        end
    elseif eventName == "SPELL_AURA_APPLIED" or eventName == "SPELL_AURA_APPLIED_DOSE" or eventName == "SPELL_AURA_REFRESH" then
        -- Check what spell applied the aura
        -- We need to use UnitDebuff to get duration of aura though...
        local raidFlag = CsAlert.func.getRaidTargetString(sourceRaidFlags)
        local message

        for i = 1, 40 do
            local name, _, _, _, duration, _, source, _, _, spellId = UnitDebuff("player", 41 - i)
            -- `source` is the UnitId that casted the aura on the player...
            -- However, sometimes it returns nil, so it's not 100% reliable
            -- For now, we'll just check if the spell name matches.
            if name ~= nil and GetSpellInfo(spellId) == spellName then
                if not CsAlert_GlobalSettings.showAllDebuffs and duration < CsAlert_CharaSettings.minDebuffDuration then
                    return
                end

                if raidFlag ~= "" and raidFlag ~= nil then
                    message = ("Afflicted: %is %s from {%s} %s"):format(duration, name, raidFlag, sourceName)
                else
                    message = ("Afflicted: %is %s from %s"):format(duration, name, sourceName)
                end
                break
            end
        end

        if message then
            CsAlert.func.announce(message, msgTarget)
        end
    end
end

function CsAlert.onEvent.CHAT_MSG_ADDON(self, ...)
    local prefix, text, _, sender = ...

    -- Only accept messages from this addon, sent by player
    if prefix ~= "CsAlert" or sender ~= UnitName("player") .. '-' .. GetNormalizedRealmName() then
        return
    end

    -- Extract parameters back from the message
    local t = {}
    for s in text:gmatch("([^|]+)") do
        table.insert(t, s)
    end

    local extraSpellName, _, sourceName, msgTarget, raidFlag = unpack(t)
    local _, duration = GetSpellLossOfControlCooldown(extraSpellName)
    local message = ""
    if duration > 0 and duration >= CsAlert_CharaSettings.minDebuffDuration then
        if raidFlag ~= "" and raidFlag ~= nil then
            message = ("Afflicted: %is spell-lock from {%s} %s"):format(duration, raidFlag, sourceName)
        else
            message = ("Afflicted: %is spell-lock from %s"):format(duration, sourceName)
        end
    end

    CsAlert.func.announce(message, msgTarget)
end

function CsAlert.onEvent.ADDON_LOADED(self, addonName)
    if addonName == 'CounterspellAlert' then
        local globalSettings, charaSettings
        globalSettings = CsAlert.func.filterTable(CsAlert_GlobalSettings, CsAlert.globalSettings)
        charaSettings = CsAlert.func.filterTable(CsAlert_CharaSettings, CsAlert.charaSettings)
        CsAlert_GlobalSettings = CsAlert.func.deepCopy(CsAlert.globalSettings)
        CsAlert_CharaSettings = CsAlert.func.deepCopy(CsAlert.charaSettings)
        CsAlert.func.updateTable(CsAlert_GlobalSettings, globalSettings)
        CsAlert.func.updateTable(CsAlert_CharaSettings, charaSettings)

        CsAlert.func.updateOptions(CsAlert_GlobalSettings, CsAlert_CharaSettings)

        print("|cffff7f3f" .. CsAlert.strings.addonLoaded)
    end
end

-- Create main frame
local mainFrame = CreateFrame("Frame")
mainFrame:RegisterEvent("ADDON_LOADED")
mainFrame:RegisterEvent("CHAT_MSG_ADDON")
mainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
mainFrame:SetScript("OnEvent", CsAlert.handler)
C_ChatInfo.RegisterAddonMessagePrefix("CsAlert")

-- Assign slash command
SLASH_CSALERT1 = "/csalert"
function SlashCmdList.CSALERT(arg)
    local t = {}
    for s in arg:gmatch("([^ ]+)") do
        table.insert(t, s)
    end

    if t[1] == "dump" then
        if t[2] == "settings" then
            print("|cffff7f3f<CsAlert>|r " .. CsAlert.strings.dumpSettings)
            print(CsAlert.strings.globalSettings .. ":")
            CsAlert.func.dumpTable(CsAlert_GlobalSettings)
            print(CsAlert.strings.charaSettings .. ":")
            CsAlert.func.dumpTable(CsAlert_CharaSettings)
        elseif t[2] == "spells" then
            print("|cffff7f3f<CsAlert>|r " .. CsAlert.strings.dumpSpells)
            CsAlert.func.dumpTable(CsAlert.spellTypeDb)
        end
    else
        InterfaceOptionsFrame_OpenToCategory(CsAlert.optionsFrame)
    end
end
