require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe "Features for characters" do 

  describe "Index page" do 
    it "shows an empty collection of characteres" do 
      visit '/characters'
      expect(page).to have_xpath('.//h1', text: 'All Characters')
    end

    describe "with characters available" do 
      before(:each) do 
        FactoryGirl.create(:user)

        FactoryGirl.create(:character, name: 'Hidden Character', status: 'HIDE')

        (10..35).each do |i|
          c = FactoryGirl.create(:character, :name => "#{i} Character")
          FactoryGirl.create(:character_version, :character_id => c.id)
        end
      end

      it "shows the first page of characters" do 
        visit '/characters'
        expect(page).to have_content('1 2 Next › Last »')
        expect(page).to have_content('10 Character')
        expect(page).to have_content('34 Character')
        expect(page).to have_no_content('Hidden Character')
      end

      it "shows the second page of characters (no hidden chars)" do 
        visit '/characters?page=2'
        expect(page).to have_content('« First ‹ Prev 1 2')
        expect(page).to have_content('35 Character')
        expect(page).to have_no_content('Hidden Character')
      end

      it "can click on a character link" do 
        visit '/characters'
        click_link('15 Character')
        expect(page).to have_xpath('.//h1', text: '15 Character')
      end
    end
  end

  describe 'View character' do 
    before(:each) do 
      @user = FactoryGirl.create(:user)
      @character = FactoryGirl.create(:character)
      FactoryGirl.create(:character_version)
    end

    it "views a character with 1 version" do
      visit character_path(@user, @character)
      expect(page).to have_xpath('.//h1', text: 'Eleanor Bludsturm')
      expect(page).to have_content('Work in progress')
      expect(page).to have_content('No tags')
      expect(page).to have_content('http://www.boardgamegeek.com/article/1')
      expect(page).to have_content('A title Some words')
      expect(page).to have_xpath('.//strong', text: 'A title')
      expect(page).to have_content('Current Version is 1')
      expect(page).to have_content("Fury: At the beginning of the game, randomly choose another allied character. If that character is killed or imprisoned, deal 1 damage to Eleanor and she becomes a hunter for the character responsible with speed 12, melee 7, power 4. (-10 survival, 10 melee, -10 adventure)")
      expect(page).to have_content('Value Breakdown: Survival: 201.8Ranged: 37Melee: 112.5Adventure: 146TOTAL: 497.3')

      expect(page).to have_no_content('edit')
      expect(page).to have_no_content('Go to comments')
      expect(page).to have_no_selector('#comments')
    end

    it "views a character with 2 versions" do
      FactoryGirl.create(:character_version, version: 2)
      visit character_path(@user, @character)

      expect(page).to have_content('Current Version is 2')
    end

    it "views a character set to REVIEW" do 
      @character.status = 'REVIEW'
      @character.save
      visit character_path(@user, @character)

      expect(page).to have_content('Ready for comments')
      expect(page).to have_content('Go to comments')
      expect(page).to have_selector('#comments')
    end

    it "views a character when logged in as the owner" do 
      login_as(@user, scope: :user)
      visit character_path(@user, @character)

      expect(page).to have_content('edit')
    end

    it "does not show edit links for logged-in non-owners" do 
      u2 = FactoryGirl.create(:user, name: 'Another Baggins', email: 'another@underhill.net')
      login_as(u2, scope: :user)
      visit character_path(@user, @character)

      expect(page).to have_no_content('edit')
    end
  end

end
