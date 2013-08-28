class TagsController < ApplicationController
  def index
    @character_tags = Character.tag_counts.order('name')
  end

  def view
    @tag = params[:tag]
    @characters = Character.where("status != 'HIDE'").tagged_with(@tag).order('characters.name').includes(:user)
  end
end
