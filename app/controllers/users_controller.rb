class UsersController < ApplicationController
  def view
    @user = User.find(params[:id])
    @is_myself = (@user.id == current_user.id)
    
    # list out characters.
    @characters = Character.where('user_id = ?', user.id)
  end
end
