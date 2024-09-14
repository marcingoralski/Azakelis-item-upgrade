function Item:getMaximumEnchantmentSlots()
    if not self:hasTier() then return 0 end

    local tier = self:getTier()
    return TIERS[tier].enchantmentSlots
end

function Item:getEnchantmentValueBySlot(slot)
    return self:getCustomAttribute(ENCHANTMENT_SLOTS[slot].value)
end

function Item:getEnchantmentIdBySlot(slot)
    return self:getCustomAttribute(ENCHANTMENT_SLOTS[slot].name)
end

function Item:getEnchantmentNameById(id)
    return ENCHANTMENTS.ENCHANTMENT_LIST[id].name
end

function Item:getCurrentUsedEnchantmentSlots()
    if not self:hasTier() then return 0 end

    local used_enchantment_slots = 0
    for i = #ENCHANTMENT_SLOTS, 1, -1 do
        if self:getCustomAttribute(ENCHANTMENT_SLOTS[i].name) ~= nil then
            used_enchantment_slots = used_enchantment_slots + 1
        end
    end
    return used_enchantment_slots
end

function Item:hasEnchantments()
    if self:getCurrentUsedEnchantmentSlots() == 0 then return false end
    return true
end

function Item:hasFreeEnchantmentSlots()
    local max = self:getMaximumEnchantmentSlots()
    local next_slot = self:getNextEnchantmentPosition()
    if next_slot > max then return false end
    return true
end

function Item:getNextEnchantmentPosition()
    return (self:getCurrentUsedEnchantmentSlots() + 1)
end

function Item:onEnchantmentUpdate(slot, updatePlayerCondition)
    self:refreshItem()
    if updatePlayerCondition ~= nil then
        local enchantmentParam = self:getEnchantmentList()[slot]
        refreshCondition(updatePlayerCondition.pid, updatePlayerCondition.equipmentSlot, slot, enchantmentParam)
    end
end

function Item:setEnchantmentSlot(slot, enchantment)
    self:setCustomAttribute(ENCHANTMENT_SLOTS[slot].name, enchantment)
    self:onEnchantmentUpdate(slot)
end

function Item:setEnchantmentSlotValue(slot, enchantmentValue, updatePlayerCondition)
    self:setCustomAttribute(ENCHANTMENT_SLOTS[slot].value, enchantmentValue)
    self:onEnchantmentUpdate(slot, updatePlayerCondition)
end

function Item:addToNextEnchantmentSlot(enchantment, enchantmentValue, isSilent, updatePlayerCondition)
    if isSilent == nil then isSilent = false end

    if not self:hasFreeEnchantmentSlots() then
        if not isSilent then
            self:sendMessageAtItemPosition(STRING_ITEM_HAS_NO_SLOTS_LEFT)
            self:sendAnimationAtItemPosition(ANIMATION_ITEM_HAS_NO_SLOTS_LEFT)
        end
        return
    end

    local next_slot = self:getNextEnchantmentPosition()
    self:setEnchantmentSlot(next_slot, enchantment)
    self:setEnchantmentSlotValue(next_slot, enchantmentValue, updatePlayerCondition)
end

function Item:unsetAllEnchantmentSlots(updatePlayerCondition)
    if not self:getType():isUpgradable() then
        self:sendMessageAtItemPosition(STRING_CANNOT_UNSET_ALL_ENCHANTMENTS)
        self:sendAnimationAtItemPosition(ANIMATION_CANNOT_UNSET_ALL_ENCHANTMENTS)
        return false
    end

    if not self:hasEnchantments() then
        self:sendMessageAtItemPosition(STRING_ITEM_HAS_NO_ENCHANTMENT)
        self:sendAnimationAtItemPosition(ANIMATION_ITEM_HAS_NO_ENCHANTMENT)
        return false
    end

    for i = 1, self:getCurrentUsedEnchantmentSlots(), 1 do
        self:unsetLastEnchantmentSlot(true, updatePlayerCondition)
    end

    self:sendMessageAtItemPosition(STRING_ENCHANTMENTS_REMOVED)
    self:sendAnimationAtItemPosition(ANIMATION_ENCHANTMENTS_REMOVED)

    return true
end

function Item:unsetLastEnchantmentSlot(isSilent, updatePlayerCondition)
    if isSilent == nil then isSilent = false end

    if not self:getType():isUpgradable() then
        if not isSilent then
            self:sendMessageAtItemPosition(STRING_CANNOT_UNSET_LAST_ENCHANTMENT)
            self:sendAnimationAtItemPosition(ANIMATION_CANNOT_UNSET_LAST_ENCHANTMENT)
        end
        return false
    end

    if not self:hasEnchantments() then
        if not isSilent then
            self:sendMessageAtItemPosition(STRING_ITEM_HAS_NO_ENCHANTMENT)
            self:sendAnimationAtItemPosition(ANIMATION_ITEM_HAS_NO_ENCHANTMENT)
        end
        return false
    end

    local slot = self:getCurrentUsedEnchantmentSlots()
    self:removeCustomAttribute(ENCHANTMENT_SLOTS[slot].name)
    self:removeCustomAttribute(ENCHANTMENT_SLOTS[slot].value)
    self:onEnchantmentUpdate(slot, updatePlayerCondition)

    if not isSilent then
        self:sendMessageAtItemPosition(STRING_ENCHANTMENT_REMOVED)
        self:sendAnimationAtItemPosition(ANIMATION_ENCHANTMENT_REMOVED)
    end

    return true
end

function Item:rollEnchantment(isSilent, updatePlayerCondition)
    if isSilent == nil then isSilent = false end

    if not self:getType():isUpgradable() then
        if not isSilent then
            self:sendMessageAtItemPosition(STRING_CANNOT_ROLL_ENCHANTMENT)
            self:sendAnimationAtItemPosition(ANIMATION_CANNOT_ROLL_ENCHANTMENT)
        end
        return false
    end

    if not self:hasTier() then
        if not isSilent then
            self:sendMessageAtItemPosition(STRING_ITEM_NEEDS_TIER)
            self:sendAnimationAtItemPosition(ANIMATION_ITEM_NEEDS_TIER)
        end
        return false
    end

    if not self:hasFreeEnchantmentSlots() then
        if not isSilent then
            self:sendMessageAtItemPosition(STRING_ITEM_HAS_NO_ENCHANTMENT_SLOTS)
            self:sendAnimationAtItemPosition(ANIMATION_ITEM_HAS_NO_ENCHANTMENT_SLOTS)
        end
        return false
    end

    local enchantment = self:getRandomEnchantment()
    if enchantment == nil then
        if not isSilent then
            self:sendMessageAtItemPosition(STRING_ITEM_HAS_NO_ENCHANTMENTS_LEFT)
            self:sendAnimationAtItemPosition(ANIMATION_ITEM_HAS_NO_ENCHANTMENTS_LEFT)
        end
        return false
    end
    local enchantmentValue = self:getRandomEnchantmentValue(enchantment)

    self:addToNextEnchantmentSlot(enchantment, enchantmentValue, isSilent, updatePlayerCondition)
    if not isSilent then
        self:sendMessageAtItemPosition(STRING_ENCHANTMENT_ADDED)
        self:sendAnimationAtItemPosition(ANIMATION_ENCHANTMENT_ADDED)
    end
    return true
end

function Item:getAvailableEnchantments()
    local itemType = self:getType()
    local availableEnchantments = {}
    local tier = self:getTier()

    if itemType:isUpgradableEquipment() then
        local slot = itemType:getSlotPosition() - EXCLUDED_SLOTS
        for i = tier, 1, -1 do
            availableEnchantments = tableConcat(availableEnchantments, ENCHANTMENTS.AVAILABLE_FOR_SLOT[slot][i]) 
        end
    end

    if itemType:isUpgradableWeapon() then
        local weaponType = itemType:getWeaponType()
        for i = tier, 1, -1 do
            availableEnchantments = tableConcat(availableEnchantments, ENCHANTMENTS.AVAILABLE_FOR_WEAPON_TYPE[weaponType][i]) 
        end
    end

    local alreadyUsedEnchantments = {}
    for i = #ENCHANTMENT_SLOTS, 1, -1 do
        local enchantment = self:getCustomAttribute(ENCHANTMENT_SLOTS[i].name)
        if enchantment ~= nil then
            table.insert(alreadyUsedEnchantments, enchantment)
        end
    end

    array_sub(alreadyUsedEnchantments, availableEnchantments)

    return availableEnchantments
end

function Item:getRandomEnchantment()
    local availableEnchantments = self:getAvailableEnchantments()
    if #availableEnchantments == 0 then return nil end

    return availableEnchantments[math.random(1, #availableEnchantments)]
end

function Item:getRandomEnchantmentValue(enchantment)
    local level = self:getItemLevel()
    return math.random(ENCHANTMENTS.ENCHANTMENT_LIST[enchantment].minimumValue(level), ENCHANTMENTS.ENCHANTMENT_LIST[enchantment].maximumValue(level))
end

function Item:setRandomEnchantmentValueToSlot(slot, updatePlayerCondition)
    self:setEnchantmentSlotValue(slot, self:getRandomEnchantmentValue(self:getEnchantmentIdBySlot(slot)), updatePlayerCondition)
end

function Item:rerollEnchantmentValue(isCompleteReroll, updatePlayerCondition)
    if isCompleteReroll == nil then isCompleteReroll = false end

    if not self:getType():isUpgradable() then
        self:sendMessageAtItemPosition(
            STRING_ITEM_ENCHANTMENT_CANNOT_BE_REROLLED)
        self:sendAnimationAtItemPosition(
            ANIMATION_ITEM_ENCHANTMENT_CANNOT_BE_REROLLED)
        return false
    end

    if not self:hasTier() then
        self:sendMessageAtItemPosition(STRING_ITEM_NEEDS_TIER)
        self:sendAnimationAtItemPosition(ANIMATION_ITEM_NEEDS_TIER)
        return false
    end

    if self:getCurrentUsedEnchantmentSlots() == 0 then
        self:sendMessageAtItemPosition(STRING_ITEM_HAS_NO_ENCHANTMENT)
        self:sendAnimationAtItemPosition(ANIMATION_ITEM_HAS_NO_ENCHANTMENT)
        return false
    end

    if isCompleteReroll then
        for slot = 1, self:getCurrentUsedEnchantmentSlots(), 1 do
            self:setRandomEnchantmentValueToSlot(slot, updatePlayerCondition)
        end
        self:sendMessageAtItemPosition(STRING_ENCHANTMENTS_REROLLED)
        self:sendAnimationAtItemPosition(ANIMATION_ENCHANTMENTS_REROLLED)
        return true
    end

    local slot = self:getCurrentUsedEnchantmentSlots()
    self:setRandomEnchantmentValueToSlot(slot, updatePlayerCondition)
    self:sendMessageAtItemPosition(STRING_ENCHANTMENT_REROLLED)
    self:sendAnimationAtItemPosition(ANIMATION_ENCHANTMENT_REROLLED)
    return true
end

function Item:rerollEnchantmentValues(updatePlayerCondition) return self:rerollEnchantmentValue(true, updatePlayerCondition) end

function Item:checkEnchantmentOverflow()
    local max = self:getMaximumEnchantmentSlots()
    local used = self:getCurrentUsedEnchantmentSlots()
    local overflow = used - max
    if overflow > 0 then
        for i = 1, overflow, 1 do self:unsetLastEnchantmentSlot(true) end
    end
end

function Item:getEnchantmentList()
    local enchantmentList = {}
    if not self:hasEnchantments() then return enchantmentList end

    for i = 1, self:getCurrentUsedEnchantmentSlots(), 1 do
        local enchantmentId = self:getEnchantmentIdBySlot(i)
        local enchantmentValue = self:getEnchantmentValueBySlot(i)
        local enchantment = ENCHANTMENTS.ENCHANTMENT_LIST[enchantmentId]
        enchantmentList[i] = {id = enchantmentId, value = enchantmentValue, trigger = enchantment.trigger, action = enchantment.action, actionParams = enchantment.actionParams}
    end
    return enchantmentList
end
