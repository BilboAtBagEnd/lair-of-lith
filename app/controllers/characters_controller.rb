class CharactersController < ApplicationController
  before_filter :authenticate_user!, :only => [:save]

  def new
  end

  def help
  end

  def view
    @character = Character.find(params[:id])
    @owner = User.find(@character.user_id)

    if @character && @owner
      # PRIVACY CHECK
      if current_user.id == @character.user_id 
        @versions = CharacterVersion.where('character_id = ?', @character.id).order('version desc')
      else
        raise ActionController::RoutingError.new('Character Not Found')
      end
    else
      raise ActionController::RoutingError.new('Character Not Found')
    end
  end

  def edit
    @user = current_user
    @character = Character.find(params[:id])
    @owner = User.find(@character.user_id)

    @is_myself = @user ? @user.id == @owner.id : false

    # PRIVACY CHECK
    if !@user || !@character || !@owner || (@user && (@user.id != @character.user_id)) 
      raise ActionController::RoutingError.new('Character Not Found')
    end

    @version = CharacterVersion.find(params[:vid])
    if !@version || @version.character_id != @character.id
      raise ActionController::RoutingError.new('Version Not Found')
    end
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
