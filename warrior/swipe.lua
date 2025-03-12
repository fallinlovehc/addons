local triggerFunc = function (event, ...)
    local targetGUID = UnitGUID("target")

    if not targetGUID then
        return false
    end

    local count = 0
    local hasTarget = false

    for i = 1, 40 do
        local unit = "nameplate" .. i
        if UnitExists(unit) and not UnitIsDead(unit) and UnitCanAttack("player", unit) then
            local distance = WeakAuras.RangeCheck(unit)
            if distance and distance <= 8 then
                count = count + 1
                if UnitGUID(unit) == targetGUID then
                    hasTarget = true
                end
            end
        end
    end

    -- 只有一个目标（主目标）
    if hasTarget and count == 1 then
        return true, "single"
    end

    -- 至少两个目标（主目标 + 其他怪物）
    if hasTarget and count >= 2 then
        return true, "multiple"
    end

    return false
end

triggerFunc()
