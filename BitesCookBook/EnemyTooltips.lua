local Locale = BitesCookBook.Locales[GetLocale()] or BitesCookBook.Locales["enUS"] -- The default locale is English.

function BitesCookBook.OnEnemyTooltip(Tooltip)
    -- Does the player want to see the tooltip?
    if not BitesCookBook.Options.ShowEnemyTooltip then return end

    -- Do they want to see/hide the tooltip only when holding a modifier key?
    if BitesCookBook:CheckModifierKey() then return end

    local _, Unit = Tooltip:GetUnit()
    if Unit == nil then
        return
    end

    -- Hide friendly NPCs.
    local Reaction = UnitReaction(Unit, "player")
    if Reaction == nil or Reaction > 4 then -- 3, is hostile, 4 is neutral, 5 is friendly.
        return
    end

    local UnitID = tonumber(UnitGUID(Unit):match("-(%d+)-%x+$"), 10)

    -- Otherwise build the tooltip.
    local EnemyTooltip = BitesCookBook:BuildTooltipForEnemy(UnitID)
    if EnemyTooltip == nil then return end

    Tooltip:AddLine(EnemyTooltip)
end

GameTooltip:HookScript("OnTooltipSetUnit", BitesCookBook.OnEnemyTooltip)

--------------------------------------------------------------------------------
-- Enemy-specific tooltip functions
--------------------------------------------------------------------------------

function BitesCookBook:BuildTooltipForEnemy(EnemyID)
    -- Shows all materials needed for a recipe.
    local Enemy = BitesCookBook.MobsDroppingReagent[EnemyID]

    -- If the item doesn't correspond to a recipe, do nothing.
    if Enemy == nil then return end

    -- local text = "\n".. Locale["MightHavest:"]
    local text = ""
    
    -- Cycle through all materials in a recipe to create the tooltip.
    for i, ReagentID in ipairs(Enemy) do
        local ItemName = BitesCookBook:GetItemNameByID(ReagentID)
        local ItemColor = BitesCookBook:GetDropColor(ReagentID)

        -- Show the item's texture.
        if i > 1 then
            text = text.. "\n"
        end
        -- Decide which icon, if any, we want to show.
        -- text = text .."    ".. ItemColor.. "|T".. BitesCookBook:GetItemIcon(ReagentID).. ":0|t ".. ItemName
        text = text .."    ".. ItemColor.. "|TInterface\\Icons\\inv_misc_food_15.png:0|t ".. ItemName
    end

    return text
end

function BitesCookBook:GetDropColor(ReagentID)
    -- The player can choose to color the ingredients by rank.
    -- This is based on the highest ranking recipe that uses the ingredient.
    -- Since we have already sorted the recipes by rank, we can just take the first one.
    if BitesCookBook.Options.ColorDropsByRank then
        local HighestRecipeId = BitesCookBook.CraftablesForReagent[ReagentID][1] -- The first recipe is the highest ranked one.
        local HighestRanks = BitesCookBook.Recipes[HighestRecipeId]["Range"]

        ItemColor = BitesCookBook:GetColorInRange(HighestRanks, BitesCookBook.CookingSkillRank)
    else
        ItemColor = BitesCookBook.TextColors["White"]
    end

    return "|r".. ItemColor
end