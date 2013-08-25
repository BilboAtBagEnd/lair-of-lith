module ApplicationHelper
  def self.parseBBCode(bbcode)
    RbbCode.new.convert(Sanitize.clean bbcode.to_s)
  end

  def self.gravatar(user, size = 64)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size.to_i}"
  end

  # Google Analytics Server Side Events
  GA_UT = 'UA-43134554-1'
  GA_DOMAIN = 'lairoflith.com'
  GABBA = Gabba::Gabba.new(GA_UT, GA_DOMAIN)
  def self.ga_event(category, action, label=nil, value=nil, non_interaction = nil)
    if Rails.env.production? 
      GABBA.event(category, action, label, value, non_interaction)
    end
  end
end
