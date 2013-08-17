class HomeController < ApplicationController
  # TODO - remove
  protect_from_forgery :except => [:bbcode]

  def index
    #@characters = Character.connection.select_all('SELECT characters.*, users.slug as user_slug, users.name as user_name from characters, users where characters.user_id = users.id order by created_at desc limit 50')
    @characters = Character.joins(:user).order(:created_at).limit(50)
  end

  def bbcode
    text = ApplicationHelper.parseBBCode(params[:data])
    respond_to do |format|
      format.text { render :text => text } 
    end
  end
end
