function tryGetFromCache(name)
    if CACHE[name].loaded then return CACHE[name].value end
    return nil
end

function tryPutToCache(name, value)
    if CACHE[name].doCache then
        CACHE[name].value = value
        CACHE[name].loaded = true
    end
end

function ensureMaximum(testedValue, maximum)
    return math.min(testedValue, maximum)
end

function ensureMinimum(testedValue, minimum)
    return math.max(testedValue, minimum)
end

function getMaximumUpgradeChance()
    local cached = tryGetFromCache(MAXIMUM_UPGRADE_CHANCE)
    if cached ~= nil then return cached end

    local max = 0
    for i = #UPGRADE_LEVELS, 1, -1 do
        local checkedValue = UPGRADE_LEVELS[i].upgrade_chance
        if checkedValue > max then max = checkedValue end
    end

    tryPutToCache(MAXIMUM_UPGRADE_CHANCE, max)

    return max
end

function getSumOfTiersChance()
    local cached = tryGetFromCache(SUM_OF_TIERS_CHANCE)
    if cached ~= nil then return cached end

    local sum = 0
    for i = #TIERS, 1, -1 do sum = sum + TIERS[i].chance end

    tryPutToCache(SUM_OF_TIERS_CHANCE, sum)

    return sum
end

function getAttributeValuePerUpgrade(attribute)
    local value = ITEM_ATTRIBUTE_MAP[attribute].per()
    if value ~= nil then return value end
    return 0
end

function getModifier(isDowngrade)
    local modifier = 1
    if isDowngrade then modifier = -1 end
    return modifier
end

function calculateItemLevel(monsterHealth, monsterExperience)
    itemLevelFormula = math.floor(math.pow(monsterHealth + monsterExperience, 0.5))
    return ensureMaximum(ensureMinimum(itemLevelFormula, ITEM_LEVEL_MINIMUM), ITEM_LEVEL_MAXIMUM)
end

function Item:sendMessageAtItemPosition(message)
    if message == nil or message == "" then return end

    local itemPosition = self:getPosition()
    local spectators = Game.getSpectators(itemPosition, false, true, 3, 3)
    local player = nil
    for _, spectator in ipairs(spectators) do
        if spectator:isPlayer() then
            player = spectator
            break
        end
    end
    if player == nil then return end
    for _, spectator in ipairs(spectators) do
        player:say(message, TALKTYPE_MONSTER_SAY, false, spectator, itemPosition)
    end
end

function Item:sendAnimationAtItemPosition(animation)
    self:getPosition():sendMagicEffect(animation)
end

function Item:refreshItem()
    self:refreshItemName()
    self:refreshItemDescription()
end

function Item:refreshItemName()
    local baseName = self:getType():getName()

    local tierText = ""
    if self:hasTier() then
        local tier = self:getTier()
        tierText = string.format("%s ", TIERS[tier].name)
    end

    local upgrade = self:getUpgradeLevel()
    local upgradeText = ""
    if upgrade ~= nil and upgrade ~= 0 then
        upgradeText = string.format(" +%s", upgrade)
    end

    self:setAttribute(ITEM_ATTRIBUTE_NAME, string.format("%s%s%s", tierText, baseName, upgradeText))
end

function Item:refreshItemDescription()
    local baseDescription = self:getType():getDescription()
    local itemLevelText = ""
    local itemLevel = self:getItemLevel()
    if itemLevel ~= nil and itemLevel > 0 then
        itemLevelText = string.format(string.format("[%s]", STRING_ITEM_LEVEL), itemLevel)
    end

    local enchantmentSlotsText = ""
    if self:hasTier() then
        local tier = self:getTier()
        for i = 1, self:getMaximumEnchantmentSlots(), 1 do
            if self:getEnchantmentIdBySlot(i) == nil then
                enchantmentSlotsText = enchantmentSlotsText .. string.format("\n [%s]", STRING_EMPTY_SLOT)
            else
                local enchantmentName = self:getEnchantmentNameById(self:getEnchantmentIdBySlot(i))
                local slotValue = self:getEnchantmentValueBySlot(i)
                local enchantmentText = string.format(string.format("\n [%s]", enchantmentName), slotValue)
                enchantmentSlotsText = enchantmentSlotsText .. enchantmentText
            end
        end
    end

    if baseDescription ~= "" then baseDescription = baseDescription .. "\n" end

    self:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, string.format("%s%s%s", baseDescription, itemLevelText, enchantmentSlotsText))
end

function array_sub(t1, t2)
    local t = {}
    for i = 1, #t1 do t[t1[i]] = true; end
    for i = #t2, 1, -1 do if t[t2[i]] then table.remove(t2, i); end end
end

function getAdditionalLoot(playerLevel, itemLevel)
    if #LOOT == 0 then return nil end

    local fightFairness = math.floor(itemLevel / playerLevel)
    local random = math.random(1, #LOOT)
    local itemId = LOOT[random].id
    local maximumChance = LOOT[random].maximumChance

    local chance = ensureMaximum(math.floor(maximumChance * fightFairness), maximumChance)

    if chance == 0 then return nil end

    if math.random(1, 100) <= chance then return itemId end

    return nil
end

function getRandomItemLevel(monsterHealth, monsterExperience)
    local itemLevelMaximum = calculateItemLevel(monsterHealth, monsterExperience)
    local itemLevelMinimum = ensureMinimum(math.floor(itemLevelMaximum * 0.8), 1)
    return math.random(itemLevelMinimum, itemLevelMaximum)
end

function getMaximumEnchantmentSlots()
    local cached = tryGetFromCache(MAXIMUM_ENCHANTMENT_SLOTS)
    if cached ~= nil then return cached end

    local max = 0
    for i = #TIERS, 1, -1 do
        local checkedValue = TIERS[i].enchantmentSlots
        if checkedValue > max then max = checkedValue end
    end

    tryPutToCache(MAXIMUM_ENCHANTMENT_SLOTS, max)

    return max
end

function getEnchantmentsForTriggerType(triggerType)
    local cached = tryGetFromCache(ENCHANTMENTS_FOR_TRIGGER_TYPE)
    if cached ~= nil then return cached[triggerType] end

    local cache = {}
    for i = 1, #ENCHANTMENT_TRIGGER, 1 do
        cache[i] = {}
    end

    for i = 1, #ENCHANTMENTS.ENCHANTMENT_LIST, 1 do
        local triggerCache = cache[ENCHANTMENTS.ENCHANTMENT_LIST[i].trigger]
        triggerCache[#triggerCache + 1] = i
    end

    tryPutToCache(MAXIMUM_ENCHANTMENT_SLOTS, cache)

    return cached[triggerType]
end

function tableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end