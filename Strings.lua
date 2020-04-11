local _, CsAlert = ...

local strings = {}

-- enUS locale
strings.enUS = {
    addonLoaded         = "CounterspellAlert loaded.  Use /csalert to configure.",
    globalSettings      = "Global settings",
    charaSettings       = "Character-specific settings",
    testMode            = "Test mode",
    testModeDesc        = "Causes announcements to be shown in default chat frame instead, overriding " ..
                          "broadcast settings and allowing announces out of instances.",
    showAllDebuff       = "Show all debuffs",
    showAllDebuffDesc   = "Includes spells out of the spell database, and ignores the minimum debuff " ..
                          "duration setting.",
    minDebuffDuration   = "Minimum debuff duration to announce",
    seconds             = "sec(s)",
    debuffTypeText      = "Types of debuff to announce",
    broadcastSettings   = "Broadcast settings",
    statuses = {
        counterspell    = "Counterspelled",
        asleep          = "Asleep",
        banish          = "Banished",
        charm           = "Charmed",
        disorient       = "Disoriented",
        fear            = "Feared",
        incapacitate    = "Incapacitated",
        mindcontrol     = "Mind Controlled",
        polymorph       = "Polymorphed",
        root            = "Rooted",
        silence         = "Silenced",
        stun            = "Stunned"
    },
    instanceTypes = {
        party           = "Party",
        raid            = "Raid",
        pvp             = "Battlegrounds"
    },
    broadcastTargets = {
        NONE            = "Disabled",
        SAY             = "/s - Say",
        YELL            = "/y - Yell",
        PARTY           = "/p - Party",
        RAID            = "/raid - Raid",
        INSTANCE_CHAT   = "/bg - Battlegrounds"
    },
    authorInfo          = "created by Silverhawke -- @fluffderg",
    dumpSettings        = "Dumping current settings...",
    dumpSpells          = "Dumping spells in database..."
}

local locale = GetLocale()
CsAlert.strings = strings[locale] or {}

-- Copy missing table values from enUS
-- So that missing localizations won't break the strings
CsAlert.func.updateTable(CsAlert.strings, strings.enUS, true)
