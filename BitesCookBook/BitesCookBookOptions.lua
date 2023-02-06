BitesCookBook = CreateFrame("Frame")
BitesCookBook.Ingredients
BitesCookBook.Recipes
BitesCookBook.CookingSkillRank

BitesCookBook:RegisterEvent("CHAT_MSG_SKILL")
BitesCookBook:RegisterEvent("ADDON_LOADED")
BitesCookBook:SetScript("OnEvent", BitesCookBook.OnEvent)

function BitesCookBook:OnEvent(self, event, addonName)
	if event == "ADDON_LOADED" and addOnName ~= "BitesCookBook" then return end

        self:InitializeOptionsMenu()

        -- Get the player's cooking skill, and create a list for all ingredients.
        BitesCookBook.CookingSkillRank = BitesCookBook:GetSkillLevel("Cooking")
        BitesCookBook.Ingredients = BitesCookBook:GetAllIngredients(recipes)

        self:UnregisterEvent(event)
    -- Additionally, we want to update the player's cooking skill when they level up.
    else event == "CHAT_MSG_SKILL" then
        BitesCookBook.CookingSkillRank = BitesCookBook:GetSkillLevel("Cooking")
    end
end

function BitesCookBook:InitializeOptionsMenu()
	BitesCookBook_ConfigFrame = CreateFrame("Frame", "BitesCookBook_InterfaceOptionsPanel", UIParent);
    BitesCookBook_ConfigFrame.name = "Bites";
    InterfaceOptions_AddCategory(BitesCookBook_ConfigFrame);
end

function BitesCookBook:GetSkillLevel(SkillName)
    for skillIndex = 1, GetNumSkillLines() do
        SkillInfo = {GetSkillLineInfo(skillIndex)}

        if SkillInfo[1] == SkillName then
            return SkillInfo[4]
        end
    end
    
    -- If we cannot not find the skill, the rank is 0.
    return 0
end

function BitesCookBook:GetAllIngredients(RecipeList)
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