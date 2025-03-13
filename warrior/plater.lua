-- 打开 Plater
-- 选择 Scripts（脚本）
-- 新建 Mod
-- 选择 "脚本类型" → "单位框架"
-- 触发条件："单位更新"（Unit Update）
-- 代码：

local changeColor = function (self, unitId, unitFrame, envTable)
    local guid = UnitGUID(unitId)
    local sweepEnemies = Plater.db.profile.wa_sweep_enemies or {}

    -- 检查该目标是否在 WA 存储的 8 码范围内的非主目标列表里
    if tContains(sweepEnemies, guid) then
        -- 变成蓝色
        unitFrame.healthBar:SetStatusBarColor(0, 0, 1)
    else
        -- 还原默认颜色
        Plater.RefreshNameplateColor(unitFrame)
    end
end

changeColor();