function Item:rollItemTier(isSilent, protectionItem)
    if isSilent == nil then isSilent = false end

    if not self:getType():isUpgradable() then
        self:sendMessageAtItemPosition(STRING_ITEM_CANNOT_HAVE_TIER)
        self:sendAnimationAtItemPosition(ANIMATION_ITEM_CANNOT_HAVE_TIER)
        return false
    end

    local rolledOnlyFromPreviousTier = false
    local nextTier = nil
    if self:hasTier() then
        nextTier = TIERS[self:getTier() + 1]
        if nextTier ~= nil and nextTier.rolledOnlyFromPreviousTier ~= nil and nextTier.rolledOnlyFromPreviousTier then
            rolledOnlyFromPreviousTier = true
        end
        if self:getTier() == #TIERS then
            self:sendMessageAtItemPosition(STRING_ITEM_HAS_MAXIMUM_TIER)
            self:sendAnimationAtItemPosition(ANIMATION_ITEM_HAS_MAXIMUM_TIER)
            return false
        end
    end

    local tier = DEFAULT_TIER
    local roll = math.random(1, getSumOfTiersChance())
    for i = #TIERS, 1, -1 do
        if rolledOnlyFromPreviousTier and nextTier ~= nil and i == nextTier and roll <= nextTier.rollFromPreviousTierChance then
            tier = i
            break
        end

        if roll > (getSumOfTiersChance() - TIERS[i].chance) then
            tier = i
            break
        end
    end
    local currentTier = self:getTier()
    if protectionItem ~= nil and currentTier ~= nil and tier < currentTier then
        self:sendMessageAtItemPosition(string.format(STRING_TIER_PROTECTED_FROM_DOWNGRADE, TIERS[currentTier].name))
        self:sendAnimationAtItemPosition(ANIMATION_TIER_PROTECTED_FROM_DOWNGRADE)
        protectionItem:remove(1)
        return true
    end
    self:setTier(tier, isSilent)
    return true
end

function Item:onTierUpdate()
    self:checkEnchantmentOverflow()
    self:refreshItem()
end

function Item:setTier(tier, isSilent)
    tier = ensureMaximum(ensureMinimum(tier, 1), #TIERS)

    if not isSilent then
        self:sendMessageAtItemPosition(string.format(STRING_ON_SET_TIER, TIERS[tier].name))
        self:sendAnimationAtItemPosition(TIERS[tier].animation)
    end

    self:setCustomAttribute(CONST_CUSTOM_ATTRIBUTE_ITEM_TIER_NAME, tier)
    self:onTierUpdate()
end

function Item:getTier()
    if not self:hasTier() then return nil end

    return self:getCustomAttribute(CONST_CUSTOM_ATTRIBUTE_ITEM_TIER_NAME)
end

function Item:hasTier()
    return (self:getCustomAttribute(CONST_CUSTOM_ATTRIBUTE_ITEM_TIER_NAME) ~= nil)
end