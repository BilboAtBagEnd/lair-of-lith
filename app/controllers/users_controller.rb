class UsersController < ApplicationController
  def view
    @user = User.find(params[:id])

    if !@user
      raise ActionController::RoutingError.new('User Not Found')
    end

    # list out characters.
    @characters = Character.where('user_id = ?', @user.id).order(:name)
  end
end
