require 'spec_helper'

describe UsersController do
  describe "GET view" do 
    it "renders the view template" do 
      FactoryGirl.create(:user)
      get :view, :id => 1
      expect(response).to render_template('view')
    end

    it "sets the user" do
      user = FactoryGirl.create(:user)
      get :view, :id => user.slug
      assigns(:user).should be == user
    end

    it "lists the user's characters in alpha order" do 
      user = FactoryGirl.create(:user)
      c2 = FactoryGirl.create(:character, :name => 'B Lunch')
      c1 = FactoryGirl.create(:character, :name => 'A Salad')
      c3 = FactoryGirl.create(:character, :name => 'C Dessert')
      get :view, :id => user.slug
      assigns(:characters).should be == [c1, c2, c3]
    end
  end
end
