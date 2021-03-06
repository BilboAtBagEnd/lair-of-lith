# Ruby module for methods involving DOA2.
module DOA2

  RATINGS = [
    "speed", "health", "wits", "melee", "power", "damage",
    "aim", "point", "throw", "react", "stealth", "armor", 
    "strength", "intellect", "honor", "respect" 
  ]

  RATINGS_AS_SYMBOLS = RATINGS.map { |s| s.to_sym }

  BONUSES = {
    melee: %w(Blade Brawler Swing Thrust),
    ranged: 'Auto Pistol,Auto Rifle,Bow,Crossbow,Energy Pistol,Energy Rifle,Grenade,Heavy,Long Pistol,Long Rifle,Powder Pistol,Powder Rifle,Revolver,Thrown'.split(/,/),
    other: %w(Bot Gadget Medical Mount Pet Vehicle),
    special: %w(Medical Stealth Armor),
  }

  # Default evaluation of any rating value. 
  # Specific ratings may have different valuations, in 
  # which when they should use a different function.
  def self.calculateGenericRatingValue(rating) 
    case rating 
    when 0
      return 0
    when 1
      return 4
    when 2
      return 9
    when 3
      return 15
    when 4
      return 21
    when 5
      return 27
    when 6
      return 33
    when 7
      return 39
    when 8
      return 45
    when 9
      return 51
    else
      return 0
    end
  end

  # Calculates the value of the specific rating "speed".
  def self.calculateSpeedValue(speed)
    case speed
    when 3 
      return -20
    when 4
      return -5
    when 5
      return 5
    when 6
      return 15
    when 7
      return 25
    when 8
      return 40
    when 9
      return 55
    else
      return 0
    end
  end

  # Calculates the value of the health of the character
  # as a function of their health and their armor.
  def self.calculateHealthValue(health, armor) 
    healthRating = 0
    if health < 0
      return 0
    elsif health < 10
      healthRating = health * 2
    else
      healthRating = health + 9
    end

    case armor
    when 0
      return healthRating * 3.6
    when 1
      return healthRating * 5
    when 2
      return healthRating * 6.4
    when 3
      return healthRating * 8
    when 4
      return healthRating * 9.6
    when 5
      return healthRating * 11.4
    when 6
      return healthRating * 13.2
    when 7
      return healthRating * 15
    when 8
      return healthRating * 16.8
    when 9
      return healthRating * 18.6
    else
      return 0        
    end
  end

  # Mapping of Power, Damage to Value.
  POWER_DAMAGE_VALUE_TABLE = { 
    '0 0' => 0, '1 0' => 0, '2 0' => 0, '3 0' => 2, '4 0' => 2, '5 0' => 2, '6 0' => 4, '7 0' => 4, '8 0' => 6, '9 0' => 8,
    '0 1' => 2, '1 1' => 2, '2 1' => 4, '3 1' => 6, '4 1' => 6, '5 1' => 8, '6 1' => 10, '7 1' => 12, '8 1' => 16, '9 1' => 18,
    '0 2' => 4, '1 2' => 6, '2 2' => 8, '3 2' => 10, '4 2' => 12, '5 2' => 16, '6 2' => 18, '7 2' => 22, '8 2' => 24, '9 2' => 28,
    '0 3' => 10, '1 3' => 12, '2 3' => 16, '3 3' => 20, '4 3' => 22, '5 3' => 26, '6 3' => 30, '7 3' => 32, '8 3' => 36, '9 3' => 40,
    '0 4' => 16, '1 4' => 20, '2 4' => 24, '3 4' => 28, '4 4' => 32, '5 4' => 36, '6 4' => 40, '7 4' => 44, '8 4' => 48, '9 4' => 52,
    '0 5' => 22, '1 5' => 26, '2 5' => 32, '3 5' => 36, '4 5' => 42, '5 5' => 46, '6 5' => 52, '7 5' => 56, '8 5' => 60, '9 5' => 64,
    '0 6' => 28, '1 6' => 34, '2 6' => 40, '3 6' => 46, '4 6' => 52, '5 6' => 56, '6 6' => 62, '7 6' => 66, '8 6' => 72, '9 6' => 74,
    '0 7' => 34, '1 7' => 40, '2 7' => 48, '3 7' => 54, '4 7' => 62, '5 7' => 68, '6 7' => 72, '7 7' => 78, '8 7' => 82, '9 7' => 86,
    '0 8' => 40, '1 8' => 48, '2 8' => 56, '3 8' => 64, '4 8' => 70, '5 8' => 78, '6 8' => 84, '7 8' => 90, '8 8' => 94, '9 8' => 98,
    '0 9' => 46, '1 9' => 54, '2 9' => 64, '3 9' => 72, '4 9' => 80, '5 9' => 88, '6 9' => 94, '7 9' => 100, '8 9' => 106, '9 9' => 110
  }

  # Calculate the value of the type of ranged damage an 
  # attack (usually from a weapon, occasionally from special characters)
  # can do.
  #
  # The last parameter, "area", is either "single" or "area".
  def self.calculateRangedDamageValue(power, damage, opfire, rangeMax, rangeMin, area) 
    value = POWER_DAMAGE_VALUE_TABLE["#{power} #{damage}"]

    if area == 'area'  
      value = value * 1.5
    elsif area == 'single'
      # nop
    else
      return 0
    end

    case opfire
    when 1
      # nop
    when 2
      value = value * 1.5
    when 3
      value = value * 1.8
    when 4
      value = value * 2
    when 5
      value = value * 2.2
    else
      value = value * 2.4
    end

    if rangeMax < 0  
      # nop
    elsif rangeMax < 6 
      value += rangeMax
    elsif rangeMax < 12 
      value += 6 + (rangeMax - 6) / 2
    else 
      value += 9 + (rangeMax - 12) / 4
    end

    return value
  end

  # Calculate the value of a melee attack, either of a character or a weapon.
  def self.calculateMeleeDamageValue(power, damage, melee) 
    value = POWER_DAMAGE_VALUE_TABLE["#{power} #{damage}"]
    return 0 unless value

    case melee 
    when 0
      value = value * 0.25
    when 1
      value = value * 0.5
    when 2
      value = value * 0.75
    when 3
      value = value * 1
    when 4
      value = value * 1.3
    when 5
      value = value * 1.6
    when 6
      value = value * 2
    when 7
      value = value * 2.5
    when 8
      value = value * 3.1
    when 9
      value = value * 3.8
    end

    return value
  end

  # Calculate the value of a character based on their starting cards/henchmen for 
  # a specific category (melee, ranged, or adventure). 
  def self.calculateCardValue(numCommon, numSecret, numElite, numHenchmen, category) 
    value = 0

    case category
    when :melee
      value += numCommon * 6
      value += numSecret * 3
      value += numElite * 10
      value += numHenchmen * 21
    when :ranged
      value += numCommon * 12
      value += numSecret * 3
      value += numElite * 15
      value += numHenchmen * 21
    when :adventure
      value += numCommon * 6
      value += numSecret * 12
      value += numElite * 15
      value += numHenchmen * 6
    end

    return value
  end

  def self.calculateCardBonusValue(noGive, noTrade, noLimit, category)
    value = 0

    case category
    when :survival
      if noTrade  
        value -= 5
      end
    when :melee
      if noTrade  
        value -= 5
      end
    when :ranged
      if noTrade  
        value -= 10
      end
    when :adventure
      if noTrade  
        value -= 10
      end
      if noGive  
        value -= 15
      end
      if noLimit  
        value += 15
      end
    end

    return value
  end

  def self.calculateSpecialValueFor(specials, category)
    value = 0
    specials.each do |s|
      if s.class == Hash
        value += s[:value][category]
      else
        value += s.value[category]
      end
    end
    return value
  end

  def self.calculateValueForCharacterHash(hash)
    value = 0

    # Survival
    survivalValue = 0
    survivalValue += calculateSpeedValue(hash[:speed])
    survivalValue += calculateGenericRatingValue(hash[:stealth])
    survivalValue += calculateGenericRatingValue(hash[:react])
    survivalValue += calculateHealthValue(hash[:health], hash[:armor])
    survivalValue += 7 if hash[:bonuses][:medical]
    survivalValue += 7 if hash[:bonuses][:stealth]
    survivalValue += 7 if hash[:bonuses][:armor]
    survivalValue += calculateSpecialValueFor(hash[:specials], :survival)
    survivalValue += calculateCardValue(hash[:cards][:common], 
                                        hash[:cards][:secret],
                                        hash[:cards][:elite],
                                        hash[:cards][:henchmen],
                                        :survival)
    survivalValue += calculateCardBonusValue(hash[:cards][:noGive], 
                                             hash[:cards][:noTrade],
                                             hash[:cards][:noLimit], 
                                             :survival)

    # Ranged
    rangedValue = 0
    rangedValue += calculateGenericRatingValue(hash[:aim])
    rangedValue += calculateGenericRatingValue(hash[:point])
    rangedValue += calculateGenericRatingValue(hash[:throw])
    rangedValue += calculateRangedDamageValue(
      hash[:rangedWeapon][:power],
      hash[:rangedWeapon][:damage],
      hash[:rangedWeapon][:opfire],
      hash[:rangedWeapon][:rangeMax],
      hash[:rangedWeapon][:rangeMin],
      hash[:rangedWeapon][:area])
      rangedValue += 7 * hash[:bonuses][:ranged].length
      rangedValue += calculateSpecialValueFor(hash[:specials], :ranged)
      rangedValue += calculateCardValue(hash[:cards][:common], 
                                        hash[:cards][:secret],
                                        hash[:cards][:elite],
                                        hash[:cards][:henchmen],
                                        :ranged)
      rangedValue += calculateCardBonusValue(hash[:cards][:noGive], 
                                             hash[:cards][:noTrade],
                                             hash[:cards][:noLimit], 
                                             :ranged)

      # Melee
      meleeValue = 0
      meleeValue += calculateGenericRatingValue(hash[:wits])
      meleeValue += hash[:melee] * hash[:speed]
      meleeValue += calculateMeleeDamageValue(hash[:power], hash[:damage], hash[:melee]) * 1.5
      meleeValue += 7 * hash[:bonuses][:melee].length
      meleeValue += calculateSpecialValueFor(hash[:specials], :melee)
      meleeValue += calculateCardValue(hash[:cards][:common], 
                                       hash[:cards][:secret],
                                       hash[:cards][:elite],
                                       hash[:cards][:henchmen],
                                       :melee)
      meleeValue += calculateCardBonusValue(hash[:cards][:noGive], 
                                            hash[:cards][:noTrade],
                                            hash[:cards][:noLimit], 
                                            :melee)

      # Adventure
      adventureValue = 0
      adventureValue += calculateSpeedValue(hash[:speed])
      adventureValue += calculateGenericRatingValue(hash[:strength])
      adventureValue += calculateGenericRatingValue(hash[:intellect])
      if hash[:strength] < 1 || hash[:intellect]< 1
        adventureValue -= 20
      end
      adventureValue += calculateGenericRatingValue(hash[:honor])
      adventureValue += calculateGenericRatingValue(hash[:respect])
      adventureValue += 7 * hash[:bonuses][:other].length
      adventureValue += calculateSpecialValueFor(hash[:specials], :adventure)
      adventureValue += calculateCardValue(hash[:cards][:common], 
                                           hash[:cards][:secret],
                                           hash[:cards][:elite],
                                           hash[:cards][:henchmen],
                                           :adventure)
      adventureValue += calculateCardBonusValue(hash[:cards][:noGive], 
                                                hash[:cards][:noTrade],
                                                hash[:cards][:noLimit], 
                                                :adventure)

      value = survivalValue + rangedValue + meleeValue + adventureValue

      return {
        :total => value,
        :survival => survivalValue,
        :ranged => rangedValue,
        :melee => meleeValue,
        :adventure => adventureValue
      }
  end

  def self.CSVToHash(csv)
    values = csv.split('|')
    hash = {}

    j = 0 
    hash[:name] = values[j+=1]
    hash[:title] = values[j+=1]
    hash[:age] = values[j+=1]
    hash[:setting] = values[j+=1]
    hash[:circle] = values[j+=1]
    hash[:nature] = values[j+=1]

    RATINGS_AS_SYMBOLS.each do |stat|
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
    while (i+1 < values.size) do 
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

  class Character
    class RangedWeapon
      attr_accessor :power, :damage, :opfire, 
        :rangeMax, :rangeMin, :area
    end

    class StartingCardData
      attr_accessor :common, :secret, :elite, :henchmen, 
        :noGive, :noTrade, :noLimit
    end

    class BonusData
      attr_accessor :ranged, :melee, :medical, :stealth, 
        :armor, :other

      def initialize
        @ranged = []
        @melee = []
        @other = []
        @medical = false
        @stealth = false
        @armor = false
      end
    end

    class Special
      attr_accessor :description, :survival, :melee, 
        :ranged, :adventure

      def initialize
        @description = nil
        @survival = 0
        @melee = 0
        @ranged = 0
        @adventure = 0
      end

      def value
        Value.new(
          survival: @survival, 
          melee: @melee, 
          ranged: @ranged,
          adventure: @adventure
        )
      end
    end

    class Value
      attr_accessor :survival, :melee, :ranged, :adventure

      def initialize(params)
        @survival = params[:survival]
        @melee = params[:melee]
        @ranged = params[:ranged]
        @adventure = params[:adventure]
      end

      def total
        @survival + @melee + @ranged + @adventure
      end

      def [](value_type)
        case value_type.to_sym
        when :survival
          @survival
        when :melee
          @melee
        when :ranged
          @ranged
        when :adventure
          @adventure
        end
      end
    end

    attr_accessor :name, :title, :age, :setting, 
      :circle, :nature, :rangedWeapon, :cards, 
      :bonuses, :specials

    RATINGS_AS_SYMBOLS.each { |r| attr_accessor r }

    def initialize(params = {}) 
      if params.has_key? :csv
        initializeFromCSV(params[:csv])
      end
    end

    def initializeFromCSV(csv)
      values = csv.split('|')

      j = 0 
      @name = values[j+=1]
      @title = values[j+=1]
      @age = values[j+=1]
      @setting = values[j+=1]
      @circle = values[j+=1]
      @nature = values[j+=1]

      RATINGS.each do |rating|
        instance_variable_set("@#{rating}".to_sym, values[j+=1].to_i)
      end

      @rangedWeapon = RangedWeapon.new
      @rangedWeapon.power =  values[j+=1].to_i
      @rangedWeapon.damage =  values[j+=1].to_i
      @rangedWeapon.opfire =  values[j+=1].to_i
      @rangedWeapon.rangeMax =  values[j+=1].to_i
      @rangedWeapon.rangeMin =  values[j+=1].to_i
      @rangedWeapon.area =  values[j+=1]

      @cards = StartingCardData.new
      @cards.common =  values[j+=1].to_i
      @cards.secret =  values[j+=1].to_i
      @cards.elite =  values[j+=1].to_i
      @cards.henchmen =  values[j+=1].to_i

      @bonuses = BonusData.new
      @bonuses.ranged =  values[j+=1].split(/ *, */)
      @bonuses.melee =  values[j+=1].split(/ *, */)
      @bonuses.medical =  values[j+=1].to_i == 1
      @bonuses.stealth =  values[j+=1].to_i == 1
      @bonuses.armor =  values[j+=1].to_i == 1
      @bonuses.other =  values[j+=1].split(/ *, */)

      @cards.noGive = values[j+=1].to_i == 1
      @cards.noTrade = values[j+=1].to_i == 1
      @cards.noLimit = values[j+=1].to_i == 1

      @specials = []
      i = j
      while (i+1 < values.size) do 
        special = Special.new
        special.description =  values[i+1]
        special.survival =  values[i+2].to_i
        special.melee =  values[i+3].to_i
        special.ranged =  values[i+4].to_i
        special.adventure =  values[i+5].to_i
        @specials.push special

        i += 5
      end
    end

    def csv
      header = []
      row = []

      header.push('Version'); row.push("v4")

      header.push('Name'); row.push(@name)
      header.push('Title'); row.push(@title)
      header.push('Age'); row.push(@age)
      header.push('Setting'); row.push(@setting)
      header.push('Circle'); row.push(@circle)
      header.push('Nature'); row.push(@nature)

      RATINGS.each do |rating|
        header.push(rating.capitalize)
        row.push(instance_variable_get("@#{rating}".to_sym))
      end

      header.push('RangedWeaponPower'); row.push(@rangedWeapon.power)
      header.push('RangedWeaponDamage'); row.push(@rangedWeapon.damage)
      header.push('RangedWeaponOpFire'); row.push(@rangedWeapon.opfire)
      header.push('RangedWeaponRangeMax'); row.push(@rangedWeapon.rangeMax)
      header.push('RangedWeaponRangeMin'); row.push(@rangedWeapon.rangeMin)
      header.push('RangedWeaponArea'); row.push(@rangedWeapon.area)

      header.push('CardsCommon'); row.push(@cards.common)
      header.push('CardsSecret'); row.push(@cards.secret)
      header.push('CardsElite'); row.push(@cards.elite)
      header.push('Henchmen'); row.push(@cards.henchmen)

      header.push('BonusRanged'); row.push(@bonuses.ranged.join(','))
      header.push('BonusMelee'); row.push(@bonuses.melee.join(','))
      header.push('BonusMedical'); row.push(@bonuses.medical ? 1 : 0)
      header.push('BonusStealth'); row.push(@bonuses.stealth ? 1 : 0)
      header.push('BonusArmor'); row.push(@bonuses.armor ? 1 : 0)
      header.push('BonusOther'); row.push(@bonuses.other.join(','))

      header.push('NoGive'); row.push(@cards.noGive ? 1 : 0)
      header.push('NoTrade'); row.push(@cards.noTrade ? 1 : 0)
      header.push('NoLimit'); row.push(@cards.noLimit ? 1 : 0)

      @specials.each_index do |i|
        special = @specials[i]
        num = i+1

        header.push("Special#{num}"); row.push(special.description.gsub(/\r\n/, '\\n'))
        header.push("Special#{num}Survival"); row.push(special.survival)
        header.push("Special#{num}Melee"); row.push(special.melee)
        header.push("Special#{num}Ranged"); row.push(special.ranged)
        header.push("Special#{num}Adventure"); row.push(special.adventure)
      end

      text = ''

      # Too noisy to output the header each time. 
      #text += header.join('|') + "\n"
      text += row.join('|')

      return text
    end

    def value
      # Survival
      survivalValue = 0
      survivalValue += DOA2.calculateSpeedValue(@speed)
      survivalValue += DOA2.calculateGenericRatingValue(@stealth)
      survivalValue += DOA2.calculateGenericRatingValue(@react)
      survivalValue += DOA2.calculateHealthValue(@health, @armor)
      survivalValue += 7 if @bonuses.medical
      survivalValue += 7 if @bonuses.stealth
      survivalValue += 7 if @bonuses.armor
      survivalValue += DOA2.calculateSpecialValueFor(@specials, :survival)
      survivalValue += DOA2.calculateCardValue(@cards.common, 
                                               @cards.secret,
                                               @cards.elite,
                                               @cards.henchmen,
                                               :survival)
      survivalValue += DOA2.calculateCardBonusValue(@cards.noGive, 
                                                    @cards.noTrade,
                                                    @cards.noLimit, 
                                                    :survival)

      # Ranged
      rangedValue = 0
      rangedValue += DOA2.calculateGenericRatingValue(@aim)
      rangedValue += DOA2.calculateGenericRatingValue(@point)
      rangedValue += DOA2.calculateGenericRatingValue(@throw)
      rangedValue += DOA2.calculateRangedDamageValue(@rangedWeapon.power,
                                                     @rangedWeapon.damage,
                                                     @rangedWeapon.opfire,
                                                     @rangedWeapon.rangeMax,
                                                     @rangedWeapon.rangeMin,
                                                     @rangedWeapon.area)
      rangedValue += 7 * @bonuses.ranged.length
      rangedValue += DOA2.calculateSpecialValueFor(@specials, :ranged)
      rangedValue += DOA2.calculateCardValue(@cards.common, 
                                             @cards.secret,
                                             @cards.elite,
                                             @cards.henchmen,
                                             :ranged)
      rangedValue += DOA2.calculateCardBonusValue(@cards.noGive, 
                                                  @cards.noTrade,
                                                  @cards.noLimit, 
                                                  :ranged)

      # Melee
      meleeValue = 0
      meleeValue += DOA2.calculateGenericRatingValue(@wits)
      meleeValue += @melee * @speed
      meleeValue += DOA2.calculateMeleeDamageValue(@power, @damage, @melee) * 1.5
      meleeValue += 7 * @bonuses.melee.length
      meleeValue += DOA2.calculateSpecialValueFor(@specials, :melee)
      meleeValue += DOA2.calculateCardValue(@cards.common, 
                                            @cards.secret,
                                            @cards.elite,
                                            @cards.henchmen,
                                            :melee)
      meleeValue += DOA2.calculateCardBonusValue(@cards.noGive, 
                                                 @cards.noTrade,
                                                 @cards.noLimit, 
                                                 :melee)

      # Adventure
      adventureValue = 0
      adventureValue += DOA2.calculateSpeedValue(@speed)
      adventureValue += DOA2.calculateGenericRatingValue(@strength)
      adventureValue += DOA2.calculateGenericRatingValue(@intellect)
      if @strength < 1 || @intellect< 1
        adventureValue -= 20
      end
      adventureValue += DOA2.calculateGenericRatingValue(@honor)
      adventureValue += DOA2.calculateGenericRatingValue(@respect)
      adventureValue += 7 * @bonuses.other.length
      adventureValue += DOA2.calculateSpecialValueFor(@specials, :adventure)
      adventureValue += DOA2.calculateCardValue(@cards.common, 
                                                @cards.secret,
                                                @cards.elite,
                                                @cards.henchmen,
                                                :adventure)
      adventureValue += DOA2.calculateCardBonusValue(@cards.noGive, 
                                                     @cards.noTrade,
                                                     @cards.noLimit, 
                                                     :adventure)

      Value.new(
        survival: survivalValue,
        ranged: rangedValue,
        melee: meleeValue,
        adventure: adventureValue)
    end
  end
end

