class CreateCharacterVersions < ActiveRecord::Migration
  def change
    create_table :character_versions do |t|
      t.references :character, index: true
      t.string :version
      t.string :csv

      t.timestamps
    end
  end
end
