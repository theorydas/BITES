function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" and ... == "BitesCookBook" then
        -- Get the player's cooking skill.
        print("Addon has loaded")

        -- Unregister the event, we do not need it anymore.
        self:UnregisterEvent("ADDON_LOADED");
    end
end

-- Create a frame to listen to events.
local TemporaryFrame = CreateFrame("Frame")
TemporaryFrame:RegisterEvent("ADDON_LOADED")
TemporaryFrame:SetScript("OnEvent", OnEvent)