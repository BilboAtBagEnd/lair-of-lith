class AddStatusToCharacter < ActiveRecord::Migration
  def change
    add_column(:characters, :status, :string, limit: 10, null: false, default: 'WIP')
  end
end
