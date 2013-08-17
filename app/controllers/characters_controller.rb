class CharactersController < ApplicationController
  before_filter :authenticate_user!, :only => [:save, :save_data, :destroy]

  def new
    @is_new = true
  end

  def help
  end

  def walkthrough
  end

  def view
    @owner = User.friendly.find(params[:uid])

    if !@owner
      raise ActionController::RoutingError.new('Character Not Found')
    end

    @character = @owner.characters.friendly.find(params[:cid])

    if !@character
      raise ActionController::RoutingError.new('Character Not Found')
    end

    @versions = CharacterVersion.where('character_id = ?', @character.id).order('version desc')
    if (@versions.size > 0) 
      @newest_version = @versions[0]
      @csv = CharactersHelper.csv_to_hash @newest_version.csv
    end

    @current_user_is_owner = (current_user ? current_user.id == @owner.id : false)
  end

  def generate
    @user = current_user

    @owner = User.friendly.find(params[:uid])

    if !@owner 
      raise ActionController::RoutingError.new('Character Not Found')
    end

    @character = @owner.characters.friendly.find(params[:cid])

    if !@character 
      raise ActionController::RoutingError.new('Character Not Found')
    end

    @rows = CharacterVersion.where('character_id = ? and version = ?', @character.id, params[:version])
    if @rows.size > 0
      @version = @rows[0]
    end

    if !@version 
      raise ActionController::RoutingError.new("Version Not Found")
    end

    @current_user_is_owner = (current_user ? current_user.id == @owner.id : false)
  end

  def save
    @user = current_user
    @character_name = params[:name].gsub(/[<>]/, '_')
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
      @character_version.csv = CharactersHelper.html_decode(params[:csv]).gsub(/[<>]/, '_')
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
      format.html { redirect_to character_generate_path(@user, @character.slug, @character_version.version) }
      format.json { render json: @result.to_json, status: @character_version ? 200 : 500 }
    end
  end

  def save_data
    @owner = User.friendly.find(params[:uid])
    if !@owner
      raise ActionController::RoutingError.new("User Not Found")
    end

    if @owner.id != current_user.id
      raise ActionController::RoutingError.new("Permission Denied")
    end

    @character = @owner.characters.friendly.find(params[:cid])
    if !@character
      raise ActionController::RoutingError.new("Character Not Found")
    end

    new_data = params[:character]
    bgg_thread_id = new_data[:bgg_thread_id]
    description = new_data[:description]
    
    if bgg_thread_id 
      bgg_thread_id_int = bgg_thread_id.to_i
      if bgg_thread_id.empty? || bgg_thread_id_int == 0
        @character.bgg_thread_id = nil
      else
        @character.bgg_thread_id = bgg_thread_id_int
      end
    end

    if description
      if description.strip.empty?
        @character.description = nil
      else
        @character.description = Sanitize.clean description
      end
    end

    @character.save

    redirect_to character_path(@owner, @character)
  end

  def destroy
    @character = Character.find(params[:id])
    if @character && current_user.id == @character.user_id
      @character.destroy
    else
      raise ActionController::RoutingError.new("Permission Denied")
    end
  end
end
