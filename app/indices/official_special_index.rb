ThinkingSphinx::Index.define :official_special, :with => :active_record do 
  indexes description
  indexes official_character(:name)
  has survival, adventure, ranged, melee
  has 'official_specials.survival + official_specials.adventure + official_specials.ranged + official_specials.melee', as: :total, type: :integer
end
