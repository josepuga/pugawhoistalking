-- Chats validator.
-- Development tool only; run from tools/ with: lua check-chats.lua

local NS = {}
assert(loadfile("../ChatData.lua"))("PugaWhoIsTalking", NS)

local Errors = 0

local function Error(Message)
    Errors = Errors + 1
    io.stderr:write("ERROR: ", Message, "\n")
end

local function IsTable(Value, Name)
    if type(Value) ~= "table" then
        Error(Name .. " must be a table")
        return false
    end
    return true
end

local function CheckChats()
    if not IsTable(NS.ChatOrder, "ChatOrder")
        or not IsTable(NS.ChatDefaults, "ChatDefaults")
        or not IsTable(NS.ChatGroups, "ChatGroups")
        or not IsTable(NS.ChatEvents, "ChatEvents") then
        return
    end

    local Seen = {}
    local Fields = { "Class", "Race", "Level" }

    -- Every displayed channel must have defaults, and appear only once.
    for Index, Event in ipairs(NS.ChatOrder) do
        if type(Event) ~= "string" then
            Error("ChatOrder[" .. Index .. "] is not a string")
        else
            if Seen[Event] then
                Error("Duplicate in ChatOrder: " .. Event)
            end
            Seen[Event] = true

            if NS.ChatDefaults[Event] == nil then
                Error("Missing defaults for " .. Event)
            end
        end
    end

    -- Every configured channel must be displayed, with boolean fields.
    for Event, Defaults in pairs(NS.ChatDefaults) do
        if not Seen[Event] then
            Error("Missing in ChatOrder: " .. tostring(Event))
        end

        if type(Defaults) ~= "table" then
            Error("Defaults for " .. tostring(Event) .. " must be a table")
        else
            for _, Field in ipairs(Fields) do
                if type(Defaults[Field]) ~= "boolean" then
                    Error(tostring(Event) .. "." .. Field .. " must be boolean")
                end
            end
            for Field in pairs(Defaults) do
                if Field ~= "Class" and Field ~= "Race" and Field ~= "Level" then
                    Error("Unexpected field " .. tostring(Event) .. "." .. tostring(Field))
                end
            end
        end
    end

    -- Aliases must reference a real, configurable channel.
    for Alias, Event in pairs(NS.ChatGroups) do
        if Alias == Event then
            Error("Self-referencing chat alias: " .. tostring(Alias))
        end
        if NS.ChatDefaults[Event] == nil then
            Error("Alias " .. tostring(Alias) .. " targets unconfigured " .. tostring(Event))
        end
        if NS.ChatDefaults[Alias] ~= nil then
            Error("Alias " .. tostring(Alias) .. " also has separate defaults")
        end
    end
    -- Every registered event must resolve to a configured channel.
    -- Every visible configuration must be reachable from a registered event.
    local Registered = {}
    local Reachable = {}

    for Index, Event in ipairs(NS.ChatEvents) do
        if type(Event) ~= "string" then
            Error("ChatEvents[" .. Index .. "] is not a string")
        else
            if Registered[Event] then
                Error("Duplicate in ChatEvents: " .. Event)
            end
            Registered[Event] = true

            local ConfigEvent = NS.ChatGroups[Event] or Event
            if NS.ChatDefaults[ConfigEvent] == nil then
                Error("Registered event " .. Event .. " has no configuration")
            else
                Reachable[ConfigEvent] = true
            end
        end
    end

    for Event in pairs(NS.ChatDefaults) do
        if not Reachable[Event] then
            Error("Configuration " .. tostring(Event) .. " is not used by any registered event")
        end
    end

    for Alias in pairs(NS.ChatGroups) do
        if not Registered[Alias] then
            Error("Chat alias " .. tostring(Alias) .. " is not a registered event")
        end
    end

end

CheckChats()

-- TODO: Validate Locale/*.lua when translations are implemented.

if Errors > 0 then
    io.stderr:write(Errors .. " error(s) found.\n")
    os.exit(1)
end

print("Chat configuration: OK")
os.exit(0)
