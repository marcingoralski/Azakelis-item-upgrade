function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not target:isItem() then
        return false
    end
    local protectionItem = player:getItemById(ITEM_PROTECTION_FROM_UPGRADE_LEVEL_DOWNGRADE, true)
    if target:rollUpgrade(protectionItem) then
        item:remove(1)
    end
    return true
end