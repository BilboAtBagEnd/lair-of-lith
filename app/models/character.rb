class Character < ActiveRecord::Base
  extend FriendlyId
  belongs_to :user
  has_many :character_versions, :dependent => :delete_all

  paginates_per 25

  friendly_id :name, use: [:slugged, :history, :scoped], scope: :user

  acts_as_taggable

  validates_presence_of :name, :user_id
  validates_uniqueness_of :name, scope: [:user_id]

  STATUSES = %w(WIP REVIEW)
  FULL_STATUSES = { 
    'WIP' => 'Work in progress',
    'REVIEW' => 'Ready for comments'
  }

  def name=(val)
    if name && val
      @name_case_insensitive_changed = val.downcase != name.downcase
    else
      @name_case_insensitive_changed = true
    end
    self[:name] = val
  end

  def status=(val)
    if STATUSES.include? val
      self[:status] = val
    else
      raise 'Unknown status'
    end
  end

  def full_status_name
    FULL_STATUSES[status]
  end

  def options_for_select
    STATUSES.map { |status| [FULL_STATUSES[status], status] }
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
      url = %Q(http://www.boardgamegeek.com/article/#{bgg_thread_id.to_i})
      %Q(<a href="#{url}">#{url}</a>)
    else
      'No BoardGameGeek discussion thread.'
    end
  end

  def description_as_html
    ApplicationHelper.parseBBCode(description)
  end

  def self.find_by_status(status)
    Character.where('status = ?', status)
  end
end
