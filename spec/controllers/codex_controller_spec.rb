require 'spec_helper'

describe CodexController do

  describe 'GET index' do
    it "renders the index template" do 
      get :index
      expect(response).to render_template('index')
    end

    it "creates a list of unique official characters" do
      get :index
      characters = assigns(:characters)
      expect(characters.size).to eq(197)
      expect((characters.uniq {|c| c.name}).size).to eq(197)
    end
  end

  describe 'GET character' do 
    it "renders the character template" do 
      get :character, name: 'A Pile of Weewaks'
      expect(response).to render_template('character')
    end

    it "sets the character variable appropriately" do
      get :character, name: 'A Pile of Weewaks'
      character = assigns(:character)
      expect(character).to be
      expect(character.name).to eq('A Pile of Weewaks')
    end

    it "transliterates + to spaces" do 
      get :character, name: 'Clara+Barton'
      character = assigns(:character)
      expect(character).to be
      expect(character.name).to eq('Clara Barton')
    end
  end

  describe 'GET search' do 
    it "renders the search template" do 
      get :search
      expect(response).to render_template('search')
    end
  end
end
