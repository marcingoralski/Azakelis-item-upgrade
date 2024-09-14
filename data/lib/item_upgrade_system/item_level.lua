function Item:setItemLevel(level)
    level = ensureMaximum(ensureMinimum(level, ITEM_LEVEL_MINIMUM), ITEM_LEVEL_MAXIMUM)
    self:setCustomAttribute(CONST_CUSTOM_ATTRIBUTE_ITEM_LEVEL_NAME, level)
    self:onChangeItemlevel()
end

function Item:onChangeItemlevel() self:refreshItem() end

function Item:getItemLevel()
    if not self:getType():isUpgradable() then return nil end

    local level = self:getCustomAttribute(CONST_CUSTOM_ATTRIBUTE_ITEM_LEVEL_NAME)
    if level == nil then
        level = ITEM_LEVEL_MINIMUM
        self:setItemLevel(level)
    end

    return level
end