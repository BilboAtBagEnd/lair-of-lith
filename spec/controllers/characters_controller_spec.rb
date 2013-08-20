require 'spec_helper'

describe CharactersController do
  describe "GET new" do 
    it "renders the new template" do
      get :new
      expect(response).to render_template('new')
    end
    it "sets the new flag" do 
      get :new
      expect(assigns(:is_new)).to be_true
    end
  end

  describe "GET index" do 
    it "renders the index template" do
      get :index
      expect(response).to render_template('index')
    end

    it "sets up the first page of characters on no page being passed in" do
      get :index
      expect(assigns(:page)).to eq(1)
    end

    it "uses the passed-in page if present" do 
      get :index, :page => 2
      expect(assigns(:page)).to eq(2)
    end

    it "gets the first page of characters in character name, user name order" do 
      u1 = FactoryGirl.create(:user, :name => 'A Baggins Under the Hill', :email => 'underhill@lairoflith.com')
      u2 = FactoryGirl.create(:user, :name => 'Bagginses', :email => 'baggins@lairoflith.com')

      c_u1 = []
      c_u2 = []
      (10..35).each do |i|
        c_u1.push FactoryGirl.create(:character, :user_id => 1, :name => "#{i} Character")
      end
      (10..35).each do |i| # do as a second loop so that we aren't tricked by sorting via created date.
        c_u2.push FactoryGirl.create(:character, :user_id => 2, :name => "#{i} Character")
      end

      get :index
      expect(assigns(:characters).to_a).to eq([
        c_u1[0], c_u2[0], 
        c_u1[1], c_u2[1], 
        c_u1[2], c_u2[2], 
        c_u1[3], c_u2[3], 
        c_u1[4], c_u2[4], 
        c_u1[5], c_u2[5], 
        c_u1[6], c_u2[6], 
        c_u1[7], c_u2[7], 
        c_u1[8], c_u2[8], 
        c_u1[9], c_u2[9], 
        c_u1[10], c_u2[10], 
        c_u1[11], c_u2[11], 
        c_u1[12]
      ])
    end

    it "gets the second page of characters in character name, user name order" do 
      u1 = FactoryGirl.create(:user, :name => 'A Baggins Under the Hill', :email => 'underhill@lairoflith.com')
      u2 = FactoryGirl.create(:user, :name => 'Bagginses', :email => 'baggins@lairoflith.com')

      c_u1 = []
      c_u2 = []
      (10..35).each do |i|
        c_u1.push FactoryGirl.create(:character, :user_id => 1, :name => "#{i} Character")
      end
      (10..35).each do |i| # do as a second loop so that we aren't tricked by sorting via created date.
        c_u2.push FactoryGirl.create(:character, :user_id => 2, :name => "#{i} Character")
      end

      get :index, :page => 2
      expect(assigns(:characters).to_a).to eq([
                  c_u2[12],
        c_u1[13], c_u2[13], 
        c_u1[14], c_u2[14], 
        c_u1[15], c_u2[15], 
        c_u1[16], c_u2[16], 
        c_u1[17], c_u2[17], 
        c_u1[18], c_u2[18], 
        c_u1[19], c_u2[19], 
        c_u1[20], c_u2[20], 
        c_u1[21], c_u2[21], 
        c_u1[22], c_u2[22], 
        c_u1[23], c_u2[23], 
        c_u1[24], c_u2[24]
      ])
    end
  end

  describe "GET view" do
    before(:each) do 
      @user = FactoryGirl.create(:user)
      @character = FactoryGirl.create(:character)
    end

    context "Valid requests" do 
      it "renders the view template" do
        get :view, :uid => @user.slug, :cid => @character.slug
        expect(response).to render_template('view')
      end

      it "sets the owner and character variables" do 
        get :view, :uid => @user.slug, :cid => @character.slug
        expect(assigns(:owner)).to eq(@user)
        expect(assigns(:character)).to eq(@character)
      end

      it "sets the versions" do 
        version = FactoryGirl.create(:character_version)
        get :view, :uid => @user.slug, :cid => @character.slug
        expect(assigns(:versions)).to eq([version])
      end

      it "sets the newest version and associated variables" do
        v1 = FactoryGirl.create(:character_version)
        v5 = FactoryGirl.create(:character_version, version: 5)
        v3 = FactoryGirl.create(:character_version, version: 3)
        v2 = FactoryGirl.create(:character_version, version: 2)
        get :view, :uid => @user.slug, :cid => @character.slug
        expect(assigns(:newest_version)).to eq(v5)
        expect(assigns(:csv)[:name]).to eq('Eleanor Bludsturm')
        expect(assigns(:value)[:total]).to eq(497.3)
      end
    end

    context "Non-authorized requests" do 
      it "sets the current_user_is_owner to false" do
        get :view, :uid => @user.slug, :cid => @character.slug
        expect(assigns(:current_user_is_owner)).to be_false
      end
    end

    context "Authorized requests" do 
      setup_devise

      it "sets the current_user_is_owner to true if the owner is the current user" do
        sign_in @user
        get :view, :uid => @user.slug, :cid => @character.slug
        expect(assigns(:current_user_is_owner)).to be_true
      end

      it "sets the current_user_is_owner to false if the owner is not the current user" do 
        user = FactoryGirl.create(:user, :name => 'Something Else', :email => 'something@else.com')
        sign_in user
        get :view, :uid => @user.slug, :cid => @character.slug
        expect(assigns(:current_user_is_owner)).to be_false
      end
    end

    context "Invalid requests" do
      it "detects that a user doesn't exist" do 
        expect {get :view, :uid => 'nothing', :cid => @character.slug}.to raise_error
      end

      it "detects that a character doesn't exist for that user" do
        user = FactoryGirl.create(:user, :name => 'Some Baggins', :email => 'some_baggins@somewhere.com')
        expect {get :view, :uid => user.slug, :cid => @character.slug}.to raise_error
      end
    end
  end

  describe "GET generate" do
    before(:each) do 
      @user = FactoryGirl.create(:user)
      @character = FactoryGirl.create(:character)
      @version = FactoryGirl.create(:character_version)
    end

    context "Valid requests" do 
      it "renders the generate template" do
        get :generate, :uid => @user.slug, :cid => @character.slug, :version => 1
        expect(response).to render_template('generate')
      end

      it "sets the owner, character, and version variables" do 
        get :generate, :uid => @user.slug, :cid => @character.slug, :version => 1
        expect(assigns(:owner)).to eq(@user)
        expect(assigns(:character)).to eq(@character)
        expect(assigns(:version)).to eq(@version)
      end
    end

    context "Non-authorized requests" do 
      it "sets the current_user_is_owner to false" do
        get :generate, :uid => @user.slug, :cid => @character.slug, :version => 1
        expect(assigns(:current_user_is_owner)).to be_false
      end
    end

    context "Authorized requests" do 
      setup_devise

      it "sets the current_user_is_owner to true if the owner is the current user" do
        sign_in @user
        get :generate, :uid => @user.slug, :cid => @character.slug, :version => 1
        expect(assigns(:current_user_is_owner)).to be_true
      end

      it "sets the current_user_is_owner to false if the owner is not the current user" do 
        user = FactoryGirl.create(:user, :name => 'Something Else', :email => 'something@else.com')
        sign_in user
        get :generate, :uid => @user.slug, :cid => @character.slug, :version => 1
        expect(assigns(:current_user_is_owner)).to be_false
      end
    end

    context "Invalid requests" do
      it "detects that a user doesn't exist" do 
        expect {get :generate, :uid => 'nothing', :cid => @character.slug, :version => 1}.to raise_error
      end

      it "detects that a character doesn't exist for that user" do
        user = FactoryGirl.create(:user, :name => 'Some Baggins', :email => 'some_baggins@somewhere.com')
        expect {get :generate, :uid => user.slug, :cid => @character.slug, :version => 1}.to raise_error
      end

      it "detects that a version doesn't exist for a given character" do 
        expect {get :generate, :uid => @user.slug, :cid => @character.slug, :version => 2}.to raise_error
      end
    end
  end

  describe "POST save" do 
    context "Non-authorized requests" do 
      it "will not handle the request" do 
        post :save, :name => 'A Name', :csv => 'Some CSV'
        expect(response).to redirect_to '/users/sign_in'
      end
    end

    context "Authorized requests" do 
      setup_devise

      before(:each) do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "sets the user" do 
        post :save, :name => 'A Name', :csv => 'Some CSV'
        expect(assigns(:user)).to eq(@user)
      end

      context "Character does not exist for user" do
        it "creates a new character and first version" do
          post :save, :name => 'A Name', :csv => 'Some CSV'

          character = assigns(:character)
          expect(character.user_id).to eq(@user.id)
          expect(character.name).to eq('A Name')
          expect(character.id).to be

          version = assigns(:character_version)
          expect(version.character_id).to eq(character.id)
          expect(version.version).to eq(1)
          expect(version.csv).to eq('Some CSV')
        end

        it "redirects to the generate page" do 
          post :save, :name => 'A Name', :csv => 'Some CSV'
          expect(response).to redirect_to '/users/test-user-1/characters/a-name/1/generate'
        end
      end

      context "Character exists for user" do
        before(:each) do 
          @character = FactoryGirl.create(:character)
          @version = FactoryGirl.create(:character_version)
        end

        it "creates a new version" do
          post :save, :name => @character.name, :csv => 'Some CSV'

          character = assigns(:character)
          expect(character).to eq(@character)

          version = assigns(:character_version)
          expect(version.character_id).to eq(character.id)
          expect(version.version).to eq(@version.version + 1)
          expect(version.csv).to eq('Some CSV')
        end

        it "redirects to the generate page" do 
          post :save, :name => @character.name, :csv => 'Some CSV'
          expect(response).to redirect_to '/users/test-user-1/characters/a-very-long-name-indeed/2/generate'
        end
      end
    end
  end

  describe "POST save_data" do
    setup_devise
    before(:each) do 
      @user = FactoryGirl.create(:user)
      @character = FactoryGirl.create(:character)
    end

    context "Non-authorized requests" do 
      it "will not handle the request" do 
        post :save_data, :uid => @user.slug, :cid => @character.slug
        expect(response).to redirect_to '/users/sign_in'
      end
    end

    context "Wrong user logged in" do 
      it "will not handle the request" do 
        user = FactoryGirl.create(:user, :name => 'Another Name', :email => 'another@name.com')
        sign_in user
        expect {post :save_data, :uid => @user.slug, :cid => @character.slug, :character => { :bgg_thread_id => 1 }}.to raise_error
      end
    end

    context "Authorized requests" do 
      before(:each) do 
        sign_in @user
      end

      it "detects that the character does not exist for the user" do
        expect {post :save_data, :uid => @user.slug, :cid => 'nothing', :character => { :bgg_thread_id => 1 }}.to raise_error
      end

      it "updates the thread id" do 
        post :save_data, :uid => @user.slug, :cid => @character.slug, :character => { :bgg_thread_id => 1 }
        character = Character.find @character.id
        expect(character.bgg_thread_id).to eq(1)
      end

      it "updates the description" do 
        post :save_data, :uid => @user.slug, :cid => @character.slug, :character => { :description => "[b]Strong[/b]\n\n<script>alert(1)</script>"}
        character = Character.find @character.id
        expect(character.description).to eq("[b]Strong[/b]\n\nalert(1)")
      end

      it "redirects to the character page" do
        post :save_data, :uid => @user.slug, :cid => @character.slug, :character => {:bgg_thread_id => 1}
        expect(response).to redirect_to('/users/test-user-1/characters/a-very-long-name-indeed')
      end
    end
  end
end
