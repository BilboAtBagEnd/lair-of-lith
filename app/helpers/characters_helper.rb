require 'DOA2'

module CharactersHelper
  DOA2_STATS = [
    :speed, :health, :wits, :melee, :power, :damage,
    :aim, :point, :throw, :react, :stealth, :armor, 
    :strength, :intellect, :honor, :respect 
  ]

  def self.html_decode(s) 
    return HTMLEntities.new.decode s
  end

  def self.csv_to_doa2_character(csv)
    DOA2::Character.new(csv: csv)
  end

  def self.csv_to_hash(csv) 
    return DOA2.CSVToHash(csv)
  end

  def self.hash_to_value(csv)
    DOA2.calculateValueForCharacterHash csv
  end
end
