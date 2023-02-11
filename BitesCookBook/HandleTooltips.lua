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
    return ItemName ~= nil and ItemName or "???"
end

function BitesCookBook:GetItemIcon(ItemId)
    local ItemIcon = C_Item.GetItemIconByID(ItemId)

    -- Sometimes WoW won't find the icon immediately, so use the default question mark icon.
    return ItemIcon ~= nil and ItemIcon or "Interface\\Icons\\INV_Misc_QuestionMark"
end

function BitesCookBook:CheckModifierKey()
    if BitesCookBook.Options.show_on_modifier ~= 0 then
        if BitesCookBook.ModifierKeys[BitesCookBook.Options.modifier_key]() == not BitesCookBook.Options.show_on_modifier then
            return true
        end
    end

    return false
end

GameTooltip:HookScript("OnTooltipSetItem", BitesCookBook.OnReagentTooltip)
GameTooltip:HookScript("OnTooltipSetItem", BitesCookBook.OnCraftableTooltip)
GameTooltip:HookScript("OnTooltipSetUnit", BitesCookBook.OnEnemyTooltip)

-- Fixed that  when 'hint' is enabled also shows on recipes.