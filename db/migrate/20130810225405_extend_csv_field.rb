class ExtendCsvField < ActiveRecord::Migration
  def change
    change_column :character_versions, :csv, :text, :limit => nil
    change_column :characters, :name, :string, :limit => 1000
  end
end
