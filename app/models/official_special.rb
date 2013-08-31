class OfficialSpecial < ActiveRecord::Base
  belongs_to :official_character

  def to_s 
    scorings = []
    scorings << "Survival: #{survival}" if survival != 0 
    scorings << "Ranged: #{ranged}" if ranged != 0 
    scorings << "Melee: #{melee}" if melee != 0 
    scorings << "Adventure: #{adventure}" if adventure != 0 

    scoring = ''
    unless scorings.empty? 
      scoring = " (#{scorings.join(', ')})"
    end

    description + scoring
  end
end
