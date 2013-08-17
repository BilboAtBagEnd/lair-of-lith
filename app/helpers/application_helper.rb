module ApplicationHelper
  def self.parseBBCode(bbcode)
    RbbCode.new.convert(Sanitize.clean bbcode.to_s)
  end
end
