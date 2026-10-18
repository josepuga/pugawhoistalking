local AddonName, NS = ...


--
-- Normalizes a player GUID.
-- (Some sources like Chat Events shows PLAYER instead Player)
--
function NS.NormalizeGUID(GUID)
    if GUID == nil then
        return nil
    end

    return GUID:gsub(
        "^PLAYER%-",
        "Player-"
    )
end