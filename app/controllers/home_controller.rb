class HomeController < ApplicationController
  protect_from_forgery :except => [:bbcode]

  def index
    @characters = Character.includes(:user).where("status != 'HIDE'").order('characters.created_at desc').limit(10).references(:user)
    @character_total = Character.all.count
    @popular_tags = Character.tag_counts.order('count desc, name asc').limit(20)
    @characters_for_comment = Character.find_by_status('REVIEW').order('characters.updated_at desc').limit(10).includes(:user).references(:user)
  end

  def bbcode
    text = ApplicationHelper.parseBBCode(params[:data])
    respond_to do |format|
      format.text { render :text => text } 
    end
  end
end
