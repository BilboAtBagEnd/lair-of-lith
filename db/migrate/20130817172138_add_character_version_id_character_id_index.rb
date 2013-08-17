class AddCharacterVersionIdCharacterIdIndex < ActiveRecord::Migration
  def change
    add_index(:character_versions, [:id, :character_id], :unique => true)
  end
end
