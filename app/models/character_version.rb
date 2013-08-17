class CharacterVersion < ActiveRecord::Base
  belongs_to :character
  validates_presence_of :character_id, :version, :csv

  def csv_to_js 
    csv.gsub('"', '\\"').gsub("\r\n", '\\n').strip
  end
end
