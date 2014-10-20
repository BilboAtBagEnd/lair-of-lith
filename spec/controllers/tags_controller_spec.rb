require 'spec_helper'

describe TagsController, :type => :controller do
  before(:each) do 
    c1 = FactoryGirl.create(:character, name: 'Sherlock Holmes')
    c2 = FactoryGirl.create(:character, name: 'Catwoman')
    c3 = FactoryGirl.create(:character, name: 'Bast')
    c4 = FactoryGirl.create(:character, name: 'Batman')

    c1.tag_list = 'detectives, sherlock holmes'
    c2.tag_list = 'batman, cats'
    c3.tag_list = 'egyptian gods, deities, cats'
    c4.tag_list = 'batman, detectives'

    c1.save!
    c2.save!
    c3.save!
    c4.save!
  end

  describe "GET index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template('index')
    end

    it "sets the character tags ordered by name" do 
      get :index
      tag_names = assigns(:character_tags).map { |t| t.name }
      expect(tag_names).to eq(['batman', 'cats', 'deities', 'detectives', 'egyptian gods', 'sherlock holmes'])
    end
  end

  describe "GET view" do
    it "renders the view template" do 
      get :view, :tag => 'batman'
      expect(response).to render_template('view')
    end

    it "sets the tag" do 
      get :view, :tag => 'batman'
      expect(assigns(:tag)).to eq('batman')
    end

    it "sets the characters" do 
      get :view, :tag => 'batman'
      expect(assigns(:characters)).to eq([Character.find(4), Character.find(2)])
    end

    it "deals with non-existing tags" do
      get :view, :tag => 'dogs'
      expect(assigns(:characters).size).to eq(0)
    end
  end
end
