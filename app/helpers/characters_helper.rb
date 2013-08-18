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

  def self.csv_to_hash(csv) 
    values = csv.split('|')
    hash = {}

    j = 0 
    hash[:name] = values[j+=1]
    hash[:title] = values[j+=1]
    hash[:age] = values[j+=1]
    hash[:setting] = values[j+=1]
    hash[:circle] = values[j+=1]
    hash[:nature] = values[j+=1]

    DOA2_STATS.each do |stat|
      hash[stat] = values[j+=1].to_i
    end

    hash[:rangedWeapon] = {
      :power =>  values[j+=1].to_i,
      :damage =>  values[j+=1].to_i,
      :opfire =>  values[j+=1].to_i,
      :rangeMax =>  values[j+=1].to_i,
      :rangeMin =>  values[j+=1].to_i,
      :area =>  values[j+=1]
    }

    hash[:cards] = {
      :common =>  values[j+=1].to_i,
      :secret =>  values[j+=1].to_i,
      :elite =>  values[j+=1].to_i,
      :henchmen =>  values[j+=1].to_i,
    }

    hash[:bonuses] = {
      :ranged =>  values[j+=1].split(/ *, */),
      :melee =>  values[j+=1].split(/ *, */),
      :medical =>  values[j+=1].to_i == 1,
      :stealth =>  values[j+=1].to_i == 1,
      :armor =>  values[j+=1].to_i == 1,
      :other =>  values[j+=1].split(/ *, */),
    }

    hash[:cards][:noGive] = values[j+=1].to_i == 1
    hash[:cards][:noTrade] = values[j+=1].to_i == 1
    hash[:cards][:noLimit] = values[j+=1].to_i == 1

    hash[:specials] = []
    i = j
    while (i < values.size) do 
      hash[:specials].push({
        :description =>  values[i+1],
        :value =>  {
          :survival =>  values[i+2].to_i,
          :melee =>  values[i+3].to_i,
          :ranged =>  values[i+4].to_i,
          :adventure =>  values[i+5].to_i,
        }
      })
      i += 5
    end

    return hash
  end

  def self.hash_to_value(csv)
    DOA2.calculateValueForCharacterHash csv
  end
end
