local AddonName, NS = ...

-- Events registered by the chat filter.
NS.ChatEvents = {
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

-- Equivalents
NS.ChatGroups = {
    CHAT_MSG_PARTY_LEADER = "CHAT_MSG_PARTY",
    CHAT_MSG_RAID_LEADER = "CHAT_MSG_RAID",
    CHAT_MSG_INSTANCE_CHAT_LEADER = "CHAT_MSG_INSTANCE_CHAT",
    CHAT_MSG_WHISPER_INFORM = "CHAT_MSG_WHISPER",
}

-- Order to display in configuration
NS.ChatOrder = {
    "CHAT_MSG_SAY",
    "CHAT_MSG_YELL",
    "CHAT_MSG_WHISPER",
    "CHAT_MSG_PARTY",
    "CHAT_MSG_RAID",
    "CHAT_MSG_INSTANCE_CHAT",
    "CHAT_MSG_GUILD",
    "CHAT_MSG_OFFICER",
    "CHAT_MSG_CHANNEL",
}

-- Default values
NS.ChatDefaults = {
    CHAT_MSG_SAY = {
        Class = true,
        Race = true,
        Level = true,
    },

    CHAT_MSG_YELL = {
        Class = true,
        Race = true,
        Level = true,
    },

    CHAT_MSG_WHISPER = {
        Class = true,
        Race = true,
        Level = true,
    },

    CHAT_MSG_PARTY = {
        Class = true,
        Race = true,
        Level = true,
    },

    CHAT_MSG_RAID = {
        Class = true,
        Race = true,
        Level = true,
    },

    CHAT_MSG_INSTANCE_CHAT = {
        Class = true,
        Race = true,
        Level = true,
    },

    CHAT_MSG_GUILD = {
        Class = true,
        Race = true,
        Level = true,
    },

    CHAT_MSG_OFFICER = {
        Class = true,
        Race = true,
        Level = true,
    },

    CHAT_MSG_CHANNEL = {
        Class = true,
        Race = true,
        Level = true,
    },
}
