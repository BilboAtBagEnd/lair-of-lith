class UsersController < ApplicationController
  def view
    @user = User.friendly.find(params[:id])

    if !@user
      raise ActionController::RoutingError.new('User Not Found')
    end

    # list out characters.

    if current_user && @user.id == current_user.id 
      @characters = Character.where('user_id = ?', @user.id).order(:name)
    else
      @characters = Character.where("user_id = ? and status != 'HIDE'", @user.id).order(:name)
    end
  end
end
