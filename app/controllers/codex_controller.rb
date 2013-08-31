class CodexController < ApplicationController
  def index
    @characters = OfficialCharacter.select(:name, :profession, :age, :setting, :circle, :nature).distinct
  end

  def character
    name = params[:name].gsub('+', ' ')
    @characters = OfficialCharacter.where('name = ?', name)

    if @characters.size == 0 
      raise ActiveRecord::RecordNotFound
    end

    @character = @characters[0]

    if @characters.size > 1
      @character_alt = @characters[1]
    end
  end

  def search
    @query = params[:query]
    @page = params[:page].to_i 

    @page = 1 if @page < 1

    @specials = []
    if @query && !@query.strip.empty?
      @specials = OfficialSpecial.search(@query, :populate => true).page(@page).per(50)
    end
  end
end
