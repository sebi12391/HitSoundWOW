local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "HitSound" then
        -- Initialize HitSoundDB if it doesn't exist
        HitSoundDB = HitSoundDB or { enabled = true }

        local messageStatusColor = HitSoundDB.enabled and "|cFF00FF00Enabled|r" or "|cFFFF0000Disabled|r"
        print("HitSound is currently " .. messageStatusColor)

    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        self:OnCombatEvent(CombatLogGetCurrentEventInfo())
    end
end)

function frame:OnCombatEvent(...)
    if not HitSoundDB.enabled then
        return
    end
    local _, subevent, _, sourceGUID, _, _, _, _, _, _, _, _, _, _, amount = ...
    if subevent == "SPELL_DAMAGE" or subevent == "RANGE_DAMAGE" or subevent == "SWING_DAMAGE" then
        if sourceGUID == UnitGUID("player") then
            PlaySoundFile("Interface\\AddOns\\HitSound\\HitSound.mp3")
        end
    end
end

SLASH_HITSOUND1 = "/hitsound"
SlashCmdList["HITSOUND"] = function(msg)
    HitSoundDB.enabled = not HitSoundDB.enabled
    local messageStatusColor = HitSoundDB.enabled and "|cFF00FF00Enabled|r" or "|cFFFF0000Disabled|r"
    print("HitSound is now " .. messageStatusColor)
end

SLASH_TESTHITSOUND1 = "/testhitsound"
SlashCmdList["TESTHITSOUND"] = function(msg)
    PlaySoundFile("Interface\\AddOns\\HitSound\\HitSound.mp3")
    print("Testing HitSound playback.")
end
