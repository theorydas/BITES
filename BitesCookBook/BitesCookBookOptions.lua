BitesCookBook = CreateFrame("Frame")
BitesCookBook.Ingredients
BitesCookBook.Recipes
BitesCookBook.CookingSkillRank
BitesCookBook.Options = {
	show_ingredient_tooltip = true,
	show_recipe_level_range_on_ingredient = false,
	show_recipe_tooltip = true,
	hide_meals_but_hint = false,
    show_recipe_level_start_on_ingredient = false,
	show_on_modifier = 0,
    modifier_key = "SHIFT",
    gray_minimum_rank = false,
    color_meal = false,
    show_recipe_icon = false,
    max_level = 50
}

-- Keep track of the vertical position of option items.
local Position = -10
local DeltaP_Box = 29

BitesCookBook:RegisterEvent("CHAT_MSG_SKILL")
BitesCookBook:RegisterEvent("ADDON_LOADED")
BitesCookBook:SetScript("OnEvent", BitesCookBook.OnEvent)

function BitesCookBook:OnEvent(self, event, addonName)
	if event == "ADDON_LOADED" and addOnName ~= "BitesCookBook" then return end
        if BitesCookBook_SavedVariables == nil then
            BitesCookBook_SavedVariables = self.options
        else
            -- If new options were added since last file was saved, we must update it.
            for key, option_value in pairs(self.options) do
                if BitesCookBook_SavedVariables[key] == nil then
                    print("added ".. key .." to saved variables.")
                    BitesCookBook_SavedVariables[key] = option_value
                end
            end

            -- if an option was removed, we must also remove it from the saved variables.
            for key, option_value in pairs(BitesCookBook_SavedVariables) do
                if self.options[key] == nil then
                    print("removed ".. key .." from saved variables.")
                    BitesCookBook_SavedVariables[key] = nil
                end
            end

            -- Let options be the (updated) saved variables.
            self.options = BitesCookBook_SavedVariables
        end
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
	BitesCookBook_ConfigFrame = CreateFrame("Frame", "BitesCookBook_InterfaceOptionsPanel", UIParent)
    BitesCookBook_ConfigFrame.name = "Bites"
    InterfaceOptions_AddCategory(BitesCookBook_ConfigFrame)


    BitesCookBook_ConfigFrame.Ingredients = CreateTitle("Ingredients", "Ingredient Tooltips", "These are options that modify which recipe-information is shown on the tooltip of ingredients.")

    CreateCheckBox("show_ingredient_tooltip", "Show ingredient tooltips.")

    CreateCheckBox("hide_meals_but_hint", "Only show if an item is used for cooking.")

    CreateCheckBox("show_recipe_level_start_on_ingredient", "Show at what skill level a meal becomes available.")
    AllLevelRangesBox = CreateCheckBox("show_recipe_level_range_on_ingredient", "Also show at what subsequent sill-levels the meal's efficiency changes.")
    AllLevelRangesBox:SetPoint("TOPLEFT", 20 + 20, -Position + DeltaP_Box)

    CreateCheckBox("gray_minimum_rank", "Gray out recipes that are not yet available to your rank.")
    CreateCheckBox("color_meal", "Color a meal according to your rank.")
    CreateCheckBox("show_recipe_icon", "Show a picture of the meal.")
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

function BitesCookBook:CreateTitle(Name, ShortDescription, LongDescription)
    Position = Position +25
    BitesCookBook_ConfigFrame[Name] = CreateFrame("Frame", "BitesCookbook".. Name, BitesCookBook_ConfigFrame)
    BitesCookBook_ConfigFrame[Name]:SetPoint("TOPLEFT", BitesCookBook_ConfigFrame, "TOPLEFT", 10, -Position)

    BitesCookBook_ConfigFrame[Name.. "_Title"] = BitesCookBook_ConfigFrame[Name]:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    BitesCookBook_ConfigFrame[Name.. "_Title"]:SetPoint("TOPLEFT", BitesCookBook_ConfigFrame, "TOPLEFT", 10, -Position)
    BitesCookBook_ConfigFrame[Name.. "_Title"]:SetText("|r".. ShortDescription .." |r")
    BitesCookBook_ConfigFrame[Name.. "_Title"]:SetFont("Fonts\\FRIZQT__.TTF", 13)

    BitesCookBook_ConfigFrame[Name.. "_Desc"] = BitesCookBook_ConfigFrame[Name]:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    BitesCookBook_ConfigFrame[Name.. "_Desc"]:SetPoint("TOPLEFT", BitesCookBook_ConfigFrame, "TOPLEFT", 10, -Position -20)
    BitesCookBook_ConfigFrame[Name.. "_Desc"]:SetText("|cffffffff".. LongDescription .." |r")
    BitesCookBook_ConfigFrame[Name.. "_Desc"]:SetFont("Fonts\\FRIZQT__.TTF", 10)

    if LongDescription == "" then
        Position = Position +20
    else
        Position = Position +35
    end

    return BitesCookBook_ConfigFrame[Name]
end

function BitesCookBook:CreateCheckBox(Name, Description, ExtraFunction) -- Warning, name of checkbox is same as the variable it changes!
    BitesCookBook_ConfigFrame[Name] = CreateFrame("CheckButton", "default", BitesCookBook_ConfigFrame, "UICheckButtonTemplate")
    BitesCookBook_ConfigFrame[Name]:SetPoint("TOPLEFT", 20, -Position)
    -- BitesCookBook_ConfigFrame[Name].text:SetText("|cffffffff".. Description.. "|r")
    BitesCookBook_ConfigFrame[Name].text:SetText(Description)
    BitesCookBook_ConfigFrame[Name].text:SetTextColor(1, 1, 1, 1)
    BitesCookBook_ConfigFrame[Name]:SetChecked(BitesCookBook.options[Name])
    BitesCookBook_ConfigFrame[Name]:SetScript("OnClick",
        function()
            BitesCookBook.options[Name] = not BitesCookBook.options[Name]

            -- Sometimes we want to do something extra after the checkbox is clicked.
            if ExtraFunction ~= nil then
                ExtraFunction()
            end
        end
    )

    Position = Position +DeltaP_Box

    return BitesCookBook_ConfigFrame[Name]
end