require 'spec_helper'

describe HomeController do
  describe "GET index" do 
    it "renders the index template" do 
      get :index
      expect(response).to render_template('index')
    end

    it "populates an array of characters with associated users, order descending" do
      u1 = FactoryGirl.create(:user)
      c1 = FactoryGirl.create(:character)
      c2 = FactoryGirl.create(:character, name: 'Samael Bludsturm')
      u2 = FactoryGirl.create(:user, name: 'Test 2', email: 'test-2@lairoflith.com')
      c3 = FactoryGirl.create(:character, user_id: u2.id)
      c4 = FactoryGirl.create(:character, name: 'Samael Bludsturm', user_id: u2.id)
      get 'index'
      assigns(:characters).should eq([c4, c3, c2, c1])
      assigns(:character_total).should eq(4)
    end

    it "populates an array of characters ready for comment, updated_at descending" do
      u1 = FactoryGirl.create(:user)
      c1 = FactoryGirl.create(:character, name: 'A')
      c2 = FactoryGirl.create(:character, name: 'B', status: 'REVIEW')
      c3 = FactoryGirl.create(:character, name: 'C')
      c4 = FactoryGirl.create(:character, name: 'A2', status: 'REVIEW')
      get 'index'
      expect(assigns(:characters_for_comment)).to eq([c4, c2])
    end

    it "does not list hidden characters in either normal or commentable lists" do
      u1 = FactoryGirl.create(:user)
      c1 = FactoryGirl.create(:character, name: 'A')
      c2 = FactoryGirl.create(:character, name: 'B', status: 'REVIEW')
      c3 = FactoryGirl.create(:character, name: 'C', status: 'HIDE')
      get 'index'
      expect(assigns(:characters)).to eq([c2, c1])
      expect(assigns(:characters_for_comment)).to eq([c2])
    end
  end

  describe "POST bbcode" do 
    it "echoes back HTML for valid pure BB code" do
      request.env['HTTP_ACCEPT'] = 'text/plain'
      post 'bbcode', :data => "[b]Strong text.[/b]\n\nSome text."
      response.body.should eq("\n<p><strong>Strong text.</strong></p>\n\n<p>Some text.</p>")
    end

    it "strips tags for any embedded HTML code" do 
      request.env['HTTP_ACCEPT'] = 'text/plain'
      post 'bbcode', :data => "[b]Text.[/b]\n\n<script>alert(1);</script>\n\n<strong>Text.</strong>"
      response.body.should eq("\n<p><strong>Text.</strong></p>\n\n<p>alert(1);Text.</p>")
    end
  end
end
