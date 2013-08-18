class Character < ActiveRecord::Base
  extend FriendlyId
  belongs_to :user
  has_many :character_versions

  paginates_per 25

  friendly_id :name, use: [:slugged, :history, :scoped], scope: :user

  validates_presence_of :name, :user_id
  validates_uniqueness_of :name, scope: [:user_id]

  def name=(val)
    @name_case_insensitive_changed = val.downcase != name.downcase
    self[:name] = val
  end

  def should_generate_new_friendly_id?
    if !id 
      return true
    else
      return @name_case_insensitive_changed || false
    end
  end

  def bgg_thread_link 
    if bgg_thread_id 
      url = %Q(http://www.boardgamegeek.com/thread/#{bgg_thread_id.to_i})
      %Q(<a href="#{url}">#{url}</a>)
    else
      'No BoardGameGeek discussion thread.'
    end
  end

  def description_as_html
    ApplicationHelper.parseBBCode(description)
  end
end
