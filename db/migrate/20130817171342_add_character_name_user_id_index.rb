class AddCharacterNameUserIdIndex < ActiveRecord::Migration
  def change
    change_column(:characters, :name, :string, :limit => 255)
    add_index(:characters, [:name, :user_id], :unique => true)
  end
end
