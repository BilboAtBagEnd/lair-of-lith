class CharacterVersion < ActiveRecord::Base
  belongs_to :character
  validates_presence_of :character_id, :version, :csv
end
