ThinkingSphinx::Index.define :official_special, :with => :active_record do 
  indexes description
  has survival, adventure, ranged, melee
  has 'survival + adventure + ranged + melee', as: :total, type: :integer
end
