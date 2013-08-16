class AddThreadIdToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :bgg_thread_id, :integer
  end
end
