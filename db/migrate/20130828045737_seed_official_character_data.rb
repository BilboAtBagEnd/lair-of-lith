require 'yaml'
require 'DOA2'

class SeedOfficialCharacterData < ActiveRecord::Migration
  def change
    file = 'spreadsheets/official_characters.csv.edited.cleaned.yml'

    characters = YAML.load_file(file)

    characters.each do |cdata|
      data = cdata[:data]
      csv = cdata[:csv]

      doa2_character = DOA2::Character.new(csv: csv)

      puts "Processing #{data[:name]}"

      oc = OfficialCharacter.new
      oc.name = data[:name]
      oc.profession = data[:profession]
      oc.age = data[:age]
      oc.number = data[:number]
      oc.set = data[:set]
      oc.setting = data[:setting]
      oc.circle = data[:circle]
      oc.nature = data[:nature]
      oc.speed = data[:speed]
      oc.health = data[:health]
      oc.wits = data[:wits]
      oc.melee = data[:melee]
      oc.power = data[:power]
      oc.damage = data[:damage]
      oc.aim = data[:aim]
      oc.point = data[:point]
      oc.throw = data[:throw]
      oc.react = data[:react]
      oc.stealth = data[:stealth]
      oc.armor = data[:armor]
      oc.strength = data[:strength]
      oc.intellect = data[:intellect]
      oc.honor = data[:honor]
      oc.respect = data[:respect]
      oc.range_opfire = data[:range_opfire]
      oc.range_power = data[:range_power]
      oc.range_max = data[:range_max]
      oc.range_min = data[:range_min]
      oc.area = data[:area]
      oc.range_damage = data[:range_damage]
      oc.common_cards = data[:common_cards]
      oc.secret_cards = data[:secret_cards]
      oc.elite_cards = data[:elite_cards]
      oc.henchmen = data[:henchmen]
      oc.standard_abilities = data[:standard_abilities]

      oc.save!

      doa2_character.specials.each do |special|
        puts "-> Processing #{special.description}"

        os = OfficialSpecial.new
        os.OfficialCharacter_id = oc.id
        os.description = special.description
        os.survival = special.survival
        os.adventure = special.adventure
        os.melee = special.melee
        os.ranged = special.ranged
        os.save!
      end
    end
  end
end
