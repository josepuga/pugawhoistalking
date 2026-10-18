local AddonName, NS = ...

local Sexes = {
    [2] = "male",
    [3] = "female",
}

local function GetSex(Sex)
    return Sexes[Sex]
end

-- To force "show skull"
local function IsSameFaction(GUID)
    local Unit = UnitTokenFromGUID(GUID)

    if not Unit then
        return nil
    end

    local PlayerFaction = UnitFactionGroup("player")
    local TargetFaction = UnitFactionGroup(Unit)

    if not PlayerFaction or not TargetFaction then
        return nil
    end

    return PlayerFaction == TargetFaction
end


local function GetLevelIcon(GUID, Level)
    if not Level then
        return nil
    end

    if IsSameFaction(GUID) == false
        and Level >= UnitLevel("player") + 10 then
        Level = -1
    end  

    local Path
    if Level == -1 then -- Skull level  
        Path = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"
    else
        Path = "Interface\\AddOns\\PugaWhoIsTalking\\Textures\\Levels\\" .. Level .. ".png"
    end
    return "|T" .. Path .. ":0|t"
end

-- Some races names are no as same as icon name. I.E. lightforgeddraenei => "lightforged"
-- This function fix this.
function NS.GetRaceAtlasName(Race)
    local Name = Race:lower()
    
    return (NS.RaceAtlasNames and NS.RaceAtlasNames[Name]) or Name
end

function NS.GetIcons(GUID)
    local _, Class, _, Race, SexNum, _, _, Level =
        GetPlayerInfoByGUID(GUID)
    local Sex, ClassIcon, RaceIcon, LevelIcon

    if SexNum then
        Sex = GetSex(SexNum)
    end

    if Class then
        ClassIcon = CreateAtlasMarkup("classicon-" .. Class:lower(),
            NS.ICON_SIZE, NS.ICON_SIZE)
    end

    if Race and Sex then
        Race = NS.GetRaceAtlasName(Race)
        RaceIcon = CreateAtlasMarkup("raceicon-" .. Race:lower() .. "-" .. Sex,
            NS.ICON_SIZE, NS.ICON_SIZE)
    end

    -- Try alternative methods to retrieve the level.
    if Level == nil and UnitTokenFromGUID then
        local Unit = UnitTokenFromGUID(GUID)

        if Unit then
            Level = UnitLevel(Unit)
        end
    end

    if Level then
        LevelIcon = GetLevelIcon(GUID, Level)
    end

    return RaceIcon, ClassIcon, LevelIcon
end
