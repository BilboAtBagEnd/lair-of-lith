class CreateOfficialCharacters < ActiveRecord::Migration
  def change
    create_table :official_characters do |t|
      t.string :name
      t.string :profession
      t.string :age
      t.integer :number
      t.string :set
      t.string :setting
      t.string :circle
      t.string :nature
      t.integer :speed
      t.integer :health
      t.integer :wits
      t.integer :melee
      t.integer :power
      t.integer :damage
      t.integer :aim
      t.integer :point
      t.integer :throw
      t.integer :react
      t.integer :stealth
      t.integer :armor
      t.integer :strength
      t.integer :intellect
      t.integer :honor
      t.integer :respect
      t.integer :range_opfire
      t.integer :range_power
      t.integer :range_max
      t.integer :range_min
      t.string :area
      t.integer :range_damage
      t.integer :common_cards
      t.integer :secret_cards
      t.integer :elite_cards
      t.integer :henchmen
      t.string :standard_abilities

      t.timestamps
    end

    add_index :official_characters, :name
    add_index :official_characters, :number
  end
end
