class Character < ActiveRecord::Base
  extend FriendlyId
  belongs_to :user
  has_many :character_versions

  friendly_id :name, use: [:slugged, :history, :scoped], scope: :user

  validates_presence_of :name, :user_id

  def should_generate_new_friendly_id?
    name_changed?
  end
end
