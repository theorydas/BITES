function BitesCookBook.OnEnemyTooltip(Tooltip)
    -- Does the player want to see the tooltip?
    if not BitesCookBook.Options.show_enemy_tooltip then return end

    -- Do they want to see/hide the tooltip only when holding a modifier key?
    if BitesCookBook:CheckModifierKey() then return end

    local _, Unit = Tooltip:GetUnit()
    if Unit == nil or Unit == "player" then
        print("Invalid unit")
        return
    end

    local UnitID = tonumber(UnitGUID(Unit):match("-(%d+)-%x+$"), 10)

    -- Otherwise build the tooltip.
    EnemyTooltip = BitesCookBook:BuildTooltipForEnemy(UnitID)
    if EnemyTooltip == nil then return end

    Tooltip:AddLine(EnemyTooltip)

end

-- Shows all materials needed for a recipe.
function BitesCookBook:BuildTooltipForEnemy(EnemyID)
    local Enemy = BitesCookBook.DroopedBy[EnemyID]

    -- If the item doesn't correspond to a recipe, do nothing.
    if Enemy == nil then return end

    local text = "\nMight harvest:"
    
    -- Cycle through all materials in a recipe to create the tooltip.
    for _, ReagentID in ipairs(Enemy) do
        ItemName = BitesCookBook:GetItemNameByID(ReagentID)
        ItemColor = BitesCookBook:GetReagentColor(ReagentID)

        text = text .."\n    ".. ItemColor.. ItemName
    end

    return text
end