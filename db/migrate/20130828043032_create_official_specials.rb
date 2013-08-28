class CreateOfficialSpecials < ActiveRecord::Migration
  def change
    create_table :official_specials do |t|
      t.references :OfficialCharacter, index: true
      t.text :description
      t.integer :survival
      t.integer :ranged
      t.integer :melee
      t.integer :adventure

      t.timestamps
    end
  end
end
