-- Chats validator. 
-- Not for use in WoW, Development tool only.
-- Run from tools/ with: lua check-chats.lua
--[[
    * Todos los canales de ChatOrder deben existir en ChatDefaults.
    * Ningún canal de ChatDefaults puede faltar en ChatOrder.
    * No puede haber canales duplicados en ChatOrder.
    * Cada canal debe definir Class, Race y Level, con valores booleanos.
    * Las equivalencias de ChatGroups deben apuntar a canales configurados.
    * Detecta campos inesperados y equivalencias incorrectas.
--]]

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
        or not IsTable(NS.ChatGroups, "ChatGroups") then
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
end

CheckChats()

-- TODO: Validate Locale/*.lua when translations are implemented.
-- TODO: Cross-check all registered chat events once the event list is in ChatData.lua.

if Errors > 0 then
    io.stderr:write(Errors .. " error(s) found.\n")
    os.exit(1)
end

print("Chat configuration: OK")
os.exit(0)
