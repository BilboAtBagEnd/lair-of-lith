class AddSlugFieldToUserCharacter < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string, null: false 
    add_index :users, :slug, unique: true

    add_column :characters, :slug, :string, null: false
    add_index :characters, :slug
  end
end
