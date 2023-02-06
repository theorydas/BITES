function BitesCookBook:GetItem(id)
    ItemColor = "|r|cffffffff" -- Default color is white. |r is needed to reset the color and prevents leaks.
    ItemName = C_Item.GetItemNameByID(id)

    -- If the item is not in the localization, make it red.
    if ItemName == tostring(id) then
        ItemColor = "|cffff0000"
        ItemName = "???"
    end

    return ItemColor, ItemName
end

function BitesCookBook:BuildTooltipForRecipe(id)
    --- Shows all materials needed for a recipe.

    if BitesCookBook.Recipes[id] ~= nil then
        local text = "\n"
        
        -- Cycle through all materials in a recipe to create the tooltip.
        text = text .. "Recipe:"
        for itemID, count in pairs(BitesCookBook.Recipes[id].Materials) do
            ItemColor, ItemName = BitesCookBook:GetItem(itemID)
            
            text = text .."\n    ".. ItemColor.. count .. " x " .. ItemName
        end

        return text
    else
        return nil
    end
end

function BitesCookBook:BuildTooltipForIngredient(id)
    --- Shows all available recipes for that ingredient.
    if ingredients[id] ~= nil then
        local text = "\n"
        -- Cycle through all materials in a recipe to create the tooltip.
        text = text .. "Ingredient for:"

        for _, RecipeID in ipairs(ingredients[id]) do
            ItemColor, ItemName = GetItem(RecipeID)
            
            if CookingSkillRank >= BitesCookBook.Recipes[RecipeID]["Range"][1] - BitesCookBook.Options.max_level then
                if ItemColor ~= "|cffff0000" then -- We do not want to override errors by mistake.
                    if BitesCookBook.Options.gray_minimum_rank and BitesCookBook.Recipes[RecipeID]["Range"][1] > CookingSkillRank then
                        ItemColor = "|c007d7d7d" -- Gray color.
                    elseif BitesCookBook.Options.color_meal then
                        if CookingSkillRank <= BitesCookBook.Recipes[RecipeID]["Range"][1] then
                            ItemColor = "|c00FF0000" -- Red color.
                        elseif CookingSkillRank <= BitesCookBook.Recipes[RecipeID]["Range"][2]then
                            ItemColor = "|c00FF7F00" -- Orange color.
                        elseif CookingSkillRank <= BitesCookBook.Recipes[RecipeID]["Range"][3] then
                            ItemColor = "|c00FFFF00" -- Yellow color.
                        elseif CookingSkillRank <= BitesCookBook.Recipes[RecipeID]["Range"][4] then
                            ItemColor = "|cff1eff00" -- Green color.
                        else
                            ItemColor = "|c007d7d7d" -- Gray color.
                        end
                    end
                end
                -- Get the item's icon through the item's ID and add it to the tooltip.
                if BitesCookBook.Options.show_recipe_icon then
                    itemTexture = C_Item.GetItemIconByID(RecipeID)
                    if itemTexture ~= nil then
                        text = text .."\n   |T" .. itemTexture .. ":0|t ".. ItemColor.. ItemName
                    else
                        text = text .."\n    ".. ItemColor.. ItemName
                    end
                else
                    text = text .."\n    ".. ItemColor.. ItemName
                end

                if BitesCookBook.Options.show_recipe_level_start_on_ingredient then
                    range = BitesCookBook.Recipes[RecipeID]["Range"]
                    -- range[1] = recipes[RecipeID]["Range"][1]
                    if range[1] > 1 then -- If the first number is 1, it is a default recipe.
                        text = text .. string.format("|r-|c00FF7F00%s|r", range[1])
                    else
                        text = text .. string.format("|r-|c00FF7F00%s|r", "Starter")
                    end
                    if BitesCookBook.Options.show_recipe_level_range_on_ingredient then
                        text = text .. string.format("|r-|c00FFFF00%s|r-|cff1eff00%s|r-|c007d7d7d%s|r", range[2], range[3], range[4])
                    end               
                end
            end
        end

        return text
    else
        return nil
    end
end

function BitesCookBook.OnTooltipSetItem(tooltip)
    if not BitesCookBook.Options.show_ingredient_tooltip and not BitesCookBook.Options.show_recipe_tooltip then
        return
    end
    if BitesCookBook.Options.show_on_modifier ~= 0 then
        if modifier_key_functions[BitesCookBook.Options.modifier_key]() == not BitesCookBook.Options.show_on_modifier then
            return
        end
    end

    -- Get the name of the item.
	local itemName, itemLink = tooltip:GetItem()
	if not itemName then
        return
    end
    
    local itemID = Item:CreateFromItemLink(itemLink):GetItemID()


    if BitesCookBook.Options.show_recipe_tooltip then
        -- Find all the items used to make this.
        RecipeTooltip = BitesCookBook:BuildTooltipForRecipe(itemID)
        if RecipeTooltip ~= nil then
            tooltip:AddLine(RecipeTooltip)
        end
    end
    
    if BitesCookBook.Options.show_ingredient_tooltip then
        if BitesCookBook.Options.hide_meals_but_hint then
            tooltip:AddLine("Ingredient used in cooking:")
            return
        end

        IngredientTooltip = BitesCookBook:BuildTooltipForIngredient(itemID)
        if IngredientTooltip ~= nil then
            tooltip:AddLine(IngredientTooltip)
        end
    end
end

GameTooltip:HookScript("OnTooltipSetItem", BitesCookBook.OnTooltipSetItem)