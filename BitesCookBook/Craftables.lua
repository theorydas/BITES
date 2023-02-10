function BitesCookBook.OnCraftableTooltip(Tooltip)
    -- Does the player want to see the tooltip?
    if not BitesCookBook.Options.show_recipe_tooltip then return end

    -- Do they want to see/hide the tooltip only when holding a modifier key?
    if BitesCookBook:CheckModifierKey() then return end

    -- Find the item link of the item being hovered over.
	local _, ItemLink = Tooltip:GetItem()
	if ItemLink == nil then return end
    local ItemID = Item:CreateFromItemLink(ItemLink):GetItemID()
    
    -- If the item doesn't correspond to a craftable, do nothing.
    if BitesCookBook.Recipes[ItemID] == nil then return end

    -- Otherwise build the tooltip.
    RecipeTooltip = BitesCookBook:BuildTooltipForCraftable(ItemID)
    if RecipeTooltip == nil then return end

    Tooltip:AddLine(RecipeTooltip)
end

-- Shows all materials needed for a recipe.
function BitesCookBook:BuildTooltipForCraftable(CraftableId)
    local Craftable = BitesCookBook.Recipes[CraftableId]

    -- If the item doesn't correspond to a recipe, do nothing.
    if Craftable == nil then return end

    local text = "\nRecipe:"
    
    -- Cycle through all materials in a recipe to create the tooltip.
    for ReagentID, count in pairs(Craftable.Materials) do
        ItemName = BitesCookBook:GetItemNameByID(ReagentID)
        ItemColor = BitesCookBook:GetReagentColor(ReagentID)

        text = text .."\n    ".. ItemColor.. count .. " x " .. ItemName
    end

    return text
end

-- Ingredients in a recipe are always white.
function BitesCookBook:GetReagentColor(ReagentID)
    return "|r".. BitesCookBook.TextColors["White"]
end