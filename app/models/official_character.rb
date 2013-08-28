class OfficialCharacter < ActiveRecord::Base
  has_many :official_specials, :dependent => :delete_all
end
