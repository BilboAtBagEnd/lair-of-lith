class AddVersionIndex < ActiveRecord::Migration
  def change
    add_index(:character_versions, [:character_id, :version], :unique => true)
  end
end
