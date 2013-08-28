class RenameOfficialSpecialCharacterId < ActiveRecord::Migration
  def change
    rename_column :official_specials, :OfficialCharacter_id, :official_character_id
  end
end
