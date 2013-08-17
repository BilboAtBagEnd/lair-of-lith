class AddCharacterIdUserIdIndex < ActiveRecord::Migration
  def change
    add_index(:characters, [:id, :user_id], unique: true)
  end
end
