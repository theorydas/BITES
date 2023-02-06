local recipes = BitesCookBook_Recipes
local CookingSkillRank
local ingredients

-- When the addon is loaded, we want to get the player's cooking skill, and create a list of all ingredients.
function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" and ... == "BitesCookBook" then
        -- Get the player's cooking skill.
        print("Addon has loaded")
        CookingSkillRank = GetSkillLevel("Cooking")
        -- Create a list of all ingredients.
        ingredients = GetAllIngredients(recipes)

        -- Unregister the event, we do not need it anymore.
        self:UnregisterEvent("ADDON_LOADED")
    
    -- Additionally, we want to update the player's cooking skill when they level up.
    elseif event == "CHAT_MSG_SKILL" then
        CookingSkillRank = GetSkillLevel("Cooking")
    end
end

-- Create a frame to listen to events.
local TemporaryFrame = CreateFrame("Frame")
TemporaryFrame:RegisterEvent("ADDON_LOADED")
TemporaryFrame:RegisterEvent("CHAT_MSG_SKILL")
TemporaryFrame:SetScript("OnEvent", OnEvent)

function GetSkillLevel(SkillName)
    for skillIndex = 1, GetNumSkillLines() do
        SkillInfo = {GetSkillLineInfo(skillIndex)}

        if SkillInfo[1] == SkillName then
            return SkillInfo[4]
        end
    end
    
    -- If we cannot not find the skill, the rank is 0.
    return 0
end

function GetAllIngredients(RecipeList)
    local ingredients = {}
    
    for recipe_key, recipe in pairs(RecipeList) do
        for ingredient, _ in pairs(recipe["Materials"]) do
            if ingredients[ingredient] == nil then
                ingredients[ingredient] = {recipe_key}
            else
                table.insert(ingredients[ingredient], recipe_key)
            end
        end
    end

    -- sort each ingredient list based on the recipe range[1]
    for ingredient, recipe_list in pairs(ingredients) do
        table.sort(recipe_list, function(a, b)
            return RecipeList[a]["Range"][1] > RecipeList[b]["Range"][1]
        end)
    end

    return ingredients
end


-- =================================================================================================
-- Handle tooltips
-- =================================================================================================


function GetItem(id)
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

function GetRecipeTooltip(id)
    --- Shows all materials needed for a recipe.

    if recipes[id] ~= nil then
        local text = "\n"
        
        -- Cycle through all materials in a recipe to create the tooltip.
        text = text .. "Recipe:"
        for itemID, count in pairs(recipes[id].Materials) do
            ItemColor, ItemName = GetItem(itemID)
            
            text = text .."\n    ".. ItemColor.. count .. " x " .. ItemName
        end

        return text
    else
        return nil
    end
end

function GetIngredientTooltip(id)
    --- Shows all available recipes for that ingredient.
    if ingredients[id] ~= nil then
        local text = "\n"
        -- Cycle through all materials in a recipe to create the tooltip.
        text = text .. "Ingredient for:"

        for _, RecipeID in ipairs(ingredients[id]) do
            ItemColor, ItemName = GetItem(RecipeID)
            
            text = text .."\n    ".. ItemColor.. ItemName
        end

        return text
    else
        return nil
    end
end

function OnTooltipSetItem(tooltip)
	local itemName, itemLink = tooltip:GetItem()
	if not itemName then
        return
    end
    
    local itemID = Item:CreateFromItemLink(itemLink):GetItemID()


    RecipeTooltip = GetRecipeTooltip(itemID)
    if RecipeTooltip ~= nil then
        tooltip:AddLine(RecipeTooltip)
    end

    IngredientTooltip = GetIngredientTooltip(itemID)
    if IngredientTooltip ~= nil then
        tooltip:AddLine(IngredientTooltip)
    end
end

GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)