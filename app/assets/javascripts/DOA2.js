var DOA2 = {};

DOA2.AGES = ["Ancient", "Colonial", "Modern", "Future"];
DOA2.SETTINGS = { 
    Ancient: ["Chasms", "Epic Heroes", "Faer"],
    Colonial: ["Folktales", "Horizons", "Lands West"],
    Modern: ["Age of Crisis", "Strange Times", "Underground"],
    Future: ["AltSpace", "Forty Worlds", "Starmarch"]
};
DOA2.STATS = [
    "speed", "health", "wits", "melee", "power", "damage",
    "aim", "point", "throw", "react", "stealth", "armor", 
    "strength", "intellect", "honor", "respect" 
];
DOA2.CARD_TYPES = [ "common", "secret", "elite", "henchmen" ];
DOA2.RANGED_AREA = { 
    NONE: "-",
    AREA: "area",
    SINGLE: "single"
};
DOA2.VALUE_CATEGORIES = {
    NONE: "-",
    MELEE: "melee", 
    RANGED: "ranged", 
    ADVENTURE: "adventure", 
    SURVIVAL: "survival"
};
DOA2.BONUS_TYPES = [ "ranged", "melee", "medical", "stealth", "armor", "other" ];

// Default evaluation of any stat value. 
// Specific stats may have different valuations, in 
// which case they should use a different function.
DOA2.calculateGenericStatValue = function(stat) {
    switch(stat) {
    case 0:
        return 0;
    case 1:
        return 4;
    case 2:
        return 9;
    case 3:
        return 15;
    case 4:
        return 21;
    case 5:
        return 27;
    case 6:
        return 33;
    case 7:
        return 39;
    case 8:
        return 45;
    case 9:
        return 51;
    default:
        return 0;
    }
};

// Calculates the value of the specific stat "speed".
DOA2.calculateSpeedValue = function(speed) {
    switch(speed) {
    case 3: 
        return -20;
    case 4:
        return -5;
    case 5:
        return 5;
    case 6:
        return 15;
    case 7:
        return 25;
    case 8:
        return 40;
    case 9:
        return 55;
    default:
        return 0;
    }
};

// Calculates the value of the health of the character
// as a function of their health and their armor.
DOA2.calculateHealthValue = function(health, armor) {
    var healthRating = 0;
    if (health < 0) { 
        return 0;
    }
    else if (health < 10) {
        healthRating = health * 2;
    }
    else {
        healthRating = health + 9;
    }
    
    switch(armor) {
    case 0:
        return healthRating * 3.6;
    case 1:
        return healthRating * 5;
    case 2:
        return healthRating * 6.4;
    case 3:
        return healthRating * 8;
    case 4:
        return healthRating * 9.6;
    case 5:
        return healthRating * 11.4;
    case 6:
        return healthRating * 13.2;
    case 7:
        return healthRating * 15;
    case 8:
        return healthRating * 16.8;
    case 9:
        return healthRating * 18.6;
    default:
        return 0;        
    } 
};

// Mapping of Power, Damage to Value.
DOA2.PowerDamageValueTable = { 
    "0 0": 0, "1 0": 0, "2 0": 0, "3 0": 2, "4 0": 2, "5 0": 2, "6 0": 4, "7 0": 4, "8 0": 6, "9 0": 8,
    "0 1": 2, "1 1": 2, "2 1": 4, "3 1": 6, "4 1": 6, "5 1": 8, "6 1": 10, "7 1": 12, "8 1": 16, "9 1": 18,
    "0 2": 4, "1 2": 6, "2 2": 8, "3 2": 10, "4 2": 12, "5 2": 16, "6 2": 18, "7 2": 22, "8 2": 24, "9 2": 28,
    "0 3": 10, "1 3": 12, "2 3": 16, "3 3": 20, "4 3": 22, "5 3": 26, "6 3": 30, "7 3": 32, "8 3": 36, "9 3": 40,
    "0 4": 16, "1 4": 20, "2 4": 24, "3 4": 28, "4 4": 32, "5 4": 36, "6 4": 40, "7 4": 44, "8 4": 48, "9 4": 52,
    "0 5": 22, "1 5": 26, "2 5": 32, "3 5": 36, "4 5": 42, "5 5": 46, "6 5": 52, "7 5": 56, "8 5": 60, "9 5": 64,
    "0 6": 28, "1 6": 34, "2 6": 40, "3 6": 46, "4 6": 52, "5 6": 56, "6 6": 62, "7 6": 66, "8 6": 72, "9 6": 74,
    "0 7": 34, "1 7": 40, "2 7": 48, "3 7": 54, "4 7": 62, "5 7": 68, "6 7": 72, "7 7": 78, "8 7": 82, "9 7": 86,
    "0 8": 40, "1 8": 48, "2 8": 56, "3 8": 64, "4 8": 70, "5 8": 78, "6 8": 84, "7 8": 90, "8 8": 94, "9 8": 98,
    "0 9": 46, "1 9": 54, "2 9": 64, "3 9": 72, "4 9": 80, "5 9": 88, "6 9": 94, "7 9": 100, "8 9": 106, "9 9": 110
};

// Calculate the value of the type of ranged damage an 
// attack (usually from a weapon, occasionally from special characters)
// can do.
//
// The last parameter, "area", is either "single" or "area".
DOA2.calculateRangedDamageValue = function(power, damage, opfire, rangeMax, rangeMin, area) {
    var value = DOA2.PowerDamageValueTable[power + " " + damage];

    if (area == DOA2.RANGED_AREA.AREA) { 
        value = value * 1.5;
    }
    else if (area == DOA2.RANGED_AREA.NONE) {
        return 0;
    }

    switch(opfire) { 
    case 1:
        // nop
        break;
    case 2:
        value = value * 1.5;
        break;
    case 3:
        value = value * 1.8;
        break;
    case 4:
        value = value * 2;
        break;
    case 5:
        value = value * 2.2;
        break;
    default:
        value = value * 2.4;
    };
    if (rangeMax < 0) { 
        // nop
    } else if (rangeMax < 6) { 
        value += rangeMax;
    } else if (rangeMax < 12) {
        value += 6 + (rangeMax - 6) / 2;
    } else {
        value += 9 + (rangeMax - 12) / 4;
    }

    return value;
};

// Calculate the value of a melee attack, either of a character or a weapon.
DOA2.calculateMeleeDamageValue = function(power, damage, melee) {
    var value = DOA2.PowerDamageValueTable[power + " " + damage];

    switch(melee) {
    case 0:
        value = value * 0.25;
        break;
    case 1:
        value = value * 0.5;
        break;
    case 2:
        value = value * 0.75;
        break;
    case 3:
        value = value * 1;
        break;
    case 4:
        value = value * 1.3;
        break;
    case 5:
        value = value * 1.6;
        break;
    case 6:
        value = value * 2;
        break;
    case 7:
        value = value * 2.5;
        break;
    case 8:
        value = value * 3.1;
        break;
    case 9:
        value = value * 3.8;
        break;
    }

    return value;
};

// Calculate the value of a character based on their starting cards/henchmen for 
// a specific category (melee, ranged, or adventure). 
DOA2.calculateCardValue = function(numCommon, numSecret, numElite, numHenchmen, category) {
    var value = 0;

    switch(category) {
    case DOA2.VALUE_CATEGORIES.MELEE:
        value += numCommon * 6;
        value += numSecret * 3;
        value += numElite * 10;
        value += numHenchmen * 21;
        break;
    case DOA2.VALUE_CATEGORIES.RANGED:
        value += numCommon * 12;
        value += numSecret * 3;
        value += numElite * 15;
        value += numHenchmen * 21;
        break;
    case DOA2.VALUE_CATEGORIES.ADVENTURE:
        value += numCommon * 6;
        value += numSecret * 12;
        value += numElite * 15;
        value += numHenchmen * 6;
        break;
    }

    return value;
};

DOA2.calculateCardBonusValue = function(noGive, noTrade, noLimit, category) {
    var value = 0;

    switch(category) {
    case DOA2.VALUE_CATEGORIES.SURVIVAL: 
        if (noTrade) { 
            value -= 5;
        }
        break;
    case DOA2.VALUE_CATEGORIES.MELEE:
        if (noTrade) { 
            value -= 5;
        }
        break;
    case DOA2.VALUE_CATEGORIES.RANGED:
        if (noTrade) { 
            value -= 10;
        }
        break;
    case DOA2.VALUE_CATEGORIES.ADVENTURE:
        if (noTrade) { 
            value -= 10;
        }
        if (noGive) { 
            value -= 15;
        }
        if (noLimit) { 
            value += 15;
        }
        break;
    }

    return value;
};

// Creates a default DOA2 character with some fields filled out.
DOA2.Character = function() {
    this.name = "",
    this.title = "",
    this.age = "Ancient", 
    this.setting = "Chasms",
    this.circle = "",
    this.nature = "",
    this.speed = 0;
    this.health = 0;
    this.wits = 0; 
    this.melee = 0;
    this.power = 0;
    this.damage = 0;
    this.aim = 0;
    this.point = 0;
    this['throw'] = 0;
    this.react = 0;
    this.stealth = 0;
    this.armor = 0;
    this.strength = 0;
    this.intellect = 0;
    this.honor = 0;
    this.respect = 0;
    this.rangedWeapon = {
        power: 0,
        damage: 0,
        opfire: 0,
        rangeMax: 0,
        rangeMin: 0,
        area: "-",
    };
    this.cards = { 
        common: 0,
        secret: 0,
        elite: 0,
        henchmen: 0, 
        noTrade: false, 
        noGive: false,
        noLimit: false,
    };
    this.bonuses = {
        ranged: [],
        melee: [],
        medical: 0,
        stealth: 0,
        armor: 0,
        other: [],
    };
    this.specials = [];
};
DOA2.Character.prototype.hasRangedWeapon = function() {
    return this.rangedWeapon.area == "area" || this.rangedWeapon.area == "single";
}

DOA2.calculateSpecialValueFor = function(specials, category) {
    var value = 0;
    for(var i = 0; i < specials.length; i++) {
        value += specials[i].value[category];
    }
    return value;
};

// Calculate the value of a Character object.
DOA2.calculateCharacterValue = function(character) {
    var value = 0;

    // Survival
    var survivalValue = 0;
    survivalValue += DOA2.calculateSpeedValue(character.speed);
    survivalValue += DOA2.calculateGenericStatValue(character.stealth);
    survivalValue += DOA2.calculateGenericStatValue(character.react);
    survivalValue += DOA2.calculateHealthValue(character.health, character.armor);
    survivalValue += 7 * (character.bonuses.medical + character.bonuses.stealth + character.bonuses.armor);
    survivalValue += DOA2.calculateSpecialValueFor(character.specials, DOA2.VALUE_CATEGORIES.SURVIVAL);
    survivalValue += DOA2.calculateCardValue(character.cards.common, 
                                             character.cards.secret,
                                             character.cards.elite,
                                             character.cards.henchmen,
                                             DOA2.VALUE_CATEGORIES.SURVIVAL);
    survivalValue += DOA2.calculateCardBonusValue(character.cards.noGive, 
                                                  character.cards.noTrade,
                                                  character.cards.noLimit, 
                                                  DOA2.VALUE_CATEGORIES.SURVIVAL);

    // Ranged
    var rangedValue = 0;
    rangedValue += DOA2.calculateGenericStatValue(character.aim);
    rangedValue += DOA2.calculateGenericStatValue(character.point);
    rangedValue += DOA2.calculateGenericStatValue(character['throw']);
    rangedValue += DOA2.calculateRangedDamageValue(
                        character.rangedWeapon.power,
                        character.rangedWeapon.damage,
                        character.rangedWeapon.opfire,
                        character.rangedWeapon.rangeMax,
                        character.rangedWeapon.rangeMin,
                        character.rangedWeapon.area);
    rangedValue += 7 * character.bonuses.ranged.length;
    rangedValue += DOA2.calculateSpecialValueFor(character.specials, DOA2.VALUE_CATEGORIES.RANGED);
    rangedValue += DOA2.calculateCardValue(character.cards.common, 
                                           character.cards.secret,
                                           character.cards.elite,
                                           character.cards.henchmen,
                                           DOA2.VALUE_CATEGORIES.RANGED);
    rangedValue += DOA2.calculateCardBonusValue(character.cards.noGive, 
                                                character.cards.noTrade,
                                                character.cards.noLimit, 
                                                DOA2.VALUE_CATEGORIES.RANGED);

    // Melee
    var meleeValue = 0;
    meleeValue += DOA2.calculateGenericStatValue(character.wits);
    meleeValue += character.melee * character.speed;
    meleeValue += DOA2.calculateMeleeDamageValue(character.power, character.damage, character.melee) * 1.5;
    meleeValue += 7 * character.bonuses.melee.length;
    meleeValue += DOA2.calculateCardValue(character.cards.common, 
                                          character.cards.secret,
                                          character.cards.elite,
                                          character.cards.henchmen,
                                          DOA2.VALUE_CATEGORIES.MELEE);
    meleeValue += DOA2.calculateSpecialValueFor(character.specials, DOA2.VALUE_CATEGORIES.MELEE);
    meleeValue += DOA2.calculateCardBonusValue(character.cards.noGive, 
                                               character.cards.noTrade,
                                               character.cards.noLimit, 
                                               DOA2.VALUE_CATEGORIES.MELEE);

    // Adventure
    var adventureValue = 0;
    adventureValue += DOA2.calculateSpeedValue(character.speed);
    adventureValue += DOA2.calculateGenericStatValue(character.strength);
    adventureValue += DOA2.calculateGenericStatValue(character.intellect);
    if (character.strength < 1 || character.intellect < 1) {
        adventureValue -= 20;
    }
    adventureValue += DOA2.calculateGenericStatValue(character.honor);
    adventureValue += DOA2.calculateGenericStatValue(character.respect);
    adventureValue += 7 * character.bonuses.other.length;
    adventureValue += DOA2.calculateCardValue(character.cards.common, 
                                              character.cards.secret,
                                              character.cards.elite,
                                              character.cards.henchmen,
                                              DOA2.VALUE_CATEGORIES.ADVENTURE);
    adventureValue += DOA2.calculateSpecialValueFor(character.specials, DOA2.VALUE_CATEGORIES.ADVENTURE);
    adventureValue += DOA2.calculateCardBonusValue(character.cards.noGive, 
                                                   character.cards.noTrade,
                                                   character.cards.noLimit, 
                                                   DOA2.VALUE_CATEGORIES.ADVENTURE);

    value = survivalValue + rangedValue + meleeValue + adventureValue;

    return {
        total: value,
        survival: survivalValue,
        ranged: rangedValue,
        melee: meleeValue,
        adventure: adventureValue
    };
};

