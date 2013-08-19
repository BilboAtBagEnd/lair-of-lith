# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :character_version do
    character_id 1
    version 1
    csv "v4|Eleanor Bludsturm|Mistress of Blood|Ancient|Faer|Villain|Woman|7|6|8|4|3|2|2|2|2|8|8|2|7|7|2|2|0|0|0|0|0|-|0|0|0|0|||0|0|0||0|0|0|Can fly.|10|0|0|25|Enthrall: Mental ability. Free action: check luck; if 9, choose target enemy character within 6 aura. As long as Eleanor and target are in 6 aura of contact, the target is on Eleanor's side.|10|10|10|10|Fury: At the beginning of the game, randomly choose another allied character. If that character is killed or imprisoned, deal 1 damage to Eleanor and she becomes a hunter for the character responsible with speed 12, melee 7, power 4.|-10|10|0|-10"
  end
end
