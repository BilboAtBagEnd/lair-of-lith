class CodexController < ApplicationController
  def index
    @characters = OfficialCharacter.select(:name, :profession, :age, :setting, :circle, :nature).distinct
  end

  def character
    @characters = OfficialCharacter.where('name = ?', params[:name])

    if @characters.size == 0 
      raise ActiveRecord::RecordNotFound
    end

    @character = @characters[0]

    if @characters.size > 1
      @character_alt = @characters[1]
    end
  end
end
