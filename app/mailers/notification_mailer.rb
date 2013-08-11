class NotificationMailer < ActionMailer::Base
  default from: "lith@lairoflith.com"
  default to: "bilboatbagend@lairoflith.com"

  def new_message(message) 
    @message = message
    mail(:subject => "[Lair of Lith] #{message.subject}")
  end
end
