class HomeController < ApplicationController
  def index
    @characters = Character.connection.select_all('SELECT characters.*, users.slug as user_slug, users.name as user_name from characters, users where characters.user_id = users.id order by created_at desc limit 50')
  end
end
