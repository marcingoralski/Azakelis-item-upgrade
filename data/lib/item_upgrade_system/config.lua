-- ITEM LEVEL
CONST_CUSTOM_ATTRIBUTE_ITEM_LEVEL_NAME = "item_level"

ITEM_LEVEL_MINIMUM = 1
ITEM_LEVEL_MAXIMUM = 300

-- UPGRADE

CONST_CUSTOM_ATTRIBUTE_UPGRADE_NAME = "upgrade_level"

UPGRADE_LEVEL_MINIMUM = 0
UPGRADE_LEVEL_MAXIMUM = 10

ATTRIBUTE_DOWNGRADE_MINIMUM = 1

ATTACK_PER_UPGRADE_BASE = 1
DEFENSE_PER_UPGRADE_BASE = 0.5
ARMOR_PER_UPGRADE_BASE = 0.5
LEVEL_PER_UPGRADE_BASE = 2

CONST_UPGRADE_LEVEL_JUMP = 1

EXCLUDED_WEAPONS = {WEAPON_NONE, WEAPON_AMMO}

EXCLUDED_SLOTS = SLOTP_LEFT + SLOTP_RIGHT

UPGRADABLE_EQUIPMENT_SLOTS = {
    SLOTP_NECKLACE, SLOTP_HEAD, SLOTP_ARMOR, SLOTP_RING, SLOTP_LEGS, SLOTP_FEET
}

ITEM_PROTECTION_FROM_UPGRADE_LEVEL_DOWNGRADE = 2283

UPGRADE_LEVELS = {
    [0] = {upgrade_chance = 100, modifier = 5},
    [1] = {upgrade_chance = 90, modifier = 4},
    [2] = {upgrade_chance = 80, modifier = 3},
    [3] = {upgrade_chance = 70, modifier = 2},
    [4] = {upgrade_chance = 60, modifier = 1},
    [5] = {upgrade_chance = 50, modifier = 1},
    [6] = {upgrade_chance = 40, modifier = 2},
    [7] = {upgrade_chance = 30, modifier = 3},
    [8] = {upgrade_chance = 20, modifier = 4},
    [9] = {upgrade_chance = 10, modifier = 5}
}

AVAILABLE_ITEM_ATTRIBUTES = {
    [1] = ITEM_ATTRIBUTE_ATTACK,
    [2] = ITEM_ATTRIBUTE_DEFENSE,
    [3] = ITEM_ATTRIBUTE_ARMOR
}

ITEM_ATTRIBUTE_MAP = {
    [ITEM_ATTRIBUTE_ATTACK] = {
        has = function(itemType) return (itemType:getAttack() > 0) end,
        get = function(itemType) return itemType:getAttack() end,
        per = function() return ATTACK_PER_UPGRADE_BASE end
    },
    [ITEM_ATTRIBUTE_DEFENSE] = {
        has = function(itemType) return (itemType:getDefense() > 0) end,
        get = function(itemType) return itemType:getDefense() end,
        per = function() return DEFENSE_PER_UPGRADE_BASE end
    },
    [ITEM_ATTRIBUTE_ARMOR] = {
        has = function(itemType) return (itemType:getArmor() > 0) end,
        get = function(itemType) return itemType:getArmor() end,
        per = function() return ARMOR_PER_UPGRADE_BASE end
    }
}

-- TIER

CONST_CUSTOM_ATTRIBUTE_ITEM_TIER_NAME = "tier_level"

TIER_COMMON = 1
TIER_RARE = 2
TIER_EPIC = 3
TIER_LEGENDARY = 4
TIER_MYTHICAL = 5

DEFAULT_TIER = TIER_COMMON

ITEM_PROTECTION_FROM_TIER_DOWNGRADE = 2309

TIERS = {
    [TIER_COMMON] = {
        name = "common",
        enchantmentSlots = 1,
        chance = 80,
        animation = CONST_ME_MAGIC_GREEN
    },
    [TIER_RARE] = {
        name = "rare",
        enchantmentSlots = 2,
        chance = 15,
        animation = CONST_ME_GIFT_WRAPS
    },
    [TIER_EPIC] = {
        name = "epic",
        enchantmentSlots = 3,
        chance = 4,
        animation = CONST_ME_ICEATTACK
    },
    [TIER_LEGENDARY] = {
        name = "legendary",
        enchantmentSlots = 4,
        chance = 1,
        animation = CONST_ME_HOLYAREA
    },
    [TIER_MYTHICAL] = {
        name = "mythical",
        enchantmentSlots = 5,
        chance = 0,
        animation = CONST_ME_CRITICAL_DAMAGE,
        rolledOnlyFromPreviousTier = true,
        rollFromPreviousTierChance = 1
    }
}

-- ENCHANTMENT

CONST_CUSTOM_ATTRIBUTE_FIRST_ENCHANTMENT_SLOT = "first_enchantment_slot"
CONST_CUSTOM_ATTRIBUTE_SECOND_ENCHANTMENT_SLOT = "second_enchantment_slot"
CONST_CUSTOM_ATTRIBUTE_THIRD_ENCHANTMENT_SLOT = "third_enchantment_slot"
CONST_CUSTOM_ATTRIBUTE_FOURTH_ENCHANTMENT_SLOT = "fourth_enchantment_slot"
CONST_CUSTOM_ATTRIBUTE_FIFTH_ENCHANTMENT_SLOT = "fifth_enchantment_slot"

CONST_CUSTOM_ATTRIBUTE_FIRST_ENCHANTMENT_SLOT_VALUE = "first_enchantment_slot_value"
CONST_CUSTOM_ATTRIBUTE_SECOND_ENCHANTMENT_SLOT_VALUE = "second_enchantment_slot_value"
CONST_CUSTOM_ATTRIBUTE_THIRD_ENCHANTMENT_SLOT_VALUE = "third_enchantment_slot_value"
CONST_CUSTOM_ATTRIBUTE_FOURTH_ENCHANTMENT_SLOT_VALUE = "fourth_enchantment_slot_value"
CONST_CUSTOM_ATTRIBUTE_FIFTH_ENCHANTMENT_SLOT_VALUE = "fifth_enchantment_slot_value"

ENCHANTMENT_SLOTS = {
    [1] = {
        name = CONST_CUSTOM_ATTRIBUTE_FIRST_ENCHANTMENT_SLOT,
        value = CONST_CUSTOM_ATTRIBUTE_FIRST_ENCHANTMENT_SLOT_VALUE
    },
    [2] = {
        name = CONST_CUSTOM_ATTRIBUTE_SECOND_ENCHANTMENT_SLOT,
        value = CONST_CUSTOM_ATTRIBUTE_SECOND_ENCHANTMENT_SLOT_VALUE
    },
    [3] = {
        name = CONST_CUSTOM_ATTRIBUTE_THIRD_ENCHANTMENT_SLOT,
        value = CONST_CUSTOM_ATTRIBUTE_THIRD_ENCHANTMENT_SLOT_VALUE
    },
    [4] = {
        name = CONST_CUSTOM_ATTRIBUTE_FOURTH_ENCHANTMENT_SLOT,
        value = CONST_CUSTOM_ATTRIBUTE_FOURTH_ENCHANTMENT_SLOT_VALUE
    },
    [5] = {
        name = CONST_CUSTOM_ATTRIBUTE_FIFTH_ENCHANTMENT_SLOT,
        value = CONST_CUSTOM_ATTRIBUTE_FIFTH_ENCHANTMENT_SLOT_VALUE
    }
}

ENCHANTMENT_TYPES = {
    HEALTH = 1,
    MANA = 2,
    MAGIC_LEVEL = 3,
    SWORD = 4,
    AXE = 5,
    CLUB = 6,
    DISTANCE = 7,
    SHIELD = 8,
    DAMAGE_PHYSICAL = 9,
    DAMAGE_ENERGY = 10,
    DAMAGE_EARTH = 11,
    DAMAGE_FIRE = 12,
    DAMAGE_ICE = 13,
    DAMAGE_HOLY = 14,
    STRIKE_ENERGY = 15,
    STRIKE_EARTH = 16,
    STRIKE_FIRE = 17,
    STRIKE_ICE = 18,
    STRIKE_HOLY = 19,
    PROTECTION_PHYSICAL = 20,
    PROTECTION_ENERGY = 21,
    PROTECTION_EARTH = 22,
    PROTECTION_FIRE = 23,
    PROTECTION_ICE = 24,
    HEALTH_ON_KILL = 25,
    MANA_ON_KILL = 26,
    BONUS_EXPERIENCE = 27
}

ENCHANTMENT_ACTIONS = {
    CONDITION = 1,
    DAMAGE_BUFF = 2,
    STRIKE = 3,
    PROTECTION = 4,
    REGEN_ON_KILL = 5,
    BONUS_EXPERIENCE = 6
}

ENCHANTMENT_TRIGGER = {
    ON_ATTACK = 1,
    ON_HIT = 2,
    ON_KILL = 3,
    ON_WEAR = 4
}

ENCHANTMENT_EQUIPMENT_SLOTS = {
    SLOTP_NECKLACE,
    SLOTP_HEAD,
    SLOTP_LEFT,
    SLOTP_ARMOR,
    SLOTP_RIGHT,
    SLOTP_RING,
    SLOTP_LEGS,
    SLOTP_FEET
}

PLAYER_EQUIPMENT_SLOTS = {
    CONST_SLOT_NECKLACE,
    CONST_SLOT_HEAD,
    CONST_SLOT_LEFT,
    CONST_SLOT_ARMOR,
    CONST_SLOT_RIGHT,
    CONST_SLOT_RING,
    CONST_SLOT_LEGS,
    CONST_SLOT_FEET
}

ENCHANTMENTS = {
    AVAILABLE_FOR_SLOT = {
        [SLOTP_HEAD] = {
            [TIER_COMMON] = {
                ENCHANTMENT_TYPES.PROTECTION_ENERGY
            },
            [TIER_RARE] = {
                ENCHANTMENT_TYPES.PROTECTION_EARTH
            },
            [TIER_EPIC] = {
                ENCHANTMENT_TYPES.PROTECTION_FIRE
            },
            [TIER_LEGENDARY] = {
                ENCHANTMENT_TYPES.PROTECTION_ICE
            },
            [TIER_MYTHICAL] = {
                ENCHANTMENT_TYPES.PROTECTION_PHYSICAL, ENCHANTMENT_TYPES.HEALTH
            }
        },
        [SLOTP_NECKLACE] = {
            [TIER_COMMON] = {
                ENCHANTMENT_TYPES.SWORD, ENCHANTMENT_TYPES.AXE,
                ENCHANTMENT_TYPES.CLUB, ENCHANTMENT_TYPES.DISTANCE
            },
            [TIER_RARE] = {
                ENCHANTMENT_TYPES.MAGIC_LEVEL, ENCHANTMENT_TYPES.SHIELD
            },
            [TIER_EPIC] = {
                ENCHANTMENT_TYPES.MANA
            },
            [TIER_LEGENDARY] = {
                ENCHANTMENT_TYPES.HEALTH
            },
            [TIER_MYTHICAL] = {
                ENCHANTMENT_TYPES.BONUS_EXPERIENCE
            }
        },
        [SLOTP_ARMOR] = {
            [TIER_COMMON] = {
                ENCHANTMENT_TYPES.PROTECTION_ENERGY
            },
            [TIER_RARE] = {
                ENCHANTMENT_TYPES.PROTECTION_EARTH
            },
            [TIER_EPIC] = {
                ENCHANTMENT_TYPES.PROTECTION_FIRE
            },
            [TIER_LEGENDARY] = {
                ENCHANTMENT_TYPES.PROTECTION_ICE
            },
            [TIER_MYTHICAL] = {
                ENCHANTMENT_TYPES.PROTECTION_PHYSICAL, ENCHANTMENT_TYPES.HEALTH
            }
        },
        [SLOTP_LEGS] = {
            [TIER_COMMON] = {
                ENCHANTMENT_TYPES.PROTECTION_ENERGY
            },
            [TIER_RARE] = {
                ENCHANTMENT_TYPES.PROTECTION_EARTH
            },
            [TIER_EPIC] = {
                ENCHANTMENT_TYPES.PROTECTION_FIRE
            },
            [TIER_LEGENDARY] = {
                ENCHANTMENT_TYPES.PROTECTION_ICE
            },
            [TIER_MYTHICAL] = {
                ENCHANTMENT_TYPES.PROTECTION_PHYSICAL, ENCHANTMENT_TYPES.HEALTH
            }
        },
        [SLOTP_FEET] = {
            [TIER_COMMON] = {
                ENCHANTMENT_TYPES.PROTECTION_ENERGY
            },
            [TIER_RARE] = {
                ENCHANTMENT_TYPES.PROTECTION_EARTH
            },
            [TIER_EPIC] = {
                ENCHANTMENT_TYPES.PROTECTION_FIRE
            },
            [TIER_LEGENDARY] = {
                ENCHANTMENT_TYPES.PROTECTION_ICE
            },
            [TIER_MYTHICAL] = {
                ENCHANTMENT_TYPES.PROTECTION_PHYSICAL, ENCHANTMENT_TYPES.HEALTH
            }
        },
        [SLOTP_RING] = {
            [TIER_COMMON] = {
                ENCHANTMENT_TYPES.SWORD, ENCHANTMENT_TYPES.AXE,
                ENCHANTMENT_TYPES.CLUB, ENCHANTMENT_TYPES.DISTANCE
            },
            [TIER_RARE] = {
                ENCHANTMENT_TYPES.MAGIC_LEVEL, ENCHANTMENT_TYPES.SHIELD
            },
            [TIER_EPIC] = {
                ENCHANTMENT_TYPES.MANA
            },
            [TIER_LEGENDARY] = {
                ENCHANTMENT_TYPES.HEALTH
            },
            [TIER_MYTHICAL] = {
                ENCHANTMENT_TYPES.BONUS_EXPERIENCE
            }
        }
    },
    AVAILABLE_FOR_WEAPON_TYPE = {
        [WEAPON_SWORD] = {
            [TIER_COMMON] = {
                ENCHANTMENT_TYPES.STRIKE_ENERGY, ENCHANTMENT_TYPES.STRIKE_EARTH,
                ENCHANTMENT_TYPES.STRIKE_FIRE, ENCHANTMENT_TYPES.STRIKE_ICE
            },
            [TIER_RARE] = {
                ENCHANTMENT_TYPES.HEALTH_ON_KILL
            },
            [TIER_EPIC] = {
                ENCHANTMENT_TYPES.MANA_ON_KILL
            },
            [TIER_LEGENDARY] = {
                ENCHANTMENT_TYPES.SWORD
            },
            [TIER_MYTHICAL] = {
                ENCHANTMENT_TYPES.DAMAGE_PHYSICAL
            }
        },
        [WEAPON_CLUB] = {
            [TIER_COMMON] = {
                ENCHANTMENT_TYPES.STRIKE_ENERGY, ENCHANTMENT_TYPES.STRIKE_EARTH,
                ENCHANTMENT_TYPES.STRIKE_FIRE, ENCHANTMENT_TYPES.STRIKE_ICE
            },
            [TIER_RARE] = {
                ENCHANTMENT_TYPES.HEALTH_ON_KILL
            },
            [TIER_EPIC] = {
                ENCHANTMENT_TYPES.MANA_ON_KILL
            },
            [TIER_LEGENDARY] = {
                ENCHANTMENT_TYPES.CLUB
            },
            [TIER_MYTHICAL] = {
                ENCHANTMENT_TYPES.DAMAGE_PHYSICAL
            }
        },
        [WEAPON_AXE] = {
            [TIER_COMMON] = {
                ENCHANTMENT_TYPES.STRIKE_ENERGY, ENCHANTMENT_TYPES.STRIKE_EARTH,
                ENCHANTMENT_TYPES.STRIKE_FIRE, ENCHANTMENT_TYPES.STRIKE_ICE
            },
            [TIER_RARE] = {
                ENCHANTMENT_TYPES.HEALTH_ON_KILL
            },
            [TIER_EPIC] = {
                ENCHANTMENT_TYPES.MANA_ON_KILL
            },
            [TIER_LEGENDARY] = {
                ENCHANTMENT_TYPES.AXE
            },
            [TIER_MYTHICAL] = {
                ENCHANTMENT_TYPES.DAMAGE_PHYSICAL
            }
        },
        [WEAPON_SHIELD] = {
            [TIER_COMMON] = {
                ENCHANTMENT_TYPES.PROTECTION_ENERGY
            },
            [TIER_RARE] = {
                ENCHANTMENT_TYPES.PROTECTION_EARTH,
            },
            [TIER_EPIC] = {
                ENCHANTMENT_TYPES.PROTECTION_FIRE
            },
            [TIER_LEGENDARY] = {
                ENCHANTMENT_TYPES.PROTECTION_ICE
            },
            [TIER_MYTHICAL] = {
                ENCHANTMENT_TYPES.PROTECTION_PHYSICAL, ENCHANTMENT_TYPES.SHIELD
            }
        },
        [WEAPON_DISTANCE] = {
            [TIER_COMMON] = {
                ENCHANTMENT_TYPES.STRIKE_ENERGY, ENCHANTMENT_TYPES.STRIKE_EARTH,
                ENCHANTMENT_TYPES.STRIKE_FIRE, ENCHANTMENT_TYPES.STRIKE_ICE
            },
            [TIER_RARE] = {
                ENCHANTMENT_TYPES.HEALTH_ON_KILL
            },
            [TIER_EPIC] = {
                ENCHANTMENT_TYPES.MANA_ON_KILL
            },
            [TIER_LEGENDARY] = {
                ENCHANTMENT_TYPES.STRIKE_HOLY, ENCHANTMENT_TYPES.DAMAGE_HOLY
            },
            [TIER_MYTHICAL] = {
                ENCHANTMENT_TYPES.DAMAGE_PHYSICAL, ENCHANTMENT_TYPES.DISTANCE
            }
        },
        [WEAPON_WAND] = {
            [TIER_COMMON] = {
                ENCHANTMENT_TYPES.STRIKE_ENERGY, ENCHANTMENT_TYPES.STRIKE_EARTH,
                ENCHANTMENT_TYPES.STRIKE_FIRE, ENCHANTMENT_TYPES.STRIKE_ICE
            },
            [TIER_RARE] = {
                ENCHANTMENT_TYPES.HEALTH_ON_KILL
            },
            [TIER_EPIC] = {
                ENCHANTMENT_TYPES.MANA_ON_KILL
            },
            [TIER_LEGENDARY] = {
                ENCHANTMENT_TYPES.DAMAGE_ENERGY, ENCHANTMENT_TYPES.DAMAGE_EARTH,
                ENCHANTMENT_TYPES.DAMAGE_FIRE, ENCHANTMENT_TYPES.DAMAGE_ICE
            },
            [TIER_MYTHICAL] = {
                ENCHANTMENT_TYPES.MAGIC_LEVEL, ENCHANTMENT_TYPES.MANA
            }
        }
    },
    ENCHANTMENT_LIST = {
        [ENCHANTMENT_TYPES.HEALTH] = {
            name = "%s health",
            trigger = ENCHANTMENT_TRIGGER.ON_WEAR,
            action = ENCHANTMENT_ACTIONS.CONDITION,
            actionParams = {
                condition = CONDITION_ATTRIBUTES,
                param = CONDITION_PARAM_STAT_MAXHITPOINTS
            },
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel) return itemLevel end
        },
        [ENCHANTMENT_TYPES.MANA] = {
            name = "%s mana",
            trigger = ENCHANTMENT_TRIGGER.ON_WEAR,
            action = ENCHANTMENT_ACTIONS.CONDITION,
            actionParams = {
                condition = CONDITION_ATTRIBUTES,
                param = CONDITION_PARAM_STAT_MAXMANAPOINTS
            },
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return math.floor(itemLevel * 1.5)
            end
        },
        [ENCHANTMENT_TYPES.MAGIC_LEVEL] = {
            name = "%s magic level",
            trigger = ENCHANTMENT_TRIGGER.ON_WEAR,
            action = ENCHANTMENT_ACTIONS.CONDITION,
            actionParams = {
                condition = CONDITION_ATTRIBUTES,
                param = CONDITION_PARAM_STAT_MAGICPOINTS
            },
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 40), 1)
            end
        },
        [ENCHANTMENT_TYPES.SWORD] = {
            name = "%s sword fighting",
            trigger = ENCHANTMENT_TRIGGER.ON_WEAR,
            action = ENCHANTMENT_ACTIONS.CONDITION,
            actionParams = {
                condition = CONDITION_ATTRIBUTES,
                param = CONDITION_PARAM_SKILL_SWORD
            },
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 30), 1)
            end
        },
        [ENCHANTMENT_TYPES.AXE] = {
            name = "%s axe fighting",
            trigger = ENCHANTMENT_TRIGGER.ON_WEAR,
            action = ENCHANTMENT_ACTIONS.CONDITION,
            actionParams = {
                condition = CONDITION_ATTRIBUTES,
                param = CONDITION_PARAM_SKILL_AXE
            },
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 30), 1)
            end
        },
        [ENCHANTMENT_TYPES.CLUB] = {
            name = "%s club fighting",
            trigger = ENCHANTMENT_TRIGGER.ON_WEAR,
            action = ENCHANTMENT_ACTIONS.CONDITION,
            actionParams = {
                condition = CONDITION_ATTRIBUTES,
                param = CONDITION_PARAM_SKILL_CLUB
            },
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 30), 1)
            end
        },
        [ENCHANTMENT_TYPES.DISTANCE] = {
            name = "%s distance fighting",
            trigger = ENCHANTMENT_TRIGGER.ON_WEAR,
            action = ENCHANTMENT_ACTIONS.CONDITION,
            actionParams = {
                condition = CONDITION_ATTRIBUTES,
                param = CONDITION_PARAM_SKILL_DISTANCE
            },
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 30), 1)
            end
        },
        [ENCHANTMENT_TYPES.SHIELD] = {
            name = "%s shielding",
            trigger = ENCHANTMENT_TRIGGER.ON_WEAR,
            action = ENCHANTMENT_ACTIONS.CONDITION,
            actionParams = {
                condition = CONDITION_ATTRIBUTES,
                param = CONDITION_PARAM_SKILL_SHIELD
            },
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 30), 1)
            end
        },
        [ENCHANTMENT_TYPES.DAMAGE_PHYSICAL] = {
            name = "%s%% physical damage",
            trigger = ENCHANTMENT_TRIGGER.ON_ATTACK,
            action = ENCHANTMENT_ACTIONS.DAMAGE_BUFF,
            actionParams = {combatDamage = COMBAT_PHYSICALDAMAGE},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 15), 1)
            end
        },
        [ENCHANTMENT_TYPES.DAMAGE_ENERGY] = {
            name = "%s%% energy damage",
            trigger = ENCHANTMENT_TRIGGER.ON_ATTACK,
            action = ENCHANTMENT_ACTIONS.DAMAGE_BUFF,
            actionParams = {combatDamage = COMBAT_ENERGYDAMAGE},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 15), 1)
            end
        },
        [ENCHANTMENT_TYPES.DAMAGE_EARTH] = {
            name = "%s%% earth damage",
            trigger = ENCHANTMENT_TRIGGER.ON_ATTACK,
            action = ENCHANTMENT_ACTIONS.DAMAGE_BUFF,
            actionParams = {combatDamage = COMBAT_EARTHDAMAGE},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 15), 1)
            end
        },
        [ENCHANTMENT_TYPES.DAMAGE_FIRE] = {
            name = "%s%% fire damage",
            trigger = ENCHANTMENT_TRIGGER.ON_ATTACK,
            action = ENCHANTMENT_ACTIONS.DAMAGE_BUFF,
            actionParams = {combatDamage = COMBAT_FIREDAMAGE},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 15), 1)
            end
        },
        [ENCHANTMENT_TYPES.DAMAGE_ICE] = {
            name = "%s%% ice damage",
            trigger = ENCHANTMENT_TRIGGER.ON_ATTACK,
            action = ENCHANTMENT_ACTIONS.DAMAGE_BUFF,
            actionParams = {combatDamage = COMBAT_ICEDAMAGE},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 15), 1)
            end
        },
        [ENCHANTMENT_TYPES.DAMAGE_HOLY] = {
            name = "%s%% holy damage",
            trigger = ENCHANTMENT_TRIGGER.ON_ATTACK,
            action = ENCHANTMENT_ACTIONS.DAMAGE_BUFF,
            actionParams = {combatDamage = COMBAT_HOLYDAMAGE},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 15), 1)
            end
        },
        [ENCHANTMENT_TYPES.STRIKE_ENERGY] = {
            name = "%s energy strike",
            trigger = ENCHANTMENT_TRIGGER.ON_ATTACK,
            action = ENCHANTMENT_ACTIONS.STRIKE,
            actionParams = {combatDamage = COMBAT_ENERGYDAMAGE, animation = CONST_ANI_ENERGY},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 2), 1)
            end
        },
        [ENCHANTMENT_TYPES.STRIKE_EARTH] = {
            name = "%s earth strike",
            trigger = ENCHANTMENT_TRIGGER.ON_ATTACK,
            action = ENCHANTMENT_ACTIONS.STRIKE,
            actionParams = {combatDamage = COMBAT_EARTHDAMAGE, animation = CONST_ANI_SMALLEARTH},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 2), 1)
            end
        },
        [ENCHANTMENT_TYPES.STRIKE_FIRE] = {
            name = "%s fire strike",
            trigger = ENCHANTMENT_TRIGGER.ON_ATTACK,
            action = ENCHANTMENT_ACTIONS.STRIKE,
            actionParams = {combatDamage = COMBAT_FIREDAMAGE, animation = CONST_ANI_FIRE},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 2), 1)
            end
        },
        [ENCHANTMENT_TYPES.STRIKE_ICE] = {
            name = "%s ice strike",
            trigger = ENCHANTMENT_TRIGGER.ON_ATTACK,
            action = ENCHANTMENT_ACTIONS.STRIKE,
            actionParams = {combatDamage = COMBAT_ICEDAMAGE, animation = CONST_ANI_SMALLICE},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 2), 1)
            end
        },
        [ENCHANTMENT_TYPES.STRIKE_HOLY] = {
            name = "%s holy strike",
            trigger = ENCHANTMENT_TRIGGER.ON_ATTACK,
            action = ENCHANTMENT_ACTIONS.STRIKE,
            actionParams = {combatDamage = COMBAT_HOLYDAMAGE, animation = CONST_ANI_SMALLHOLY},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 2), 1)
            end
        },
        [ENCHANTMENT_TYPES.PROTECTION_PHYSICAL] = {
            name = "%s%% physical protection",
            trigger = ENCHANTMENT_TRIGGER.ON_HIT,
            action = ENCHANTMENT_ACTIONS.PROTECTION,
            actionParams = {combatDamage = COMBAT_PHYSICALDAMAGE},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 60), 1)
            end
        },
        [ENCHANTMENT_TYPES.PROTECTION_ENERGY] = {
            name = "%s%% energy protection",
            trigger = ENCHANTMENT_TRIGGER.ON_HIT,
            action = ENCHANTMENT_ACTIONS.PROTECTION,
            actionParams = {combatDamage = COMBAT_ENERGYDAMAGE},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 60), 1)
            end
        },
        [ENCHANTMENT_TYPES.PROTECTION_EARTH] = {
            name = "%s%% earth protection",
            trigger = ENCHANTMENT_TRIGGER.ON_HIT,
            action = ENCHANTMENT_ACTIONS.PROTECTION,
            actionParams = {combatDamage = COMBAT_EARTHDAMAGE},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 60), 1)
            end
        },
        [ENCHANTMENT_TYPES.PROTECTION_FIRE] = {
            name = "%s%% fire protection",
            trigger = ENCHANTMENT_TRIGGER.ON_HIT,
            action = ENCHANTMENT_ACTIONS.PROTECTION,
            actionParams = {combatDamage = COMBAT_FIREDAMAGE},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 60), 1)
            end
        },
        [ENCHANTMENT_TYPES.PROTECTION_ICE] = {
            name = "%s%% ice protection",
            trigger = ENCHANTMENT_TRIGGER.ON_HIT,
            action = ENCHANTMENT_ACTIONS.PROTECTION,
            actionParams = {combatDamage = COMBAT_ICEDAMAGE},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 60), 1)
            end
        },
        [ENCHANTMENT_TYPES.HEALTH_ON_KILL] = {
            name = "%s health on kill",
            trigger = ENCHANTMENT_TRIGGER.ON_KILL,
            action = ENCHANTMENT_ACTIONS.REGEN_ON_KILL,
            actionParams = {
                func = function(player, value)
                    player:addHealth(value)
                end
            },
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 2), 1)
            end
        },
        [ENCHANTMENT_TYPES.MANA_ON_KILL] = {
            name = "%s mana on kill",
            trigger = ENCHANTMENT_TRIGGER.ON_KILL,
            action = ENCHANTMENT_ACTIONS.REGEN_ON_KILL,
            actionParams = {
                func = function(player, value)
                    player:addMana(value)
                end
            },
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 3), 1)
            end
        },
        [ENCHANTMENT_TYPES.BONUS_EXPERIENCE] = {
            name = "%s%% bonus experience",
            trigger = ENCHANTMENT_TRIGGER.ON_KILL,
            action = ENCHANTMENT_ACTIONS.BONUS_EXPERIENCE,
            actionParams = {},
            minimumValue = function(itemLevel) return 1 end,
            maximumValue = function(itemLevel)
                return ensureMinimum(math.floor(itemLevel / 30), 1)
            end
        }
    }
}

CONDITIONS_GLOBAL = {}

-- LOOT

LOOT = {
    [1] = {id = 2284, maximumChance = 3}, -- ancient rune of upgrading
    [2] = {id = 2276, maximumChance = 3}, -- ancient rune of enchanting
    [3] = {id = 2272, maximumChance = 4}, -- ancient rune of rolling
    [4] = {id = 2296, maximumChance = 5}, -- ancient rune of total rolling
    [5] = {id = 2270, maximumChance = 4}, -- ancient rune of cleansing
    [6] = {id = 2298, maximumChance = 5}, -- ancient rune of total cleansing
    [7] = {id = 2312, maximumChance = 2}, -- ancient rune of tiering
    [8] = {id = 2309, maximumChance = 1}, -- ancient rune of tier protection
    [9] = {id = 2283, maximumChance = 1} -- ancient rune of upgrade protection
}

-- CACHE

SUM_OF_TIERS_CHANCE = 1
MAXIMUM_UPGRADE_CHANCE = 2
MAXIMUM_ENCHANTMENT_SLOTS = 3
ENCHANTMENTS_FOR_TRIGGER_TYPE = 4

CACHE = {
    [SUM_OF_TIERS_CHANCE] = {doCache = true, loaded = false, value = nil},
    [MAXIMUM_UPGRADE_CHANCE] = {doCache = true, loaded = false, value = nil},
    [MAXIMUM_ENCHANTMENT_SLOTS] = {doCache = true, loaded = false, value = nil},
    [ENCHANTMENTS_FOR_TRIGGER_TYPE] = {doCache = true, loaded = false, value = nil}
}

-- STRING

STRING_ITEM_DOWNGRADE = "Item downgraded from %s to %s"
STRING_ITEM_UPGRADE = "Item upgraded from %s to %s"
STRING_ITEM_CANNOT_BE_UPGRADED = "This item cannot be upgraded"
STRING_MAXIMUM_ITEM_UPGRADE = "Maximum item upgrade level achieved"
STRING_ITEM_CANNOT_HAVE_TIER = "This item cannot have a tier"
STRING_ON_SET_TIER = "Item has tier %s"
STRING_ITEM_HAS_NO_SLOTS_LEFT = "Item has no enchantment slots left"
STRING_CANNOT_UNSET_LAST_ENCHANTMENT = "Item cannot have its enchantment removed"
STRING_ITEM_HAS_NO_ENCHANTMENT = "Item does not have any enchantments"
STRING_CANNOT_ROLL_ENCHANTMENT = "Item cannot have enchantments"
STRING_ITEM_NEEDS_TIER = "Item needs to have tier first"
STRING_ITEM_HAS_NO_ENCHANTMENT_SLOTS = "Item has no enchantment slots left"
STRING_ITEM_ENCHANTMENT_CANNOT_BE_REROLLED = "You cannot reroll enchantments on this item"
STRING_ENCHANTMENTS_REMOVED = "Enchantments removed"
STRING_ENCHANTMENT_REMOVED = "Last enchantment removed"
STRING_ENCHANTMENTS_REROLLED = "All enchantments rerolled"
STRING_ENCHANTMENT_REROLLED = "Last enchantment rerolled"
STRING_ENCHANTMENT_ADDED = "Enchantment added"
STRING_CANNOT_UNSET_ALL_ENCHANTMENTS = "Item cannot have its enchantments removed"
STRING_ITEM_LEVEL = "%s item level"
STRING_EMPTY_SLOT = "empty slot"
STRING_ITEM_HAS_NO_ENCHANTMENTS_LEFT = "Item has no available enchantments left"
STRING_UPGRADE_LEVEL_MINIMUM_PROTECTED = "Item at upgrade level %s protected from downgrade"
STRING_ITEM_HAS_MAXIMUM_TIER = "Item has already maximum tier"
STRING_TIER_PROTECTED_FROM_DOWNGRADE = "Item tier %s protected from downgrade"
STRING_UPGRADE_LEVEL_PROTECTED_FROM_DOWNGRADE = "Item at upgrade level %s protected from downgrade"
STRING_TOTAL_ITEM_LEVEL = "%s total item level"

-- ANIMATION

ANIMATION_ITEM_DOWNGRADE = CONST_ME_MAGIC_RED
ANIMATION_ITEM_UPGRADE = CONST_ME_HEARTS
ANIMATION_ITEM_CANNOT_BE_UPGRADED = CONST_ME_POFF
ANIMATION_MAXIMUM_ITEM_UPGRADE = CONST_ME_POFF
ANIMATION_ITEM_CANNOT_HAVE_TIER = CONST_ME_POFF
ANIMATION_ITEM_HAS_NO_SLOTS_LEFT = CONST_ME_POFF
ANIMATION_CANNOT_UNSET_LAST_ENCHANTMENT = CONST_ME_POFF
ANIMATION_ITEM_HAS_NO_ENCHANTMENT = CONST_ME_POFF
ANIMATION_CANNOT_ROLL_ENCHANTMENT = CONS_ME_POFF
ANIMATION_ITEM_NEEDS_TIER = CONST_ME_POFF
ANIMATION_ITEM_HAS_NO_ENCHANTMENT_SLOTS = CONST_ME_POFF
ANIMATION_ITEM_ENCHANTMENT_CANNOT_BE_REROLLED = CONST_ME_POFF
ANIMATION_ENCHANTMENTS_REMOVED = CONST_ME_MAGIC_RED
ANIMATION_ENCHANTMENT_REMOVED = CONST_ME_MAGIC_RED
ANIMATION_ENCHANTMENTS_REROLLED = CONST_ME_CRAPS
ANIMATION_ENCHANTMENT_REROLLED = CONST_ME_CRAPS
ANIMATION_ENCHANTMENT_ADDED = CONST_ME_CRAPS
ANIMATION_CANNOT_UNSET_ALL_ENCHANTMENTS = CONST_ME_POFF
ANIMATION_ITEM_HAS_NO_ENCHANTMENTS_LEFT = CONST_ME_POFF
ANIMATION_UPGRADE_LEVEL_MINIMUM_PROTECTED = CONST_ME_MAGIC_BLUE
ANIMATION_ITEM_HAS_MAXIMUM_TIER = CONST_ME_POFF
ANIMATION_TIER_PROTECTED_FROM_DOWNGRADE = CONST_ME_MAGIC_BLUE
ANIMATION_UPGRADE_LEVEL_PROTECTED_FROM_DOWNGRADE = CONST_ME_MAGIC_BLUE