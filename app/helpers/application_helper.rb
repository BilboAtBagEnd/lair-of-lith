module ApplicationHelper
  def self.parseBBCode(bbcode)
    RbbCode.new.convert(Sanitize.clean bbcode.to_s)
  end

  def self.gravatar(user, size = 64)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size.to_i}"
  end
end
