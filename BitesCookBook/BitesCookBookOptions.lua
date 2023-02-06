BitesCookBook = CreateFrame("Frame")

function BitesCookBook:OnEvent(event, ...)
	self[event](self, event, ...)
end

BitesCookBook:SetScript("OnEvent", BitesCookBook.OnEvent)
BitesCookBook:RegisterEvent("ADDON_LOADED")

function BitesCookBook:ADDON_LOADED(event, addOnName)
	if addOnName ~= "BitesCookBook" then return end

	self:InitializeOptionsMenu()
	self:UnregisterEvent(event)
end

function BitesCookBook:InitializeOptionsMenu()
	BitesCookBook_ConfigFrame = CreateFrame("Frame", "BitesCookBook_InterfaceOptionsPanel", UIParent);
    BitesCookBook_ConfigFrame.name = "Bites";
    InterfaceOptions_AddCategory(BitesCookBook_ConfigFrame);
end