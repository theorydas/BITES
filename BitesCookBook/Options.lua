--------------------------------------------------------------------------------
-- Exclusive option functions
--------------------------------------------------------------------------------

local function FrameSwitch(AffectedFrame, ShouldBeEnabled)
    if ShouldBeEnabled then
        AffectedFrame:Enable()
        getglobal(AffectedFrame:GetName() .. 'Text'):SetTextColor(1, 1, 1)
    else
        AffectedFrame:Disable()
        getglobal(AffectedFrame:GetName() .. 'Text'):SetTextColor(0.5, 0.5, 0.5)
        AffectedFrame:SetChecked(false) -- Uncheck the box.
    end
end

local function PreventLevelRange()
    local AffectedFrame = BitesCookBook_ConfigFrame["ShowCraftableRankRange"]

    if not BitesCookBook.Options["ShowCraftableFirstRank"] then -- Beware of the NOT!
        BitesCookBook.Options["ShowCraftableRankRange"] = false
        FrameSwitch(AffectedFrame, false)
    else
        FrameSwitch(AffectedFrame, true)
    end
end

local function PreventColor()
    local AffectedFrame = BitesCookBook_ConfigFrame["ColorCraftableByRank"]

    if BitesCookBook.Options["GrayHighCraftables"] then
        BitesCookBook.Options["ColorCraftableByRank"] = false
        FrameSwitch(AffectedFrame, false)
    else
        FrameSwitch(AffectedFrame, true)
    end
end

local function PreventGray()
    local AffectedFrame = BitesCookBook_ConfigFrame["GrayHighCraftables"]

    if BitesCookBook.Options["ColorCraftableByRank"] then
        BitesCookBook.Options["GrayHighCraftables"] = false
        FrameSwitch(AffectedFrame, false)
    else
        FrameSwitch(AffectedFrame, true)
    end
end

local function PreventAllIngredients()
    local AffectedFrames = {"ShowCraftableFirstRank", "ShowCraftableRankRange", "HideReagentTooltipsButHint", "GrayHighCraftables", "ColorCraftableByRank", "ShowCraftableIcon"}
    
    -- Iterate over the frames and disable them if the option is checked.
    for i, frame_name in ipairs(AffectedFrames) do
        local AffectedFrame = BitesCookBook_ConfigFrame[frame_name]
        if not BitesCookBook.Options["ShowIngredientTooltip"] then  -- Beware of the NOT!
            BitesCookBook.Options[frame_name] = false
            FrameSwitch(AffectedFrame, false)
        else
            FrameSwitch(AffectedFrame, true)
        end
        
        -- Update other functions as well. What is the best way to do this?
        PreventLevelRange()
    end
end

local function PreventAllIngredientsFromHint()
    local AffectedFrames = {"ShowCraftableFirstRank", "ShowCraftableRankRange", "GrayHighCraftables", "ColorCraftableByRank", "ShowCraftableIcon"}
    
    -- Iterate over the frames and disable them if the option is checked.
    for i, frame_name in ipairs(AffectedFrames) do
        local AffectedFrame = BitesCookBook_ConfigFrame[frame_name]
        if BitesCookBook.Options["HideReagentTooltipsButHint"] then
            BitesCookBook.Options[frame_name] = false
            FrameSwitch(AffectedFrame, false)
        else
            FrameSwitch(AffectedFrame, true)
        end

        -- Update other functions as well. What is the best way to do this?
        PreventLevelRange()
    end
end

--------------------------------------------------------------------------------

-- Keep track of the vertical position of option items.
local Position = -10
local DeltaP_Box = 29

function BitesCookBook:InitializeOptionsMenu()
    BitesCookBook_ConfigFrame = CreateFrame("Frame", "BitesCookBook_InterfaceOptionsPanel", UIParent)
    BitesCookBook_ConfigFrame.name = "Bites"
    InterfaceOptions_AddCategory(BitesCookBook_ConfigFrame)


    BitesCookBook_ConfigFrame.Ingredients = BitesCookBook:CreateTitle("Ingredients", "Ingredient Tooltips", "These are Options that modify which recipe-information is shown on the tooltip of ingredients.")

    BitesCookBook:CreateCheckBox("ShowIngredientTooltip", "Show ingredient tooltips.", PreventAllIngredients)    
    BitesCookBook:CreateCheckBox("HideReagentTooltipsButHint", "Only show if an item is used for cooking.", PreventAllIngredientsFromHint)

    BitesCookBook:CreateCheckBox("ShowCraftableFirstRank", "Show at what skill level a meal becomes available.", PreventLevelRange)
    AllLevelRangesBox = BitesCookBook:CreateCheckBox("ShowCraftableRankRange", "Also show at what subsequent skill-levels the meal's efficiency changes.")
    AllLevelRangesBox:SetPoint("TOPLEFT", 20 + 20, -Position + DeltaP_Box)

    BitesCookBook:CreateCheckBox("GrayHighCraftables", "Gray out recipes that are not yet available to your rank.", PreventColor)
    BitesCookBook:CreateCheckBox("ColorCraftableByRank", "Color a meal according to your rank.", PreventGray)
    BitesCookBook:CreateCheckBox("ShowCraftableIcon", "Show a picture of the meal.")

    -- A horizontal sliding bar that controls the max level.
    BitesCookBook_ConfigFrame.DeltaRank = CreateFrame("Slider", "BitesCookBook_MaxLevel", BitesCookBook_ConfigFrame, "OptionsSliderTemplate")
    BitesCookBook_ConfigFrame.DeltaRank:SetMinMaxValues(0, 300)
    BitesCookBook_ConfigFrame.DeltaRank:SetValueStep(10)
    BitesCookBook_ConfigFrame.DeltaRank:SetObeyStepOnDrag(true)
    BitesCookBook_ConfigFrame.DeltaRank:SetOrientation("HORIZONTAL")
    BitesCookBook_ConfigFrame.DeltaRank:SetSize(200, 20)
    BitesCookBook_ConfigFrame.DeltaRank:SetPoint("TOPLEFT", 10, -Position - DeltaP_Box)
    BitesCookBook_ConfigFrame.DeltaRank:SetScript("OnValueChanged",
    function(self, value)
        BitesCookBook.Options.DeltaRank = value
        BitesCookBook_ConfigFrame.DeltaRank.text:SetText("Rank threshold "..BitesCookBook.Options.DeltaRank)
    end)
    BitesCookBook_ConfigFrame.DeltaRank.text = BitesCookBook_ConfigFrame.DeltaRank:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    BitesCookBook_ConfigFrame.DeltaRank.text:SetPoint("BOTTOMLEFT", BitesCookBook_ConfigFrame.DeltaRank, "TOPLEFT", 0, 0)
    BitesCookBook_ConfigFrame.DeltaRank.text:SetText("Rank threshold "..BitesCookBook.Options.DeltaRank)
    BitesCookBook_ConfigFrame.DeltaRank:SetValue(BitesCookBook.Options.DeltaRank)

    Position = Position + DeltaP_Box + 20
    
    
    BitesCookBook_ConfigFrame.Misc = BitesCookBook:CreateTitle("Misc", "Miscellaneous", "")
    BitesCookBook:CreateCheckBox("ShowCraftableTooltip", "Show meal/recipe tooltips.")
    BitesCookBook:CreateCheckBox("ShowEnemyTooltip", "Show possible ingredients under enemies.")
    
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
    
    if BitesCookBook.Options.HasModifier == 0 then
        UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.show_or_hide, "Do nothing")
    elseif BitesCookBook.Options.HasModifier == true then
        UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.show_or_hide, "Show tooltip")
    else
        UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.show_or_hide, "Hide tooltip")
    end

    -- Add the Options to the dropdown.
    UIDropDownMenu_Initialize(BitesCookBook_ConfigFrame.show_or_hide, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        info.text, info.arg1, info.func, info.checked = "Do nothing", "Do nothing",
        function(self)
            BitesCookBook.Options.HasModifier = 0
            UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.show_or_hide, "Do nothing")
        end,
        BitesCookBook.Options.HasModifier == 0
        UIDropDownMenu_AddButton(info)

        --------------------
        info.text, info.arg1, info.func, info.checked = "Show tooltip", "Show tooltip",
        function(self)
            BitesCookBook.Options.HasModifier = true
            UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.show_or_hide, "Show tooltip")
        end,
        BitesCookBook.Options.HasModifier == true
        UIDropDownMenu_AddButton(info)
        
        --------------------
        info.text, info.arg1, info.func, info.checked = "Hide tooltip", "Hide tooltip",
        function(self)
            BitesCookBook.Options.HasModifier = false
            UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.show_or_hide, "Hide tooltip")
        end,
        BitesCookBook.Options.HasModifier == false
        UIDropDownMenu_AddButton(info)
    end)

    -- A dropdrown frame.
    BitesCookBook_ConfigFrame.modifier = CreateFrame("Frame", "BitesCookBook_DropdownModifier", BitesCookBook_ConfigFrame, "UIDropDownMenuTemplate")
    BitesCookBook_ConfigFrame.modifier:SetPoint("TOPLEFT", 250, -Position - DeltaP_Box)
    BitesCookBook_ConfigFrame.modifier.text = BitesCookBook_ConfigFrame.modifier:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    BitesCookBook_ConfigFrame.modifier.text:SetPoint("BOTTOMLEFT", BitesCookBook_ConfigFrame.modifier, "TOPLEFT", 21, 0)
    BitesCookBook_ConfigFrame.modifier.text:SetText("Reveal Tooltip Key")
    
    UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.modifier, BitesCookBook.Options.ModifierKey.. " Key")

    -- Add the Options to the dropdown.
    UIDropDownMenu_Initialize(BitesCookBook_ConfigFrame.modifier, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        info.text, info.arg1, info.func, info.checked = "SHIFT Key", "SHIFT Key",
        function(self)
            BitesCookBook.Options.ModifierKey = "SHIFT"
            UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.modifier, BitesCookBook.Options.ModifierKey.. " Key")
        end,
        BitesCookBook.Options.ModifierKey == "SHIFT"
        UIDropDownMenu_AddButton(info)

        info.text, info.arg1, info.func, info.checked = "CTRL Key", "CTRL Key",
        function(self)
            BitesCookBook.Options.ModifierKey = "CTRL"
            UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.modifier, BitesCookBook.Options.ModifierKey.. " Key")
        end,
        BitesCookBook.Options.ModifierKey == "CTRL"
        UIDropDownMenu_AddButton(info)

        info.text, info.arg1, info.func, info.checked = "ALT Key", "ALT Key",
        function(self)
            BitesCookBook.Options.ModifierKey = "ALT"
            UIDropDownMenu_SetText(BitesCookBook_ConfigFrame.modifier, BitesCookBook.Options.ModifierKey.. " Key")
        end,
        BitesCookBook.Options.ModifierKey == "ALT"
        UIDropDownMenu_AddButton(info)
    end)
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