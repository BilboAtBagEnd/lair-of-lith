class HomeController < ApplicationController
  protect_from_forgery :except => [:bbcode]

  def index
    @characters = Character.includes(:user).order('characters.created_at desc').limit(10).references(:user)
    @character_total = Character.all.count
    @popular_tags = Character.tag_counts.order('count desc, name asc').limit(10)
  end

  def bbcode
    text = ApplicationHelper.parseBBCode(params[:data])
    respond_to do |format|
      format.text { render :text => text } 
    end
  end
end
