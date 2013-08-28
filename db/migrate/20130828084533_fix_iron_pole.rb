class FixIronPole < ActiveRecord::Migration
  def change
    character = OfficialCharacter.find_by_name 'The Iron Pole'
    character.official_specials.delete_all

    s1 = OfficialSpecial.new
    s1.official_character_id = character.id
    s1.description = 'Can move through Cavern walls at extra Move cost of 3.'
    s1.survival = 25
    s1.ranged = s1.melee = 0
    s1.adventure = 30
    s1.save!
    
    s2 = OfficialSpecial.new
    s2.official_character_id = character.id
    s2.description = 'Gains +2 on Strength adventures.'
    s2.survival = s2.ranged = s2.melee = 0
    s2.adventure = 10
    s2.save!
  end
end
