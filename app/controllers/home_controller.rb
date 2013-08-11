class HomeController < ApplicationController
  def index
    @characters = Character.connection.select_all('SELECT characters.*, users.id as uid, users.name as user_name from characters, users where characters.user_id = users.id order by created_at desc limit 50')
  end
end
