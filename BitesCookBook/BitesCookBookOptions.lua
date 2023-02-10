BitesCookBook = CreateFrame("Frame")
BitesCookBook.Options = {
	show_ingredient_tooltip = true,
	show_recipe_level_range_on_ingredient = false,
	show_recipe_tooltip = false,
	hide_meals_but_hint = false,
    show_recipe_level_start_on_ingredient = false,
	show_on_modifier = 0,
    modifier_key = "SHIFT",
    gray_minimum_rank = false,
    color_meal = true,
    show_recipe_icon = true,
    max_level = 100
}

-- Keep track of the vertical position of option items.
local Position = -10
local DeltaP_Box = 29

function OnEvent(self, event, addonName)
    -- We want to update the player's cooking skill when they level up.
    if event == "CHAT_MSG_SKILL" or event == "PLAYER_ENTERING_WORLD" then
        BitesCookBook.CookingSkillRank = BitesCookBook:GetSkillLevel("Cooking")
        return -- We don't want to do anything else.
    elseif event == "ADDON_LOADED" and addonName ~= "BitesCookBook" then
        return
    end

    -- Set the saved variables to the default values if they are not set.
    if BitesCookBook_SavedVariables == nil then
        BitesCookBook_SavedVariables = self.Options
    else
        -- If new Options were added since last file was saved, we must update it.
        for key, option_value in pairs(self.Options) do
            if BitesCookBook_SavedVariables[key] == nil then
                print("added ".. key .." to saved variables.")
                BitesCookBook_SavedVariables[key] = option_value
            end
        end

        -- if an option was removed, we must also remove it from the saved variables.
        for key, option_value in pairs(BitesCookBook_SavedVariables) do
            if self.Options[key] == nil then
                print("removed ".. key .." from saved variables.")
                BitesCookBook_SavedVariables[key] = nil
            end
        end

        -- Let Options be the (updated) saved variables.
        self.Options = BitesCookBook_SavedVariables
    end

    self:InitializeOptionsMenu()

    -- Detect if we are in classic.
    local isClassic = select(4, GetBuildInfo()) < 30000
    if isClassic then
        print("BitesCookBook: Classic.")
        BitesCookBook.Recipes = BitesCookBook_RecipesClassic
    else
        print("BitesCookBook: Wrath of the Lich King.")
        BitesCookBook.Recipes = BitesCookBook_RecipesWotLK
    end
    
    -- Create a list for all ingredients.
    BitesCookBook.Ingredients = BitesCookBook:GetAllIngredients(BitesCookBook.Recipes)

    self:UnregisterEvent(event)
end

BitesCookBook:RegisterEvent("CHAT_MSG_SKILL")
BitesCookBook:RegisterEvent("ADDON_LOADED")
BitesCookBook:RegisterEvent("PLAYER_ENTERING_WORLD")
BitesCookBook:SetScript("OnEvent", OnEvent)

PreventAllIngredients = function()
    AffectedFrames = {"show_recipe_level_start_on_ingredient", "show_recipe_level_range_on_ingredient", "hide_meals_but_hint", "gray_minimum_rank", "color_meal", "show_recipe_icon"}
    
    -- Iterate over the frames and disable them if the option is checked.
    for i, frame_name in ipairs(AffectedFrames) do
        AffectedFrame = BitesCookBook_ConfigFrame[frame_name]
        if not BitesCookBook.Options["show_ingredient_tooltip"] then
            BitesCookBook.Options[frame_name] = false
            AffectedFrame:Disable()
            -- AffectedFrame.text:SetTextColor(0.5, 0.5, 0.5)
            getglobal(AffectedFrame:GetName() .. 'Text'):SetTextColor(0.5, 0.5, 0.5)

            AffectedFrame:SetChecked(false)
        else
            AffectedFrame:Enable()
            -- AffectedFrame.text:SetTextColor(1, 1, 1)
            getglobal(AffectedFrame:GetName() .. 'Text'):SetTextColor(1, 1, 1)
        end
        -- Update other functions as well. What is the best way to do this?
        PreventLevelRange()
    end
end

PreventAllIngredientsFromHint = function()
    AffectedFrames = {"show_recipe_level_start_on_ingredient", "show_recipe_level_range_on_ingredient", "gray_minimum_rank", "color_meal", "show_recipe_icon"}
    
    -- Iterate over the frames and disable them if the option is checked.
    for i, frame_name in ipairs(AffectedFrames) do
        AffectedFrame = BitesCookBook_ConfigFrame[frame_name]
        if BitesCookBook.Options["hide_meals_but_hint"] then
            BitesCookBook.Options[frame_name] = false
            AffectedFrame:Disable()
            -- AffectedFrame.text:SetTextColor(0.5, 0.5, 0.5)
            getglobal(AffectedFrame:GetName() .. 'Text'):SetTextColor(0.5, 0.5, 0.5)

            AffectedFrame:SetChecked(false)
        else
            AffectedFrame:Enable()
            -- AffectedFrame.text:SetTextColor(1, 1, 1)
            getglobal(AffectedFrame:GetName() .. 'Text'):SetTextColor(1, 1, 1)
        end
        -- Update other functions as well. What is the best way to do this?
        PreventLevelRange()
    end
end

PreventLevelRange = function()
    AffectedFrame = BitesCookBook_ConfigFrame["show_recipe_level_range_on_ingredient"]
    if not BitesCookBook.Options["show_recipe_level_start_on_ingredient"] then
        BitesCookBook.Options["show_recipe_level_range_on_ingredient"] = false
        AffectedFrame:Disable()
        -- AffectedFrame.text:SetTextColor(0.5, 0.5, 0.5)
        getglobal(AffectedFrame:GetName() .. 'Text'):SetTextColor(0.5, 0.5, 0.5)

        AffectedFrame:SetChecked(false)
    else
        AffectedFrame:Enable()
        -- AffectedFrame.text:SetTextColor(1, 1, 1)
        getglobal(AffectedFrame:GetName() .. 'Text'):SetTextColor(1, 1, 1)
    end
end

PreventColor = function()
    AffectedFrame = BitesCookBook_ConfigFrame["color_meal"]
    if BitesCookBook.Options["gray_minimum_rank"] then
        BitesCookBook.Options["color_meal"] = false
        AffectedFrame:Disable()
        -- AffectedFrame.text:SetTextColor(0.5, 0.5, 0.5)
        getglobal(AffectedFrame:GetName() .. 'Text'):SetTextColor(0.5, 0.5, 0.5)

        AffectedFrame:SetChecked(false)
    else
        AffectedFrame:Enable()
        -- AffectedFrame.text:SetTextColor(1, 1, 1)
        getglobal(AffectedFrame:GetName() .. 'Text'):SetTextColor(1, 1, 1)
    end
end

PreventGray = function()
    AffectedFrame = BitesCookBook_ConfigFrame["gray_minimum_rank"]
    if BitesCookBook.Options["color_meal"] then
        BitesCookBook.Options["gray_minimum_rank"] = false
        AffectedFrame:Disable()
        -- AffectedFrame.text:SetTextColor(0.5, 0.5, 0.5)
        getglobal(AffectedFrame:GetName() .. 'Text'):SetTextColor(0.5, 0.5, 0.5)

        AffectedFrame:SetChecked(false)
    else
        AffectedFrame:Enable()
        -- AffectedFrame.text:SetTextColor(1, 1, 1)
        getglobal(AffectedFrame:GetName() .. 'Text'):SetTextColor(1, 1, 1)
    end
end

function BitesCookBook:InitializeOptionsMenu()    
        BitesCookBook_ConfigFrame = CreateFrame("Frame", "BitesCookBook_InterfaceOptionsPanel", UIParent)
        BitesCookBook_ConfigFrame.name = "Bites"
        InterfaceOptions_AddCategory(BitesCookBook_ConfigFrame)
    

        BitesCookBook_ConfigFrame.Ingredients = BitesCookBook:CreateTitle("Ingredients", "Ingredient Tooltips", "These are Options that modify which recipe-information is shown on the tooltip of ingredients.")

        BitesCookBook:CreateCheckBox("show_ingredient_tooltip", "Show ingredient tooltips.", PreventAllIngredients)    
        BitesCookBook:CreateCheckBox("hide_meals_but_hint", "Only show if an item is used for cooking.", PreventAllIngredientsFromHint)
    
        BitesCookBook:CreateCheckBox("show_recipe_level_start_on_ingredient", "Show at what skill level a meal becomes available.", PreventLevelRange)
        AllLevelRangesBox = BitesCookBook:CreateCheckBox("show_recipe_level_range_on_ingredient", "Also show at what subsequent sill-levels the meal's efficiency changes.")
        AllLevelRangesBox:SetPoint("TOPLEFT", 20 + 20, -Position + DeltaP_Box)

        BitesCookBook:CreateCheckBox("gray_minimum_rank", "Gray out recipes that are not yet available to your rank.", PreventColor)
        BitesCookBook:CreateCheckBox("color_meal", "Color a meal according to your rank.", PreventGray)
        BitesCookBook:CreateCheckBox("show_recipe_icon", "Show a picture of the meal.")
    
        -- A horizontal sliding bar that controls the max level.
        BitesCookBook_ConfigFrame.max_level = CreateFrame("Slider", "BitesCookBook_MaxLevel", BitesCookBook_ConfigFrame, "OptionsSliderTemplate")
        BitesCookBook_ConfigFrame.max_level:SetMinMaxValues(0, 300)
        BitesCookBook_ConfigFrame.max_level:SetValueStep(10)
        BitesCookBook_ConfigFrame.max_level:SetObeyStepOnDrag(true)
        BitesCookBook_ConfigFrame.max_level:SetOrientation("HORIZONTAL")
        BitesCookBook_ConfigFrame.max_level:SetSize(200, 20)
        BitesCookBook_ConfigFrame.max_level:SetPoint("TOPLEFT", 10, -Position - DeltaP_Box)
        BitesCookBook_ConfigFrame.max_level:SetScript("OnValueChanged",
        function(self, value)
            BitesCookBook.Options.max_level = value
            BitesCookBook_ConfigFrame.max_level.text:SetText("Rank threshold "..BitesCookBook.Options.max_level)
        end)
        BitesCookBook_ConfigFrame.max_level.text = BitesCookBook_ConfigFrame.max_level:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        BitesCookBook_ConfigFrame.max_level.text:SetPoint("BOTTOMLEFT", BitesCookBook_ConfigFrame.max_level, "TOPLEFT", 0, 0)
        BitesCookBook_ConfigFrame.max_level.text:SetText("Rank threshold "..BitesCookBook.Options.max_level)
        BitesCookBook_ConfigFrame.max_level:SetValue(BitesCookBook.Options.max_level)
    
        Position = Position + DeltaP_Box + 20
        
        BitesCookBook_ConfigFrame.Recipes = BitesCookBook:CreateTitle("Recipes", "Recipe Tooltips", "These are Options that modify which ingerdient-information is shown on the tooltip of ingredients.")
        BitesCookBook:CreateCheckBox("show_recipe_tooltip", "Show meal/recipe tooltips.")
    
        BitesCookBook_ConfigFrame.Misc = BitesCookBook:CreateTitle("Misc", "Miscellaneous", "")
        
        PreventColor()
        PreventGray()
        PreventLevelRange()
    
        -- A dropdrown frame.
        BitesCookBook_ConfigFrame.show_or_hide = CreateFrame("Frame", "BitesCookBook_Dropdown", BitesCookBook_ConfigFrame, "UIDropDownMenuTemplate")
        BitesCookBook_ConfigFrame.show_or_hide:SetPoint("TOPLEFT", 10, -Position - DeltaP_Box)
        BitesCookBook_ConfigFrame.show_or_hide.text = BitesCookBook_ConfigFrame.show_or_hide:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        BitesCookBook_ConfigFrame.show_or_hide.text:SetPoint("BOTTOMLEFT", BitesCookBook_ConfigFrame.show_or_hide, "TOPLEFT", 21, 0)
        BitesCookBook_ConfigFrame.show_or_hide.text:SetText("When modifier is pressed:")
        -- Set the text of the dropdown.
        
        if BitesCookBook.Options.show_on_modifier == 0 then
            UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.show_or_hide, "Do nothing")
        elseif BitesCookBook.Options.show_on_modifier == true then
            UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.show_or_hide, "Show tooltip")
        else
            UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.show_or_hide, "Hide tooltip")
        end
    
        -- Add the Options to the dropdown.
        UIDropDownMenu_Initialize(BitesCookBook_ConfigFrame.show_or_hide, function(self, level, menuList)
            local info = UIDropDownMenu_CreateInfo()
            info.text, info.arg1, info.func, info.checked = "Do nothing", "Do nothing",
            function(self)
                BitesCookBook.Options.show_on_modifier = 0
                UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.show_or_hide, "Do nothing")
            end,
            BitesCookBook.Options.show_on_modifier == 0
            UIDropDownMenu_AddButton(info)
    
            --------------------
            info.text, info.arg1, info.func, info.checked = "Show tooltip", "Show tooltip",
            function(self)
                BitesCookBook.Options.show_on_modifier = true
                UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.show_or_hide, "Show tooltip")
            end,
            BitesCookBook.Options.show_on_modifier == true
            UIDropDownMenu_AddButton(info)
            
            --------------------
            info.text, info.arg1, info.func, info.checked = "Hide tooltip", "Hide tooltip",
            function(self)
                BitesCookBook.Options.show_on_modifier = false
                UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.show_or_hide, "Hide tooltip")
            end,
            BitesCookBook.Options.show_on_modifier == false
            UIDropDownMenu_AddButton(info)
        end)
    
        -- A dropdrown frame.
        BitesCookBook_ConfigFrame.modifier = CreateFrame("Frame", "BitesCookBook_DropdownModifier", BitesCookBook_ConfigFrame, "UIDropDownMenuTemplate")
        BitesCookBook_ConfigFrame.modifier:SetPoint("TOPLEFT", 250, -Position - DeltaP_Box)
        BitesCookBook_ConfigFrame.modifier.text = BitesCookBook_ConfigFrame.modifier:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        BitesCookBook_ConfigFrame.modifier.text:SetPoint("BOTTOMLEFT", BitesCookBook_ConfigFrame.modifier, "TOPLEFT", 21, 0)
        BitesCookBook_ConfigFrame.modifier.text:SetText("Reveal Tooltip Key")
        
        UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.modifier, BitesCookBook.Options.modifier_key.. " Key")
    
        -- Add the Options to the dropdown.
        UIDropDownMenu_Initialize(BitesCookBook_ConfigFrame.modifier, function(self, level, menuList)
            local info = UIDropDownMenu_CreateInfo()
            info.text, info.arg1, info.func, info.checked = "SHIFT Key", "SHIFT Key",
            function(self)
                BitesCookBook.Options.modifier_key = "SHIFT"
                UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.modifier, BitesCookBook.Options.modifier_key.. " Key")
            end,
            BitesCookBook.Options.modifier_key == "SHIFT"
            UIDropDownMenu_AddButton(info)
    
            info.text, info.arg1, info.func, info.checked = "CTRL Key", "CTRL Key",
            function(self)
                BitesCookBook.Options.modifier_key = "CTRL"
                UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.modifier, BitesCookBook.Options.modifier_key.. " Key")
            end,
            BitesCookBook.Options.modifier_key == "CTRL"
            UIDropDownMenu_AddButton(info)
    
            info.text, info.arg1, info.func, info.checked = "ALT Key", "ALT Key",
            function(self)
                BitesCookBook.Options.modifier_key = "ALT"
                UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.modifier, BitesCookBook.Options.modifier_key.. " Key")
            end,
            BitesCookBook.Options.modifier_key == "ALT"
            UIDropDownMenu_AddButton(info)
        end)
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
    BitesCookBook_ConfigFrame[Name] = CreateFrame("CheckButton", Name, BitesCookBook_ConfigFrame, "UICheckButtonTemplate")
    BitesCookBook_ConfigFrame[Name]:SetPoint("TOPLEFT", 20, -Position)
    
    getglobal(BitesCookBook_ConfigFrame[Name]:GetName() .. 'Text'):SetText(Description)
    getglobal(BitesCookBook_ConfigFrame[Name]:GetName() .. 'Text'):SetTextColor(1, 1, 1, 1)

    BitesCookBook_ConfigFrame[Name]:SetChecked(BitesCookBook.Options[Name])
    BitesCookBook_ConfigFrame[Name]:SetScript("OnClick",
        function()
            BitesCookBook.Options[Name] = not BitesCookBook.Options[Name]

            -- Sometimes we want to do something extra after the checkbox is clicked.
            if ExtraFunction ~= nil then
                ExtraFunction()
            end
        end
    )

    Position = Position +DeltaP_Box

    return BitesCookBook_ConfigFrame[Name]
end