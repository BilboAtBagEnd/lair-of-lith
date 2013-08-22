class AddIndexToCharacterStatus < ActiveRecord::Migration
  def change
    add_index(:characters, [:status, :id])
  end
end
