BitesCookBook = CreateFrame("Frame")
BitesCookBook.Options = {
	ShowIngredientTooltip = true,
        HideReagentTooltipsButHint = false, -- If true, the reagent tooltips will be hidden, but a hint will still be shown.
        ShowCraftableFirstRank = false, -- In the reagent tooltip, show the first rank of the craftable item.
            ShowCraftableRankRange = false, -- In the reagent tooltip, also show the subsequent rank range of the craftable item.
        ShowCraftableIcon = true, -- In the reagent tooltip, show the icon of the craftable item.
        GrayHighCraftables = false, -- In the reagent tooltip, gray out the craftable if it is too high rank.
        ColorCraftableByRank = true, -- In the reagent tooltip, color the craftable item by rank.
    DeltaRank = 100, -- In the reagent tooltip, Craftables until player's rank + DeltaRank will be shown.
	ShowCraftableTooltip = false, -- In the craftable tooltip, show required reagents.
	ShowEnemyTooltip = true, -- In the enemy tooltip, show droppable reagents.
	HasModifier = 0, -- 0 = no modifier, true = has modifier, false = has inverse modifier
    ModifierKey = "SHIFT", -- SHIFT, ALT, CTRL
}

function BitesCookBook.ADDON_LOADED(self, event, addonName)
    if addonName ~= "BitesCookBook" then return end

    BitesCookBook:ConfigureSavedVariables() -- Set or load the saved variables.
    BitesCookBook:InitializeOptionsMenu() -- Build the options menu.
    BitesCookBook.Recipes, BitesCookBook.Reagents = BitesCookBook:GetListsForVersion() -- Choose the correct recipe and reagent lists.

    -- Dynamically create a list for all ingredients and their associated recipes, or mobs and their associated reagent drops.
    BitesCookBook.CraftablesForReagent = BitesCookBook:GetAllIngredients(BitesCookBook.Recipes)
    BitesCookBook.MobsDroppingReagent = BitesCookBook:GetAllMobs(BitesCookBook.Reagents)

    -- The addon-loading event is unregistered.
    BitesCookBook:UnregisterEvent(event)
end

function BitesCookBook.PLAYER_ENTERING_WORLD(BitesCookBook, event)
    -- Get the player's cooking skill level.
    BitesCookBook.CookingSkillRank = BitesCookBook:GetSkillLevel("Cooking")

    -- The player-entering-world event is unregistered.
    BitesCookBook:UnregisterEvent(event)
end

function BitesCookBook.CHAT_MSG_SKILL(BitesCookBook, event)
    -- Update the player's cooking skill level.
    BitesCookBook.CookingSkillRank = BitesCookBook:GetSkillLevel("Cooking")
end

function BitesCookBook.OnEvent(self, Event, AddonName)
    -- Call the function with the same name as the event.
    self[Event](self, Event, AddonName)
end

BitesCookBook:RegisterEvent("CHAT_MSG_SKILL")
BitesCookBook:RegisterEvent("ADDON_LOADED")
BitesCookBook:RegisterEvent("PLAYER_ENTERING_WORLD")
BitesCookBook:SetScript("OnEvent", BitesCookBook.OnEvent)

--------------------------------------------------------------------------------
-- Helper functions
--------------------------------------------------------------------------------

function BitesCookBook:GetAllIngredients(RecipeList)
    -- Dynamically create a list for all ingredients and their associated recipes.
    local Reagents = {}
    
    for recipe_key, recipe in pairs(RecipeList) do
        for ingredient, _ in pairs(recipe["Materials"]) do
            if Reagents[ingredient] == nil then
                Reagents[ingredient] = {recipe_key}
            else
                table.insert(Reagents[ingredient], recipe_key)
            end
        end
    end

    -- sort each ingredient list based on the recipe range[1]
    for ingredient, recipe_list in pairs(Reagents) do
        table.sort(recipe_list, function(a, b)
            return RecipeList[a]["Range"][1] > RecipeList[b]["Range"][1]
        end)
    end

    return Reagents
end

function BitesCookBook:GetAllMobs(ReagentsDict)
    -- Dynamically create a list for all Mobs and their associated reagent drops.
    local MobsAndDrops = {}
    
    for DropID, DropDetails in pairs(ReagentsDict) do
        for MobID, ChangeToDropReagent in pairs(DropDetails.DroppedBy) do
            if MobsAndDrops[MobID] == nil then
                MobsAndDrops[MobID] = {}
            end
            
            table.insert(MobsAndDrops[MobID], DropID)
        end
    end

    return MobsAndDrops
end

function BitesCookBook:GetSkillLevel(SkillName)
    -- Get a profession's skill level.
    for skillIndex = 1, GetNumSkillLines() do
        local SkillInfo = {GetSkillLineInfo(skillIndex)}

        if SkillInfo[1] == SkillName then
            return SkillInfo[4]
        end
    end
    
    -- If we cannot not find the skill, the rank is 0.
    return 0
end

function BitesCookBook:ConfigureSavedVariables()
    -- Set the saved variables to the default values if they are not set.
    if BitesCookBook_SavedVariables == nil then
        BitesCookBook_SavedVariables = self.Options
    else
        -- If new Options were added since last file was saved, we must update it.
        for key, option_value in pairs(self.Options) do
            if BitesCookBook_SavedVariables[key] == nil then
                BitesCookBook_SavedVariables[key] = option_value
            end
        end

        -- if an option was removed, we must also remove it from the saved variables.
        for key, option_value in pairs(BitesCookBook_SavedVariables) do
            if self.Options[key] == nil then
                BitesCookBook_SavedVariables[key] = nil
            end
        end

        -- Let Options be the (updated) saved variables.
        self.Options = BitesCookBook_SavedVariables
    end

    return
end

function BitesCookBook:GetListsForVersion()
    -- Detect if we are in classic.
    local isClassic = select(4, GetBuildInfo()) < 30000
    if isClassic then
        print("BitesCookBook: Classic.")
        return BitesCookBook_RecipesClassic, BitesCookBook_ReagentsClassic
    else
        print("BitesCookBook: Wrath of the Lich King.")
        return BitesCookBook_RecipesWotLK, BitesCookBook_ReagentsWotLK
    end
end