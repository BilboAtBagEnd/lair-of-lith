class CharactersController < ApplicationController
  before_filter :authenticate_user!, :only => [:save]

  def new
  end

  def help
  end

  def save
    @user = current_user
    @character_name = params[:character_name]
    @character = Character.find_by_name(@character_name)
    if (Character.find_by_name(@character_name)) 

    end
  end
end
