function BitesCookBook.OnReagentTooltip(Tooltip)
    -- Does the player want to see the tooltip?
    if not BitesCookBook.Options.show_ingredient_tooltip then
        return
    end

    -- Do they want to see/hide the tooltip only when holding a modifier key?
    if BitesCookBook:CheckModifierKey() then return end

    -- Find the item link of the item being hovered over.
	local _, ItemLink = Tooltip:GetItem()
	if ItemLink == nil then return end
    local ItemID = Item:CreateFromItemLink(ItemLink):GetItemID()
    
    -- If the item doesn't correspond to a reagent, do nothing.
    if BitesCookBook.Ingredients[ItemID] == nil then return end

    -- Do we want to hide the information?
    if BitesCookBook.Options.hide_meals_but_hint then
        Tooltip:AddLine("Used in cooking.")
        return
    end

    local IngredientTooltip = BitesCookBook:BuildTooltipForReagent(ItemID)
    if IngredientTooltip == nil then return end
    Tooltip:AddLine(IngredientTooltip)
end

function BitesCookBook:BuildTooltipForReagent(ReagentID)
    --- Shows all available recipes for that ingredient.
    local CraftablesMadeWithIngredient = BitesCookBook.Ingredients[ReagentID] -- A list of recipes that use the ingredient.
    if CraftablesMadeWithIngredient == nil then return end
    
    local text = "\nIngredient for:"
    
    -- Cycle through all recipes that use the ingredient to create the tooltip.
    for _, RecipeID in ipairs(CraftablesMadeWithIngredient) do
        local RankingRange = BitesCookBook.Recipes[RecipeID]["Range"]
        local DeltaRank = BitesCookBook.Options.max_level

        if BitesCookBook.CookingSkillRank + DeltaRank >= RankingRange[1] then
            CraftableName = BitesCookBook:GetItemNameByID(RecipeID)
            CraftableColor = BitesCookBook:GetCraftableColor(RecipeID)

            -- Show the recipe icon if the option is enabled.
            local ShowRecipeIcon = BitesCookBook.Options.show_recipe_icon
            local CraftableIcon = BitesCookBook:GetItemIcon(RecipeID)
            CraftableIcon = ShowRecipeIcon and "|T".. CraftableIcon.. ":0|t " or ""

            text = text .."\n    ".. CraftableIcon .. CraftableColor.. CraftableName.. "|r"

            local ShowFirstLevel = BitesCookBook.Options.show_recipe_level_start_on_ingredient
            local ShowLevelRange = BitesCookBook.Options.show_recipe_level_range_on_ingredient
            
            if ShowFirstLevel then
                local FirstRangeText = RankingRange[1] > 1 and RankingRange[1] or "Starter"

                -- When the first rank is 1, it's a starter recipe.
                text = text .. "-".. BitesCookBook.TextColors["Orange"].. FirstRangeText.. "|r"

                if ShowLevelRange then
                    text = text.. "|r-".. BitesCookBook.TextColors["Yellow"].. RankingRange[2].. "|r-".. BitesCookBook.TextColors["Green"].. RankingRange[3].. "|r-".. BitesCookBook.TextColors["Gray"].. RankingRange[4].. "|r-"
                end
            end
            
        end
    end

    return text
end

function BitesCookBook:GetCraftableColor(CraftableID)
    local RankingRange = BitesCookBook.Recipes[CraftableID]["Range"] -- Range of ranks when recipe level-up changes.
    local MyRank = BitesCookBook.CookingSkillRank
    
    local ShouldGrayTheUnavailable = BitesCookBook.Options.gray_minimum_rank
    if ShouldGrayTheUnavailable and MyRank < RankingRange[1] then
        return BitesCookBook.TextColors["Gray"] -- Gray color.
    end
    
    local ShouldColorByRank = BitesCookBook.Options.color_meal
    if ShouldColorByRank then
        if MyRank < RankingRange[1] then
            return BitesCookBook.TextColors["Red"] -- Red color.
        elseif MyRank < RankingRange[2] then
            return BitesCookBook.TextColors["Orange"] -- Orange color.
        elseif MyRank < RankingRange[3] then
            return BitesCookBook.TextColors["Yellow"] -- Yellow color.
        elseif MyRank < RankingRange[4] then
            return BitesCookBook.TextColors["Green"] -- Green color.
        else
            return BitesCookBook.TextColors["Gray"] -- Gray color.
        end
    end

    -- Default color is white. |r is needed to reset the color and prevents leaks.
    return "|r".. BitesCookBook.TextColors["White"]
end