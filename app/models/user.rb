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

  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false

  def should_generate_new_friendly_id?
    name_changed?
  end
end
