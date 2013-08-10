class AddNameToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :name, :string
    add_index :characters, :name
  end
end
