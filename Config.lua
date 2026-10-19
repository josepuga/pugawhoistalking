local AddonName, NS = ...
local PL = PugaLib

local Fields = { "Class", "Race", "Level" }
local ColumnX = { 260, 365, 470 }
local RowHeight = 32
local FirstRowY = 105

local function InitDefaults()
    PugaWhoIsTalking = PugaWhoIsTalking or {}

    for _, Event in ipairs(NS.ChatOrder) do
        local Defaults = NS.ChatDefaults[Event]
        local Config = PugaWhoIsTalking[Event]

        if type(Config) ~= "table" then
            Config = {}
            PugaWhoIsTalking[Event] = Config
        end

        for _, Field in ipairs(Fields) do
            if type(Config[Field]) ~= "boolean" then
                Config[Field] = Defaults[Field]
            end
        end
    end
end

InitDefaults()

-- Select the current language, falling back to English.
NS.L = NS.Locale[GetLocale()] or NS.Locale.enUS
local Panel = CreateFrame("Frame")
Panel.name = AddonName
Panel:SetSize(620, 460)

local CheckBoxes = {}

local function NewLabel(Text, X, Y)
    return PL.UI:NewLabel(Panel, {
        Text = Text,
        X = X,
        Y = Y,
    })
end

NewLabel(AddonName, 20, 18)
NewLabel(NS.L.CLASS, ColumnX[1], 72)
NewLabel(NS.L.RACE, ColumnX[2], 72)
NewLabel(NS.L.LEVEL, ColumnX[3], 72)

for Index, Event in ipairs(NS.ChatOrder) do
    local Y = FirstRowY + (Index - 1) * RowHeight
    local Row = Panel:CreateTexture(nil, "BACKGROUND")
    Row:SetPoint("TOPLEFT", Panel, "TOPLEFT", 12, -(Y - 3))
    Row:SetSize(570, RowHeight - 2)
    Row:SetColorTexture(1, 1, 1, Index % 2 == 0 and 0.025 or 0.07)

    local Channel = Event:gsub("^CHAT_MSG_", "")
    local Name = NS.L.CHAT[Channel]
    NewLabel(Name, 24, Y)

    CheckBoxes[Event] = {}

    for FieldIndex, Field in ipairs(Fields) do
        local EventKey = Event
        local FieldKey = Field
        local Check = PL.UI:NewCheckBox(Panel, {
            Text = "",
            Checked = PugaWhoIsTalking[EventKey][FieldKey],
            X = ColumnX[FieldIndex],
            Y = Y - 5,
        })

        Check:SetScript("OnClick", function(Self)
            PugaWhoIsTalking[EventKey][FieldKey] = not not Self:GetChecked()
        end)

        CheckBoxes[EventKey][FieldKey] = Check
    end
end

NewLabel(NS.L.WHEN_AVAILABLE,
    20, FirstRowY + #NS.ChatOrder * RowHeight + 10)

-- Keep the displayed controls synchronized with saved preferences.
function Panel.OnRefresh()
    InitDefaults()

    for Event, Row in pairs(CheckBoxes) do
        for Field, Check in pairs(Row) do
            Check:SetChecked(PugaWhoIsTalking[Event][Field])
        end
    end
end

-- Changes are committed as soon as a checkbox is clicked.
function Panel.OnCommit()
end

-- Integrate with Blizzard's Reset to Defaults action.
function Panel.OnDefault()
    for _, Event in ipairs(NS.ChatOrder) do
        for _, Field in ipairs(Fields) do
            PugaWhoIsTalking[Event][Field] = NS.ChatDefaults[Event][Field]
        end
    end
    Panel.OnRefresh()
end

local Category = Settings.RegisterCanvasLayoutCategory(Panel, AddonName)
Settings.RegisterAddOnCategory(Category)
