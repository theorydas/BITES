--------------------------------------------------------------------------------
-- General Tooltip functions and Definitions
--------------------------------------------------------------------------------

BitesCookBook.TextColors = {
    ["Red"] = "|c00FF0000",
    ["Orange"] = "|c00FF7F00",
    ["Yellow"] = "|c00FFFF00",
    ["Green"] = "|cff1eff00",
    ["Gray"] = "|c007d7d7d",
    ["White"] = "|cffffffff",
}

BitesCookBook.ModifierKeys = {
    ["SHIFT"] = IsShiftKeyDown,
    ["ALT"] = IsAltKeyDown,
    ["CTRL"] = IsControlKeyDown,
}

-- Returns the name of an item using its WoW ID.
function BitesCookBook:GetItemNameByID(ItemId)
    local ItemName = C_Item.GetItemNameByID(ItemId)

    -- Sometimes WoW won't find the name immediately.
    return ItemName ~= nil and ItemName or ""
end

function BitesCookBook:GetItemIcon(ItemId)
    local ItemIcon = C_Item.GetItemIconByID(ItemId)

    -- Sometimes WoW won't find the icon immediately, so use the default question mark icon.
    return ItemIcon ~= nil and ItemIcon or "Interface\\Icons\\INV_Misc_QuestionMark"
end

function BitesCookBook:CheckModifierKey()
    if BitesCookBook.Options.HasModifier ~= 0 then
        if BitesCookBook.ModifierKeys[BitesCookBook.Options.ModifierKey]() == not BitesCookBook.Options.HasModifier then
            return true
        end
    end
    
    -- Passes the check.
    return false
end