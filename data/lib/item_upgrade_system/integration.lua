function Player:onGainExperienceUpgradeSystem(source, exp, rawExp)
    local allEnchantments = self:getAllEnchantments()
    local expBonus = 0

    if #allEnchantments > 0 then
        for i = 1, #allEnchantments, 1 do
            if allEnchantments[i].trigger == ENCHANTMENT_TRIGGER.ON_KILL
            and allEnchantments[i].action == ENCHANTMENT_ACTIONS.BONUS_EXPERIENCE then
                expBonus = expBonus + allEnchantments[i].value
            end
        end
    end

    if expBonus > 0 then
        exp = math.floor(exp * (100 + expBonus) / 100)
    end

    return exp
end

function Player:addItemConditions(slot, item)
    local enchantments = CONDITIONS_GLOBAL[self:getName()][slot]
    local enchantmentList = item:getEnchantmentList()
    for i = 1, #enchantmentList, 1 do
        local condition = self:conditionForEnchantment(enchantmentList[i])
        enchantments[i].condition = condition
    end
    CONDITIONS_GLOBAL[self:getName()][slot] = enchantments
end

function Player:removeItemConditions(slot)
    local enchantments = CONDITIONS_GLOBAL[self:getName()][slot]
    for i = 1, getMaximumEnchantmentSlots(), 1 do
        if enchantments[i].condition ~= nil then
            local condition = enchantments[i].condition
            self:removeCondition(condition.type, condition.id, condition.subId)
            enchantments[i].condition = nil
        end
    end
    CONDITIONS_GLOBAL[self:getName()][slot] = enchantments    
end

function Player:onItemMovedUpgradeSystem(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
    if isInArray(PLAYER_EQUIPMENT_SLOTS, fromPosition.y) then
        self:removeItemConditions(fromPosition.y)
    end
    
    if isInArray(PLAYER_EQUIPMENT_SLOTS, toPosition.y) then
        self:removeItemConditions(toPosition.y)
        self:addItemConditions(toPosition.y, item)
    end
end

function Player:onLookUpgradeSystem(description)
    local totalItemLevel = 0
    for i = 1, #PLAYER_EQUIPMENT_SLOTS, 1 do
        local item = self:getSlotItem(PLAYER_EQUIPMENT_SLOTS[i])
        if item ~= nil then
            local itemLevel = item:getItemLevel()
            if itemLevel ~= nil then
                totalItemLevel = totalItemLevel + itemLevel
            end
        end
    end

    local totalItemLevelText = string.format(STRING_TOTAL_ITEM_LEVEL, totalItemLevel)
    description = string.format("%s\n[%s]", description, totalItemLevelText)
    return description
end

function Player:onLoginUpgradeSystem()
    self:registerEvent("UpgradeSystemKill")
    self:registerEvent("UpgradeSystemHealthChange")

    if CONDITIONS_GLOBAL[self:getName()] == nil then
        self:loadEnchantments()
    end
end

function Player:loadEnchantments()
    CONDITIONS_GLOBAL[self:getName()] = {counter = 0}
    local playerEquipmentSlots = CONDITIONS_GLOBAL[self:getName()]
    for i = 1, #PLAYER_EQUIPMENT_SLOTS, 1 do
        local item = self:getSlotItem(PLAYER_EQUIPMENT_SLOTS[i])
        local equipmentSlot = {}

        for j = 1, getMaximumEnchantmentSlots(), 1 do
            equipmentSlot[j] = {condition = nil}
        end

        if item ~= nil then
            local enchantmentList = item:getEnchantmentList()
            if #enchantmentList > 0 then
                for j = 1, #enchantmentList, 1 do
                   equipmentSlot[j].condition = self:conditionForEnchantment(enchantmentList[j])
                end
            end
        end
        playerEquipmentSlots[PLAYER_EQUIPMENT_SLOTS[i]] = equipmentSlot
    end
    CONDITIONS_GLOBAL[self:getName()] = playerEquipmentSlots
end

function Player:conditionForEnchantment(enchantmentListValue)
    if enchantmentListValue == nil then return nil end
    if enchantmentListValue.trigger ~= ENCHANTMENT_TRIGGER.ON_WEAR
    or enchantmentListValue.action ~= ENCHANTMENT_ACTIONS.CONDITION then
        return nil
    end

    local counter = CONDITIONS_GLOBAL[self:getName()].counter
    local condition = Condition(enchantmentListValue.actionParams.condition)
    condition:setParameter(enchantmentListValue.actionParams.param, enchantmentListValue.value)
    condition:setParameter(CONDITION_PARAM_TICKS, -1)
    local subId = counter + 1000
    condition:setParameter(CONDITION_PARAM_SUBID, subId)
    CONDITIONS_GLOBAL[self:getName()].counter = counter + 1

    self:addCondition(condition)

    return {type = condition:getType(), id = condition:getId(), subId = condition:getSubId()}
end

function Player:onLogoutUpgradeSystem()
    CONDITIONS_GLOBAL[self:getName()] = nil
end

function Creature:onTargetCombatUpgradeSystem(target)
    target:registerEvent("UpgradeSystemHealthChange")
end

function onHealthChangeUpgradeSystem(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if not creature or not attacker then return primaryDamage, primaryType, secondaryDamage, secondaryType end
    if primaryType == COMBAT_LIFEDRAIN or secondaryType == COMBAT_LIFEDRAIN then return primaryDamage, primaryType, secondaryDamage, secondaryType end
    if creature == attacker then return primaryDamage, primaryType, secondaryDamage, secondaryType end
    if origin == ORIGIN_CONDITION then return primaryDamage, primaryType, secondaryDamage, secondaryType end

    if attacker:isPlayer() then
        primaryDamage, primaryType, secondaryDamage, secondaryType = attacker:applyDamageBuff(primaryDamage, primaryType, secondaryDamage, secondaryType)
        attacker:applyStrikes(creature)
    end

    if creature:isPlayer() then
        primaryDamage, primaryType, secondaryDamage, secondaryType = creature:applyProtection(primaryDamage, primaryType, secondaryDamage, secondaryType)
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

function Player:applyStrikes(target)
    local allEnchantments = self:getAllEnchantments()
    local strikes = {}

    if #allEnchantments > 0 then
        for i = 1, #allEnchantments, 1 do
            if allEnchantments[i].trigger == ENCHANTMENT_TRIGGER.ON_ATTACK
            and allEnchantments[i].action == ENCHANTMENT_ACTIONS.STRIKE then
                table.insert(strikes, {combatDamage = allEnchantments[i].actionParams.combatDamage, damage = allEnchantments[i].value * -1, animation = allEnchantments[i].actionParams.animation})
            end
        end
    end

    if #strikes > 0 then
        local randomStrike = strikes[math.random(1, #strikes)]
        self:getPosition():sendDistanceEffect(target:getPosition(), randomStrike.animation)
        doTargetCombat(0, target, randomStrike.combatDamage, randomStrike.damage, randomStrike.damage)
    end
end

function Player:applyProtection(primaryDamage, primaryType, secondaryDamage, secondaryType)
    local allEnchantments = self:getAllEnchantments()

    local primaryProtection = 0
    local secondaryProtection = 0
    if #allEnchantments > 0 then
        for i = 1, #allEnchantments, 1 do
            if allEnchantments[i].trigger == ENCHANTMENT_TRIGGER.ON_HIT
            and allEnchantments[i].action == ENCHANTMENT_ACTIONS.PROTECTION then
                if primaryType == allEnchantments[i].actionParams.combatDamage then primaryProtection = primaryProtection + allEnchantments[i].value end
                if secondaryType == allEnchantments[i].actionParams.combatDamage then secondaryProtection = secondaryProtection + allEnchantments[i].value end
            end
        end
    end

    if primaryProtection > 0 then
        primaryDamage = math.floor(primaryDamage * (100 - primaryProtection) / 100)
    end

    if primaryProtection >= 100 then
        primaryDamage = 0
    end

    if secondaryProtection > 0 then
        secondaryDamage = math.floor(secondaryDamage * (100 - secondaryProtection) / 100)
    end

    if secondaryProtection >= 100 then
        secondaryDamage = 0
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

function Player:applyDamageBuff(primaryDamage, primaryType, secondaryDamage, secondaryType)
    local allEnchantments = self:getAllEnchantments()

    local primaryBuff = 0
    local secondaryBuff = 0
    if #allEnchantments > 0 then
        for i = 1, #allEnchantments, 1 do
            if allEnchantments[i].trigger == ENCHANTMENT_TRIGGER.ON_ATTACK
            and allEnchantments[i].action == ENCHANTMENT_ACTIONS.DAMAGE_BUFF then
                if primaryType == allEnchantments[i].actionParams.combatDamage then primaryBuff = primaryBuff + allEnchantments[i].value end
                if secondaryType == allEnchantments[i].actionParams.combatDamage then secondaryBuff = secondaryBuff + allEnchantments[i].value end
            end
        end
    end

    if primaryBuff > 0 then
        primaryDamage = math.floor(primaryDamage * (100 + primaryBuff) / 100)
    end


    if secondaryBuff > 0 then
        secondaryDamage = math.floor(secondaryDamage * (100 + secondaryBuff) / 100)
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

function onKillUpgradeSystem(player, target)
    if not player
    or not player:isPlayer()
    or not target
    or not target:isMonster() then
        return
    end

    local allEnchantments = player:getAllEnchantments()
    if #allEnchantments == 0 then return end

    for i = 1, #allEnchantments, 1 do
        if allEnchantments[i].trigger == ENCHANTMENT_TRIGGER.ON_KILL
        and allEnchantments[i].action == ENCHANTMENT_ACTIONS.REGEN_ON_KILL then
            allEnchantments[i].actionParams.func(player, allEnchantments[i].value)
        end
    end

end

function Player:getAllEnchantments()
    local allEnchantments = {}
    for i = 1, #PLAYER_EQUIPMENT_SLOTS, 1 do
        local item = self:getSlotItem(PLAYER_EQUIPMENT_SLOTS[i])
        if item ~= nil then
            local enchantmentList = item:getEnchantmentList()
            if #enchantmentList > 0 then tableConcat(allEnchantments, enchantmentList) end
        end
    end
    return allEnchantments
end

function refreshCondition(pid, equipmentSlot, enchantmentSlot, enchantmentParam)
    local player = Player(pid)
    local enchantment = CONDITIONS_GLOBAL[player:getName()][equipmentSlot][enchantmentSlot]
    local condition = player:conditionForEnchantment(enchantmentParam)
    if enchantment.condition ~= nil then
        player:removeCondition(enchantment.condition.type, enchantment.condition.id, enchantment.condition.subId)
    end
    enchantment.condition = condition
    CONDITIONS_GLOBAL[player:getName()][equipmentSlot][enchantmentSlot] = enchantment  
end

function itemUpgradeAdvancedQuest(itemObject, customFunctionParameters)
    if not itemObject:getType():isUpgradable() then return end

    local setItemLevelParameters = customFunctionParameters.setItemLevelParameters
    local rollItemTier = customFunctionParameters.rollTier
    local setItemTierParameters = customFunctionParameters.setTierParameters
    local setUpgradeLevel = customFunctionParameters.setUpgradeLevel
    local setEnchantmentsParameters = customFunctionParameters.setEnchantmentsParameters

    local itemLevelMinimum, itemLevelMaximum
    if setItemLevelParameters ~= nil then
        itemLevelMinimum = setItemLevelParameters.minimum
        itemLevelMaximum = setItemLevelParameters.maximum
    end

    if itemLevelMinimum ~= nil and itemLevelMaximum ~= nil then
        itemObject:setItemLevel(math.random(itemLevelMinimum, itemLevelMaximum))
    end

    if rollItemTier then itemObject:rollItemTier(true, nil) end

    local tierMinimum, tierMaximum
    if setItemTierParameters ~= nil then
        tierMinimum = setItemTierParameters.minimum
        tierMaximum = setItemTierParameters.maximum
    end

    if tierMinimum ~= nil and tierMaximum ~= nil then
        itemObject:setTier(math.random(tierMinimum, tierMaximum))
    end

    if setUpgradeLevel ~= nil and setUpgradeLevel > 0 then
        for i = 1, ensureMaximum(ensureMinimum(setUpgradeLevel, UPGRADE_LEVEL_MINIMUM), UPGRADE_LEVEL_MAXIMUM), 1 do
            itemObject:onUpgradeSuccess(true)
        end
    end

    if setEnchantmentsParameters ~= nil then
        for i = 1, #setEnchantmentsParameters, 1 do
            if i > itemObject:getMaximumEnchantmentSlots() then break end

            local enchantmentParameters = setEnchantmentsParameters[i]
            if enchantmentParameters.random ~= nil and enchantmentParameters.random then
                itemObject:rollEnchantment(true)
            elseif enchantmentParameters.enchantment ~= nil and enchantmentParameters.enchantmentValue ~= nil then
                itemObject:setEnchantmentSlot(enchantmentParameters.enchantment)
                local itemLevel = itemObject:getItemLevel()
                local minimum = ENCHANTMENTS.ENCHANTMENT_LIST[enchantmentParameters.enchantment].minimumValue(itemLevel)
                local maximum = ENCHANTMENTS.ENCHANTMENT_LIST[enchantmentParameters.enchantment].maximumValue(itemLevel)
                itemObject:setEnchantmentSlotValue(ensureMaximum(ensureMinimum(enchantmentParameters.enchantmentValue, minimum), maximum))
            end
        end
    end

    itemObject:refreshItem()
end