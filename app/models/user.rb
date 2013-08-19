class User < ActiveRecord::Base
  extend FriendlyId
  has_many :characters

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  friendly_id :name, use: [:slugged, :history]

  validates_presence_of :name, :email
  validates_uniqueness_of :name, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false

  def name=(val)
    if name
      @name_case_insensitive_changed = val.downcase != name.downcase
    else
      @name_case_insensitive_changed = true
    end
    self[:name] = val
  end

  def should_generate_new_friendly_id?
    if !id 
      return true
    else
      return @name_case_insensitive_changed || false
    end
  end
end
