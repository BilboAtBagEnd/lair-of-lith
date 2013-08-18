class Character < ActiveRecord::Base
  extend FriendlyId
  belongs_to :user
  has_many :character_versions

  paginates_per 25

  friendly_id [:name, :title], use: [:slugged, :history, :scoped], scope: :user

  validates_presence_of :name, :user_id
  validates_uniqueness_of :name, scope: [:user_id]
  validates_uniqueness_of :title, scope: [:name, :user_id]

  def name=(val)
    self[:name] = val
    @name_case_insensitive_changed = val.downcase != name.downcase
  end

  def title=(val)
    self[:title] = val
    @name_case_sensitive_changed = val.downcase != title.downcase
  end

  def should_generate_new_friendly_id?
    @name_case_insensitive_changed || false
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
