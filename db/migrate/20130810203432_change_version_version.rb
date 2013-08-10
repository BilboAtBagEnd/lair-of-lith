class ChangeVersionVersion < ActiveRecord::Migration
  def change
    change_column(:character_versions, :version, :integer)
  end
end
