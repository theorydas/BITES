local CookingSkillRank

-- When the addon is loaded, we want to get the player's cooking skill.
function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" and ... == "BitesCookBook" then
        -- Get the player's cooking skill.
        print("Addon has loaded")
        CookingSkillRank = GetSkillLevel("Cooking")

        -- Unregister the event, we do not need it anymore.
        self:UnregisterEvent("ADDON_LOADED");
    
    -- Additionally, we want to update the player's cooking skill when they level up.
    elseif event == "CHAT_MSG_SKILL" then
        CookingSkillRank = GetSkillLevel("Cooking")
    end
end

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

-- Create a frame to listen to events.
local TemporaryFrame = CreateFrame("Frame")
TemporaryFrame:RegisterEvent("ADDON_LOADED")
TemporaryFrame:RegisterEvent("CHAT_MSG_SKILL")
TemporaryFrame:SetScript("OnEvent", OnEvent)