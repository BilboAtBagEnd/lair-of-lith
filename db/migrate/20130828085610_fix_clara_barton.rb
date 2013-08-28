class FixClaraBarton < ActiveRecord::Migration
  def change
    character = OfficialCharacter.find_by_name 'Clara Barton'
    character.official_specials.delete_all

    s = OfficialSpecial.new
    s.official_character_id = character.id
    s.description = "Free Action. Choose one: Heal 1 Health on an ally (not Clara) in Clara's space. One ally (not Clara) in Clara's space that is at max Health gains 1 current and max Health. An ally already above max Health cannot gain more from Clara."
    s.survival = 100
    s.ranged = s.melee = s.adventure = 0
    s.save!
  end
end
