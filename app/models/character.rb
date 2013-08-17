class Character < ActiveRecord::Base
  extend FriendlyId
  belongs_to :user
  has_many :character_versions

  friendly_id :name, use: [:slugged, :history, :scoped], scope: :user

  validates_presence_of :name, :user_id

  def should_generate_new_friendly_id?
    name_changed?
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
