require 'spec_helper'

describe DOA2 do
  CSV = %Q(v4|A Very, Very, Very Long Name Indeed|The Example|Ancient|Faer|Lord|Woman|7|4|6|6|2|2|5|3|7|8|8|2|5|3|5|6|3|1|2|5|0|single|4|3|2|1|Auto Pistol,Auto Rifle|Blade,Brawler|1|1|1|Bot,Gadget,Mount|1|1|1|Move cost 1 in Swamp.|10|0|0|0|This character leaps over other character whenever damage is dealt using its natural melee attack. Just like how the quick red fox jumped over the lazy brown dogs.|10|10|0|0)

  def expect_name(v) 
    expect(v).to eq('A Very, Very, Very Long Name Indeed')
  end

  def expect_title(v)
    expect(v).to eq('The Example')
  end

  def expect_age(v)
    expect(v).to eq('Ancient')
  end

  def expect_setting(v)
    expect(v).to eq('Faer')
  end

  def expect_circle(v)
    expect(v).to eq('Lord')
  end

  def expect_nature(v)
    expect(v).to eq('Woman')
  end

  def expect_bonuses(v)
    if v.class == Hash
      melee = v[:melee]
      ranged = v[:ranged]
      other = v[:other]
      medical = v[:medical]
      stealth = v[:stealth]
      armor = v[:armor]
    else
      melee = v.melee
      ranged = v.ranged
      other = v.other
      medical = v.medical
      stealth = v.stealth
      armor = v.armor
    end
    expect(melee.sort).to eq(['Blade', 'Brawler'])
    expect(ranged.sort).to eq(['Auto Pistol', 'Auto Rifle'])
    expect(other.sort).to eq(['Bot', 'Gadget', 'Mount'])
    expect(medical).to eq(true)
    expect(stealth).to eq(true)
    expect(armor).to eq(true)
  end

  def expect_specials(specials)
    expect(specials.size).to eq(2)
    if (specials[0].class == Hash)
      description_0 = specials[0][:description]
      description_1 = specials[1][:description]
    else
      description_0 = specials[0].description
      description_1 = specials[1].description
    end
    expect(description_0).to eq(%Q(Move cost 1 in Swamp.))
    expect(description_1).to eq(%Q(This character leaps over other character whenever damage is dealt using its natural melee attack. Just like how the quick red fox jumped over the lazy brown dogs.))
  end

  it "creates a hash from csv" do
    hash = DOA2.CSVToHash(CSV)
    # Test only the non-numerical values; numerics
    # will be taken care of when testing calculation
    expect_name(hash[:name])
    expect_title(hash[:title])
    expect_age(hash[:age])
    expect_setting(hash[:setting])
    expect_circle(hash[:circle])
    expect_nature(hash[:nature])
    expect_bonuses(hash[:bonuses])
    expect_specials(hash[:specials])
  end

  it "calculates the value from a converted hash" do 
    hash = DOA2.CSVToHash(CSV)
    value = DOA2.calculateValueForCharacterHash(hash)
    expect(value).to eq({survival: 202.2, melee: 192, ranged: 207, adventure: 234, total: 835.2})
  end

  it "creates a DOA2::Character from csv" do
    c = DOA2::Character.new(csv: CSV)
    # Test only the non-numerical values; numerics
    # will be taken care of when testing calculation
    expect_name(c.name)
    expect_title(c.title)
    expect_age(c.age)
    expect_setting(c.setting)
    expect_circle(c.circle)
    expect_nature(c.nature)
    expect_bonuses(c.bonuses)
    expect_specials(c.specials)
  end

  it "calculates the value from a DOA2::Character" do 
    c = DOA2::Character.new(csv: CSV)
    value = c.value
    expect(value.survival).to eq(202.2)
    expect(value.melee).to eq(192)
    expect(value.ranged).to eq(207)
    expect(value.adventure).to eq(234)
    expect(value.total).to eq(835.2)
  end
end
