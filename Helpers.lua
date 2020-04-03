local _, CsAlert = ...

CsAlert.func = {}

-- Announces messages
function CsAlert.func.announce(message, target)
    if CsAlert_GlobalSettings.testMode then
        print("|cffff7f3f<CsAlert>|r " .. message)
    else
        SendChatMessage(message, target)
    end
end

-- Converts flag values to chat-friendly raid target marker
function CsAlert.func.getRaidTargetString(flag)
    if flag == 0x01 then
        return "rt1"
    elseif flag == 0x02 then
        return "rt2"
    elseif flag == 0x04 then
        return "rt3"
    elseif flag == 0x08 then
        return "rt4"
    elseif flag == 0x10 then
        return "rt5"
    elseif flag == 0x20 then
        return "rt6"
    elseif flag == 0x40 then
        return "rt7"
    elseif flag == 0x80 then
        return "rt8"
    else
        return ""
    end
end

-- Iterates over a table sorted by keys
function CsAlert.func.sortedKeyIter(t, comp)
    local keys = {}
    for k, _ in pairs(t) do
        tinsert(keys, k)
    end
    sort(keys, comp)

    local i = 0
    local iter = function()
        i = i + 1
        if keys[i] == nil then return nil
        else return keys[i], t[keys[i]]
        end
    end

    return iter
end

-- Creates a header with a line under it
function CsAlert.func.createHeader(text, parent, ofsx, ofsy, fontObj)
    local fs = parent:CreateFontString(nil, "ARTWORK")
    fontObj = fontObj or GameFontNormalLarge
    fs:SetFontObject(fontObj)
    fs:SetText(text)
    fs:SetPoint("TOPLEFT", parent, "TOPLEFT", ofsx, ofsy)

    local line = parent:CreateLine()
    line:SetColorTexture(1, 1, 1, 0.3)
    line:SetStartPoint("TOPLEFT", fs, 0, -3 - fs:GetStringHeight())
    line:SetEndPoint("TOPRIGHT", fs, 5, -3 - fs:GetStringHeight())
    line:SetThickness(1.5)

    return fs
end

-- Sorts chatTypeIds in a particular order
local chatTypeIdOrder = {NONE=1, SAY=2, YELL=3, PARTY=4, RAID=5, INSTANCE_CHAT=6}
function CsAlert.func.sortChatTypeId(a, b)
    return chatTypeIdOrder[a] < chatTypeIdOrder[b]
end

-- Copies tables, making sure to copy embedded tables too
-- Lifted from lua-users.org
function CsAlert.func.deepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[CsAlert.func.deepCopy(orig_key)] = CsAlert.func.deepCopy(orig_value)
        end
        setmetatable(copy, CsAlert.func.deepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- Copies values from t2 to t1, recursively
-- With an option to only overwrite nils
function CsAlert.func.updateTable(t1, t2, onlyNilValues)
    for k, v in pairs(t2) do
        if type(v) == "table" then
            if t1[k] == nil then t1[k] = {} end
            CsAlert.func.updateTable(t1[k], v)
        else
            if not onlyNilValues or t1[k] == nil then
                t1[k] = v
            end
        end
    end
end

-- Prints a table to default chat frame
function CsAlert.func.dumpTable(t, l)
    local indent = ""
    local initBrace = l == nil
    l = l or 1
    for _ = 1, l do
        indent = indent .. "  "
    end
    if initBrace then print(indent .. "{") end
    for k, v in CsAlert.func.sortedKeyIter(t) do
        if type(v) ~= "table" then
            print(indent .. "  ", k .. ":", v)
        else
            print(indent .. "  ", k .. ": {")
            CsAlert.func.dumpTable(v, l + 1)
        end
    end
    print(indent .. "}")
end

-- Updates options frame settings
function CsAlert.func.updateOptions(globalSet, charaSet)
    -- Global settings
    CsAlert.optionsFrame.checkTestMode:SetChecked(globalSet.testMode)
    CsAlert.optionsFrame.checkShowAllDebuff:SetChecked(globalSet.showAllDebuff)
    if not globalSet.testMode then
        CsAlert.optionsFrame.checkShowAllDebuff:Disable()
        CsAlert.optionsFrame.checkShowAllDebuff.text:SetFontObject(GameFontDisableSmall)
    end

    -- Per character settings, setting defaults if needed
    CsAlert.optionsFrame.editMinDebuffDuration:SetNumber(charaSet.minDebuffDuration)
    CsAlert.optionsFrame.editMinDebuffDuration:SetCursorPosition(0)
    charaSet.shownDebuffType = charaSet.shownDebuffType or CsAlert.charaSettings.shownDebuffType
    for k, v in pairs(charaSet.shownDebuffType) do
        CsAlert.optionsFrame.checkDebuffTypes[k]:SetChecked(v)
    end
    charaSet.broadcastSettings = charaSet.broadcastSettings or CsAlert.charaSettings.broadcastSettings
    for k, v in pairs(charaSet.broadcastSettings) do
        UIDropDownMenu_SetText(CsAlert.optionsFrame.dropDownBroadcast[k], CsAlert.strings.broadcastTargets[v])
    end
end