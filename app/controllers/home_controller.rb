class HomeController < ApplicationController
  protect_from_forgery :except => [:bbcode]

  def index
    #@characters = Character.connection.select_all('SELECT characters.*, users.slug as user_slug, users.name as user_name from characters, users where characters.user_id = users.id order by created_at desc limit 50')
    @characters = Character.includes(:user).order('characters.created_at desc').limit(10).references(:user)
    @character_total = Character.all.count
  end

  def bbcode
    text = ApplicationHelper.parseBBCode(params[:data])
    respond_to do |format|
      format.text { render :text => text } 
    end
  end
end
