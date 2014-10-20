class ChangeVersionVersion < ActiveRecord::Migration
  def change
    change_column(:character_versions, :version, 'integer USING CAST(version AS integer)')
  end
end
