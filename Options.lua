local _, CsAlert = ...

-- Create options frame
local optionsFrame = CreateFrame("Frame", nil, UIParent)
optionsFrame.name = "CounterspellAlert"
optionsFrame.settingChanges = {globalSettings={}, charaSettings={}}
function optionsFrame.okay()
    CsAlert.func.updateTable(CsAlert_GlobalSettings, optionsFrame.settingChanges.globalSettings)
    CsAlert.func.updateTable(CsAlert_CharaSettings, optionsFrame.settingChanges.charaSettings)
    for _, t in pairs(optionsFrame.settingChanges) do
        wipe(t)
    end
end
function optionsFrame.cancel()
    for _, t in pairs(optionsFrame.settingChanges) do
        wipe(t)
    end
    CsAlert.func.updateOptions(CsAlert_GlobalSettings, CsAlert_CharaSettings)
end
function optionsFrame.default()
    optionsFrame.settingChanges = {
        globalSettings = CsAlert.func.deepCopy(CsAlert.globalSettings),
        charaSettings = CsAlert.func.deepCopy(CsAlert.charaSettings)
    }
    CsAlert.func.updateOptions(unpack(optionsFrame.settingChanges))
end
CsAlert.optionsFrame = optionsFrame
InterfaceOptions_AddCategory(optionsFrame)

-- Global settings header
local text = CsAlert.func.createHeader(CsAlert.strings.globalSettings, optionsFrame, 20, -20)

-- Test mode check button
local checkButton = CreateFrame("CheckButton", nil, optionsFrame, "UICheckButtonTemplate")
checkButton.text:SetText(CsAlert.strings.testMode)
checkButton:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -20)
checkButton:SetScript("OnClick", function(self)
    local changes = optionsFrame.settingChanges.globalSettings
    changes.testMode = self:GetChecked()
    if changes.testMode then
        optionsFrame.checkShowAllDebuff:Enable()
        optionsFrame.checkShowAllDebuff.text:SetFontObject(GameFontNormalSmall)
    else
        changes.showAllDebuff = false
        optionsFrame.checkShowAllDebuff:SetChecked(false)
        optionsFrame.checkShowAllDebuff:Disable()
        optionsFrame.checkShowAllDebuff.text:SetFontObject(GameFontDisableSmall)
    end
end)
checkButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:AddLine(CsAlert.strings.testMode)
    GameTooltip:AddLine(CsAlert.strings.testModeDesc, 1, 1, 1, true)
    GameTooltip:Show()
end)
checkButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
optionsFrame.checkTestMode = checkButton
local checkTestModeLength = optionsFrame.checkTestMode.text:GetStringWidth()

-- Show all debuffs check button
checkButton = CreateFrame("CheckButton", nil, optionsFrame, "UICheckButtonTemplate")
checkButton.text:SetText(CsAlert.strings.showAllDebuff)
checkButton:SetPoint("TOPLEFT", optionsFrame.checkTestMode, "TOPRIGHT", 10 + checkTestModeLength, 0)
checkButton:SetScript("OnClick", function(self)
    local changes = optionsFrame.settingChanges.globalSettings
    changes.showAllDebuff = self:GetChecked()
end)
checkButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:AddLine(CsAlert.strings.showAllDebuff)
    GameTooltip:AddLine(CsAlert.strings.showAllDebuffDesc, 1, 1, 1, true)
    GameTooltip:Show()
end)
checkButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
optionsFrame.checkShowAllDebuff = checkButton

-- Character-specific settings header
local prevText = CsAlert.func.createHeader(CsAlert.strings.charaSettings, optionsFrame.checkTestMode, 0, -60)

-- Min debuff duration text
text = optionsFrame:CreateFontString(nil, "ARTWORK")
text:SetFontObject(GameFontNormalSmall)
text:SetText(CsAlert.strings.minDebuffDuration)
text:SetPoint("TOPLEFT", prevText, "BOTTOMLEFT", 0, -32)
local textMinDebuffDurationLength = text:GetStringWidth()

-- Min debuff duration edit box
local editBox = CreateFrame("EditBox", nil, optionsFrame)
editBox:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    tileSize = 26,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4}
})
editBox:SetBackdropColor(0,0,0,1)
editBox:SetPoint("TOPLEFT", prevText, "BOTTOMLEFT", 10 + textMinDebuffDurationLength, -25)
editBox:SetSize(40, 25)
editBox:SetMultiLine(false)
editBox:SetAutoFocus(false)
editBox:SetJustifyH("CENTER")
editBox:SetJustifyV("CENTER")
editBox:SetFontObject(GameFontWhiteSmall)
editBox:SetNumeric(true)
editBox:SetScript("OnTextChanged", function(self)
    local changes = optionsFrame.settingChanges.charaSettings
    changes.minDebuffDuration = self:GetNumber()
end)
editBox:SetScript("OnEnterPressed", function(self)
    self:ClearFocus()
end)
editBox:SetScript("OnEscapePressed", function(self)
    self:ClearFocus()
end)

-- Min debuff duration edit box's extra text
editBox.title_text = editBox:CreateFontString(nil, "ARTWORK")
editBox.title_text:SetFontObject(GameFontNormalSmall)
editBox.title_text:SetText(CsAlert.strings.seconds)
editBox.title_text:SetPoint("TOPLEFT", editBox, "TOPRIGHT", 5, -7)
optionsFrame.editMinDebuffDuration = editBox

-- Types of debuff to announce
text = optionsFrame:CreateFontString(nil, "ARTWORK")
text:SetFontObject(GameFontNormalSmall)
text:SetText(CsAlert.strings.debuffTypeText)
text:SetPoint("TOPLEFT", editBox, "BOTTOMLEFT", -(10 + textMinDebuffDurationLength), -20)

optionsFrame.checkDebuffTypes = {}
local counter, firstKey = 0, nil
for k, s in CsAlert.func.sortedKeyIter(CsAlert.strings.statuses) do
    if firstKey == nil then firstKey = k end
    local checkBox = CreateFrame("CheckButton", nil, optionsFrame, "UICheckButtonTemplate")
    local x, y = counter % 3, floor(counter / 3)
    checkBox:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 200*x, -10 - 30*y)
    checkBox.text:SetText(s)
    checkBox.key = k
    checkBox:SetScript("OnClick", function(self)
        local changes = optionsFrame.settingChanges.charaSettings
        changes.shownDebuffType = changes.shownDebuffType or {}
        changes.shownDebuffType[self.key] = self:GetChecked()
    end)

    optionsFrame.checkDebuffTypes[k] = checkBox
    counter = counter + 1
end

-- Broadcast settings
local prevText = CsAlert.func.createHeader(
    CsAlert.strings.broadcastSettings,
    optionsFrame.checkDebuffTypes[firstKey],
    0,
    -20 - 30*ceil(counter / 3),
    GameFontNormal
)

-- Available options for broadcast dropdowns
optionsFrame.instanceBroadcastTargets = {
    party = {
        "NONE",
        "SAY",
        "YELL",
        "PARTY"
    },
    raid = {
        "NONE",
        "SAY",
        "YELL",
        "PARTY",
        "RAID"
    },
    pvp = {
        "NONE",
        "SAY",
        "YELL",
        "PARTY",
        "INSTANCE_CHAT"
    }
}

-- Broadcast dropdowns
CsAlert.optionsFrame.dropDownBroadcast = {}
counter = 0
for instanceType, instanceString in pairs(CsAlert.strings.instanceTypes) do
    text = optionsFrame:CreateFontString(nil, "ARTWORK")
    text:SetFontObject(GameFontWhiteSmall)
    text:SetText(instanceString .. ":")
    text:SetPoint("TOPLEFT", prevText, "BOTTOMLEFT", 200*counter, -20)

    local dropDown = CreateFrame("Frame", "CsAlertDropDown"..instanceType, optionsFrame, "UIDropDownMenuTemplate")
    dropDown:SetPoint("TOPLEFT", text, "BOTTOMLEFT", -20, -5)
    dropDown.settingName = instanceType
    UIDropDownMenu_SetText(dropDown, "Disabled")
    UIDropDownMenu_SetWidth(dropDown, 120)
    UIDropDownMenu_Initialize(dropDown, function(frame, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        info.func = function(self, arg1)
            UIDropDownMenu_SetText(frame, self.value)
            local changes = optionsFrame.settingChanges.charaSettings
            changes.broadcastSettings = changes.broadcastSettings or {}
            changes.broadcastSettings[frame.settingName] = arg1
        end
        info.minWidth = 120
        info.notCheckable = true
        info.checked = function(self)
            if optionsFrame.settingChanges.broadcastSettings == nil then
                return self.arg1 == CsAlert.charaSettings.broadcastSettings[frame.settingName]
            else
                return self.arg1 == optionsFrame.settingChanges.charaSettings.broadcastSettings[frame.settingName]
            end
        end
        for _, val in ipairs(optionsFrame.instanceBroadcastTargets[instanceType]) do
            info.text, info.arg1 = CsAlert.strings.broadcastTargets[val], val
            UIDropDownMenu_AddButton(info)
        end
    end)
    optionsFrame.dropDownBroadcast[instanceType] = dropDown
    counter = counter + 1
end

-- Author info
text = optionsFrame:CreateFontString(nil, "ARTWORK")
text:SetFontObject(GameFontDisableSmall)
text:SetText(CsAlert.strings.authorInfo)
text:SetPoint("BOTTOMRIGHT", optionsFrame, "BOTTOMRIGHT", -10, 10)
