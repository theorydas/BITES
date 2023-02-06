-- =================================================================================================
-- Handle tooltips
-- =================================================================================================

function BitesCookBook:GetItem(id)
    if id == nil then
        return -- No id, no color.
    end

    ItemColor = "|r|cffffffff" -- Default color is white. |r is needed to reset the color and prevents leaks.
    ItemName = C_Item.GetItemNameByID(id)

    -- If the item is not in the localization, make it red.
    if ItemName == tostring(id) then
        ItemColor = "|cffff0000"
        ItemName = "???"
    end

    return ItemColor, ItemName
end

function BitesCookBook:GetRecipeTooltip(id)
    --- Shows all materials needed for a recipe.

    if recipes[id] ~= nil then
        local text = "\n"
        
        -- Cycle through all materials in a recipe to create the tooltip.
        text = text .. "Recipe:"
        for itemID, count in pairs(recipes[id].Materials) do
            ItemColor, ItemName = BitesCookBook:GetItem(itemID)
            
            text = text .."\n    ".. ItemColor.. count .. " x " .. ItemName
        end

        return text
    else
        return nil
    end
end

function BitesCookBook:GetIngredientTooltip(id)
    --- Shows all available recipes for that ingredient.
    if ingredients[id] ~= nil then
        local text = "\n"
        -- Cycle through all materials in a recipe to create the tooltip.
        text = text .. "Ingredient for:"

        for _, RecipeID in ipairs(ingredients[id]) do
            ItemColor, ItemName = BitesCookBook:GetItem(RecipeID)
            
            text = text .."\n    ".. ItemColor.. ItemName
        end

        return text
    else
        return nil
    end
end

function BitesCookBook:OnTooltipSetItem(tooltip)
	local itemName, itemLink = tooltip:BitesCookBook:GetItem()
	if not itemName then
        return
    end
    
    local itemID = Item:CreateFromItemLink(itemLink):GetItemID()


    RecipeTooltip = BitesCookBook:GetRecipeTooltip(itemID)
    if RecipeTooltip ~= nil then
        tooltip:AddLine(RecipeTooltip)
    end

    IngredientTooltip = BitesCookBook:GetIngredientTooltip(itemID)
    if IngredientTooltip ~= nil then
        tooltip:AddLine(IngredientTooltip)
    end
end

GameTooltip:HookScript("OnTooltipSetItem", BitesCookBook:OnTooltipSetItem)