var DOA2_Text = {}

DOA2_Text.characterToCSV = function (character) {
    var header = [];
    var row = [];
    
    header.push('Version'); row.push("v4");
    
    header.push('Name'); row.push(character.name);
    header.push('Title'); row.push(character.title);
    header.push('Age'); row.push(character.age);
    header.push('Setting'); row.push(character.setting);
    header.push('Circle'); row.push(character.circle);
    header.push('Nature'); row.push(character.nature);

    for(var i = 0; i < DOA2.STATS.length; i++) { 
        var stat = DOA2.STATS[i]
        header.push(capitalizeFirstLetter(stat));
        row.push(character[stat]);
    }
    
    header.push('RangedWeaponPower'); row.push(character.rangedWeapon.power);
    header.push('RangedWeaponDamage'); row.push(character.rangedWeapon.damage);
    header.push('RangedWeaponOpFire'); row.push(character.rangedWeapon.opfire);
    header.push('RangedWeaponRangeMax'); row.push(character.rangedWeapon.rangeMax);
    header.push('RangedWeaponRangeMin'); row.push(character.rangedWeapon.rangeMin);
    header.push('RangedWeaponArea'); row.push(character.rangedWeapon.area);
    
    header.push('CardsCommon'); row.push(character.cards.common);
    header.push('CardsSecret'); row.push(character.cards.secret);
    header.push('CardsElite'); row.push(character.cards.elite);
    header.push('Henchmen'); row.push(character.cards.henchmen);

    header.push('BonusRanged'); row.push(character.bonuses.ranged.join(','));
    header.push('BonusMelee'); row.push(character.bonuses.melee.join(','));
    header.push('BonusMedical'); row.push(character.bonuses.medical);
    header.push('BonusStealth'); row.push(character.bonuses.stealth);
    header.push('BonusArmor'); row.push(character.bonuses.armor);
    header.push('BonusOther'); row.push(character.bonuses.other.join(','));

    header.push('NoGive'); row.push(character.cards.noGive ? 1 : 0);
    header.push('NoTrade'); row.push(character.cards.noTrade ? 1 : 0);
    header.push('NoLimit'); row.push(character.cards.noLimit ? 1 : 0);
    
    for(i = 0; i < character.specials.length; i++) {
        var special = character.specials[i];
        var num = i+1;

        header.push('Special' + num); row.push(special.description); 
        header.push('Special' + num + 'Survival'); row.push(special.value.survival);
        header.push('Special' + num + 'Melee'); row.push(special.value.melee);
        header.push('Special' + num + 'Ranged'); row.push(special.value.ranged);
        header.push('Special' + num + 'Adventure'); row.push(special.value.adventure);
    }
    
    var text = '';
    
    // Too noisy to output the header each time. 
    //text += header.join('|') + "\n";
    text += row.join('|');

    return text;
}

DOA2_Text.csvToCharacter = function(csv) {
    var lines = csv.split("\n");
    if (lines.length < 1 || lines[0] == "") {
        // nop
        return;
    }
    
    if (lines[0].match(/^Name\|/)) {
        lines.shift();
    }
    
    var values = lines[0].split('|');    
    var j = 0;
    
    var version = 3; 
    if (values[j].match(/^v[0-9]+/)) { 
        version = parseInt(values[j++].split('v')[1]);
    }
    
    character = new DOA2.Character();
    
    character.name = values[j++];
    character.title = values[j++];
    character.age = values[j++];
    character.setting = values[j++];
    character.circle = values[j++];
    character.nature = values[j++];

    for(var i = 0; i < DOA2.STATS.length; i++) { 
        var stat = DOA2.STATS[i]
        character[stat] = parseInt(values[j++]);
    }
    
    character.rangedWeapon.power = parseInt(values[j++]);
    character.rangedWeapon.damage = parseInt(values[j++]);
    if (version > 3) { 
        // bug
        character.rangedWeapon.opfire = parseInt(values[j++]);
    }
    character.rangedWeapon.rangeMax = parseInt(values[j++]);
    character.rangedWeapon.rangeMin = parseInt(values[j++]);
    character.rangedWeapon.area = values[j++];
    
    character.cards.common = parseInt(values[j++]);
    character.cards.secret = parseInt(values[j++]);
    character.cards.elite = parseInt(values[j++]);
    character.cards.henchmen = parseInt(values[j++]);
    
    character.bonuses.ranged = splitOnCommas(values[j++]);
    character.bonuses.melee = splitOnCommas(values[j++]);
    character.bonuses.medical = parseInt(values[j++]);
    character.bonuses.stealth = parseInt(values[j++]);
    character.bonuses.armor = parseInt(values[j++]);
    character.bonuses.other = splitOnCommas(values[j++]);

    if (version > 3) {
        // New feature
        character.cards.noGive = parseInt(values[j++]) == 1;
        character.cards.noTrade = parseInt(values[j++]) == 1;
        character.cards.noLimit = parseInt(values[j++]) == 1;
    }
    
    var specials = [];
    for(i = j; i < values.length; i += 5) {
        specials.push({
            description: values[i],
            value: {
              survival: parseInt(values[i+1]),
              melee: parseInt(values[i+2]),
              ranged: parseInt(values[i+3]),
              adventure: parseInt(values[i+4])
            }
        });
    }
    character.specials = specials;

    return character;
}

DOA2_Text.characterToBGGCode = function(character) {
    var code = "";
    
    code += "[b]" + character.name + "[/b]\n";
    if (character.title) {
        code += "[i]" + character.title + "[/i]\n";
    }
    code += character.age + " / " + character.setting + " / " + character.circle + " / " + character.nature + "\n\n";

    for(var i = 0; i < DOA2.STATS.length; i++) { 
        var stat = DOA2.STATS[i]
        code += character[stat] + " " + capitalizeFirstLetter(stat) + "\n";
    }
    code += "\n";
    
    if (character.rangedWeapon.area != DOA2.RANGED_AREA.NONE) {
        code += "[b]Ranged Attack[/b]\n";
        code += character.rangedWeapon.power + " Power\n";
        code += character.rangedWeapon.damage + " Damage\n";
        code += character.rangedWeapon.rangeMax + " RangeMax\n";
        code += character.rangedWeapon.rangeMin + " RangeMin\n";
        code += character.rangedWeapon.area + "\n\n";
    }
    
    if (character.cards.common) { 
        code += character.cards.common + " common cards\n";
    }
    if (character.cards.secret) {
        code += character.cards.secret + " secret cards\n";
    }
    if (character.cards.elite) {
        code += character.cards.elite + " elite cards\n";
    }
    if (character.cards.henchmen) {
        code += character.cards.henchmen + " henchmen\n";
    }
    
    if (character.bonuses.ranged.length) {
        code += "[b]Ranged bonuses:[/b] " + character.bonuses.ranged.join(', ') + "\n";
    }
    if (character.bonuses.melee.length) {
        code += "[b]Melee bonuses:[/b] " + character.bonuses.melee.join(', ') + "\n";
    }
    if (character.bonuses.medical) {
        code += "Medical\n";
    }
    if (character.bonuses.stealth) {
        code += "Stealth\n";
    }
    if (character.bonuses.armor) {
        code += "Armor\n";
    }
    if (character.bonuses.other.length) {
        code += "[b]Other bonuses:[/b] " + character.bonuses.other.join(', ') + "\n";
    }
    
    code += "\n";
    
    for(i = 0; i < character.specials.length; i++) {
        var special = character.specials[i];
        var values = [];

        if (special.value.survival) { 
            values.push("survival: " + special.value.survival);
        }
        if (special.value.melee) { 
            values.push("melee: " + special.value.melee);
        }
        if (special.value.ranged) { 
            values.push("ranged: " + special.value.ranged);
        }
        if (special.value.adventure) { 
            values.push("adventure: " + special.value.adventure);
        }

        code += special.description + " (" + values.join(", ") + ")\n\n";
    }

    var value = DOA2.calculateCharacterValue(character);
    code += "[b]Value Breakdown[/b]\n";
    code += "Survival: " + value.survival + "\n";
    code += "Melee: " + value.melee + "\n";
    code += "Ranged: " + value.ranged + "\n";
    code += "Adventure: " + value.adventure + "\n";
    code += "Total: " + value.total + "\n\n";
   
    return code;
}

