class CharactersController < ApplicationController
  before_filter :authenticate_user!, :only => [:save]

  def new
  end

  def help
  end

  def save
    @user = current_user
    @character_name = params[:name]
    @characters = Character.where('user_id = ? AND name = ?', @user.id, @character_name)
    @character = nil
    if @characters && @characters.size > 0
      @character = @characters[0]
    end

    @prev_version = 0
    if @character
      max = CharacterVersion.group(:character_id).having('character_id = ?', @character.id).maximum(:version)
      @prev_version = max[@character.id] || 0
    else
      # create the character.
      @character = Character.new
      @character.user_id = @user.id
      @character.name = @character_name
      unless @character.save 
        flash[:error] = 'Could not save character'
        @character = nil
      end
    end

    @character_version = nil
    if @character
      @character_version = CharacterVersion.new
      @character_version.character_id = @character.id
      @character_version.version = @prev_version + 1
      @character_version.csv = params[:csv]
      unless @character_version.save
        flash[:error] = 'Could not save character version'
        @character_version = nil
      end
    end

    @result = {
      character: @character, 
      version: @character_version,
    }

    respond_to do |format|
      format.json { render json: @result.to_json, status: @character_version ? 200 : 500 }
    end
  end
end
