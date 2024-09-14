function ItemType:isUpgradable()
    if self:isStackable() then return false end
    if self:isTransformingOnEquip() then return false end
    if self:hasCharges() then return false end
    if not self:isUpgradableWeapon() and not self:isUpgradableEquipment() then
        return false
    end
    return true
end

function ItemType:hasCharges() return (self:getCharges() > 0) end

function ItemType:isTransformingOnEquip()
    if self:getTransformEquipId() ~= 0 then return true end
    return false
end

function ItemType:isUpgradableWeapon()
    local weaponType = self:getWeaponType()
    if isInArray(EXCLUDED_WEAPONS, weaponType) then return false end
    return true
end

function ItemType:isUpgradableEquipment()
    local slot = self:getSlotPosition() - EXCLUDED_SLOTS
    if isInArray(UPGRADABLE_EQUIPMENT_SLOTS, slot) then return true end
    return false
end

function Item:rollUpgrade(protectionItem, isSilent)
    if isSilent == nil then isSilent = false end

    if not self:getType():isUpgradable() then
        if not isSilent then
            self:sendMessageAtItemPosition(STRING_ITEM_CANNOT_BE_UPGRADED)
            self:sendAnimationAtItemPosition(ANIMATION_ITEM_CANNOT_BE_UPGRADED)
        end
        return false
    end

    local level = self:getUpgradeLevel()
    if level == UPGRADE_LEVEL_MAXIMUM then
        if not isSilent then
            self:sendMessageAtItemPosition(STRING_MAXIMUM_ITEM_UPGRADE)
            self:sendAnimationAtItemPosition(ANIMATION_MAXIMUM_ITEM_UPGRADE)
        end
        return false
    end

    local roll = math.random(1, getMaximumUpgradeChance())
    if UPGRADE_LEVELS[level].upgrade_chance >= roll then
        self:onUpgradeSuccess(isSilent)
        return true
    end

    if level == UPGRADE_LEVEL_MINIMUM then
        if not isSilent then
            self:sendMessageAtItemPosition(string.format(STRING_UPGRADE_LEVEL_MINIMUM_PROTECTED, level))
            self:sendAnimationAtItemPosition(ANIMATION_UPGRADE_LEVEL_MINIMUM_PROTECTED)
        end
        return true
    end
    if protectionItem ~= nil then
        protectionItem:remove(1)
        if not isSilent then
            self:sendMessageAtItemPosition(string.format(STRING_UPGRADE_LEVEL_PROTECTED_FROM_DOWNGRADE, level))
            self:sendAnimationAtItemPosition(ANIMATION_UPGRADE_LEVEL_PROTECTED_FROM_DOWNGRADE)
        end
        return true
    end
    self:onUpgradeFailure(isSilent)
    return true
end

function Item:onUpgrade() self:refreshItem() end

function Item:onUpgradeSuccess(isSilent) self:increaseStatistics(isSilent) end

function Item:onUpgradeFailure(isSilent) self:decreaseStatistics(isSilent) end

function Item:increaseStatistics(isSilent) self:updateStatistics(false, isSilent) end

function Item:decreaseStatistics(isSilent) self:updateStatistics(true, isSilent) end

function Item:hasBaseAttribute(attribute)
    itemType = ItemType(self.itemid)
    if ITEM_ATTRIBUTE_MAP[attribute].has(itemType) then return true end
    return false
end

function Item:getBaseAttributeValue(attribute)
    itemType = ItemType(self.itemid)
    local value = ITEM_ATTRIBUTE_MAP[attribute].get(itemType)
    if value ~= nil then return value end
    return 0
end

function Item:updateAttribute(attribute, modifier)
    if not self:hasBaseAttribute(attribute) then return end

    local isDowngrade = false
    if modifier < 0 then isDowngrade = true end

    local difference = ensureMinimum(math.abs(getAttributeValuePerUpgrade(attribute) * modifier), 1)
    difference = math.floor(math.abs(difference)) * getModifier(isDowngrade)

    if not self:hasAttribute(attribute) then
        local baseValue = self:getBaseAttributeValue(attribute)
        local updatedValue = ensureMinimum(baseValue + difference, ATTRIBUTE_DOWNGRADE_MINIMUM)
        self:setAttribute(attribute, updatedValue)
        return
    end

    local currentValue = self:getAttribute(attribute)

    self:setAttribute(attribute, ensureMinimum(currentValue + difference, ATTRIBUTE_DOWNGRADE_MINIMUM))
end

function Item:updateStatistics(isDowngrade, isSilent)
    if isSilent == nil then isSilent = false end
    local modifier = getModifier(isDowngrade)

    local upgradeLevel = self:getUpgradeLevel()
    if isDowngrade then upgradeLevel = upgradeLevel - 1 end
    for i = 1, #AVAILABLE_ITEM_ATTRIBUTES, 1 do
        self:updateAttribute(AVAILABLE_ITEM_ATTRIBUTES[i], ensureMinimum(UPGRADE_LEVELS[upgradeLevel].modifier, 1) * modifier)
    end

    local itemLevel = self:getItemLevel()
    if itemLevel ~= nil then
        self:setItemLevel(itemLevel + ensureMinimum(LEVEL_PER_UPGRADE_BASE * UPGRADE_LEVELS[upgradeLevel].modifier, 1) * modifier)
    end

    self:setUpgradeLevel(isDowngrade, isSilent)
end

function Item:setUpgradeLevel(isDowngrade, isSilent)
    local modifier = getModifier(isDowngrade)
    local oldLevel = self:getUpgradeLevel()

    local newLevel = ensureMaximum(ensureMinimum(oldLevel + modifier, UPGRADE_LEVEL_MINIMUM), UPGRADE_LEVEL_MAXIMUM)
    self:setCustomAttribute(CONST_CUSTOM_ATTRIBUTE_UPGRADE_NAME, newLevel)
    self:onUpgrade()
    if isDowngrade then
        if not isSilent then
            self:sendMessageAtItemPosition(string.format(STRING_ITEM_DOWNGRADE, oldLevel, newLevel))
            self:sendAnimationAtItemPosition(ANIMATION_ITEM_DOWNGRADE)
        end
        return
    end
    if not isSilent then
        self:sendMessageAtItemPosition(string.format(STRING_ITEM_UPGRADE, oldLevel, newLevel))
        self:sendAnimationAtItemPosition(ANIMATION_ITEM_UPGRADE)
    end
end

function Item:getUpgradeLevel()
    if not self:getType():isUpgradable() then return nil end

    local level = self:getCustomAttribute(CONST_CUSTOM_ATTRIBUTE_UPGRADE_NAME)
    if level == nil then
        level = UPGRADE_LEVEL_MINIMUM
        self:setCustomAttribute(CONST_CUSTOM_ATTRIBUTE_UPGRADE_NAME, level)
    end

    return level
end