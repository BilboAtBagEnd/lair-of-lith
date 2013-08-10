class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end
