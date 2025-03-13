-- 触发器类型：状态 (Status)
-- 事件：UNIT_AURA, NAME_PLATE_UNIT_ADDED, NAME_PLATE_UNIT_REMOVED, UNIT_TARGET

local triggerFunc = function (event, ...)
    local targetGUID = UnitGUID("target")
    local enemies = {} -- 存储附近的敌人

    if not targetGUID then
        return false
    end

    local spellID = 12328  -- 横扫攻击 Buff ID
    local playerHasBuff = AuraUtil.FindAuraBySpellID(spellID, "player", "HELPFUL") ~= nil

    if not playerHasBuff then
        WeakAuras.ScanEvents("SWEEP_BUFF_LOST")  -- 触发 WeakAuras 事件，让其隐藏
        return false  -- 没有 Buff，隐藏光环
    end
    

    local count = 0
    local hasTarget = false

    for i = 1, 40 do
        local unit = "nameplate" .. i
        if UnitExists(unit) and not UnitIsDead(unit) and UnitCanAttack("player", unit) then
            local distance = WeakAuras.RangeCheck(unit)
            local guid = UnitGUID(unit)
            if distance and distance <= 8 then
                count = count + 1
                if guid == targetGUID then
                    hasTarget = true
                end

                if guid ~= targetGUID then
                    table.insert(enemies, guid)
                end
            end
        end
    end

    -- 存储数据给 Plater 用
    Plater.db.profile.wa_sweep_enemies = enemies

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
