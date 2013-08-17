class AddCharacterDescription < ActiveRecord::Migration
  def change
    add_column :characters, :description, :text, :limit => nil
  end
end
