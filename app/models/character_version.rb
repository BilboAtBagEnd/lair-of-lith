class CharacterVersion < ActiveRecord::Base
  belongs_to :character
  validates_presence_of :character_id, :version, :csv
  validates_uniqueness_of :version, scope: [:character_id]

  # TODO: Move to helper
  def csv_to_js 
    csv.gsub('"', '\\"').gsub("\r\n", '\\n').strip
  end
end
