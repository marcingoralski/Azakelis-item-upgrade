function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not target:isItem() then
        return false
    end

    local updatePlayerCondition = nil
    if isInArray(PLAYER_EQUIPMENT_SLOTS, toPosition.y) then
        updatePlayerCondition = {equipmentSlot = toPosition.y, pid = player:getId()}
    end

    if target:unsetAllEnchantmentSlots(updatePlayerCondition) then
        item:remove(1)
    end
    return true
end