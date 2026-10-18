local AddonName, NS = ...


local function PugaWhoIsTalkingFilter(
    self,
    Event,
    Message,
    Author,
    ...
)
    local Args = { ... }

    local GUID = NS.NormalizeGUID(Args[10])

    if GUID == nil then
        return false
    end

    -- Resolve equivalent chat events.
    local ConfigEvent = NS.ChatGroups[Event] or Event
    local Config = NS.ChatDefaults[ConfigEvent]

    if not Config then
        return false
    end

    -- Get available icons.
    local RaceIcon, ClassIcon, LevelIcon = NS.GetIcons(GUID)
    local Icons = {}

    if Config.Class and ClassIcon then
        table.insert(Icons, ClassIcon)
    end

    if Config.Race and RaceIcon then
        table.insert(Icons, RaceIcon)
    end

    if Config.Level and LevelIcon then
        table.insert(Icons, LevelIcon)
    end

    if #Icons == 0 then
        return false
    end

    Message = table.concat(Icons, "") .. " " .. Message

    return false, Message, Author, ...
end

local ChatEvents = {
    "CHAT_MSG_SAY",
    "CHAT_MSG_YELL",
    "CHAT_MSG_WHISPER",
    "CHAT_MSG_PARTY",
    "CHAT_MSG_PARTY_LEADER",
    "CHAT_MSG_RAID",
    "CHAT_MSG_RAID_LEADER",
    "CHAT_MSG_INSTANCE_CHAT",
    "CHAT_MSG_INSTANCE_CHAT_LEADER",
    "CHAT_MSG_GUILD",
    "CHAT_MSG_CHANNEL",
    "CHAT_MSG_OFFICER",
    "CHAT_MSG_WHISPER_INFORM",
}

for _, Event in ipairs(ChatEvents) do
    ChatFrame_AddMessageEventFilter(
        Event,
        PugaWhoIsTalkingFilter
    )
end
