require 'spec_helper'

describe Character do
  it "creates successfully" do 
    character = FactoryGirl.create(:character)
    character.should be
    character.id.should be
  end

  it "checks for presence of name" do 
    character = FactoryGirl.build(:character)
    character.name = nil
    expect {character.save!}.to raise_error
  end

  it "checks for presence of user_id" do 
    character = FactoryGirl.build(:character)
    character.user_id = nil
    expect {character.save!}.to raise_error
  end

  it "checks for uniquness of name in scope of user_id" do 
    c1 = FactoryGirl.create(:character)
    c2 = FactoryGirl.build(:character)
    expect {c2.save!}.to raise_error
  end

  it "accepts duplicate names across different user_ids" do 
    c1 = FactoryGirl.create(:character)
    c2 = FactoryGirl.build(:character)
    c2.user_id = 2
    c2.save!
    c2.id.should be
  end

  it "has a slug on creation" do 
    c = FactoryGirl.create(:character)
    c.slug.should be
    c.slug.empty?.should be_false
  end

  it "changes slugs on case-insensitive name change" do 
    c = FactoryGirl.create(:character)
    first_slug = c.slug
    c.name += '-New'
    c.save!
    c.slug.should_not be == first_slug
  end

  it "does not change slug on case-insensitive name change" do 
    c = FactoryGirl.create(:character)
    first_slug = c.slug
    c.name = c.name.upcase
    c.save!
    c.slug.should be == first_slug
  end

  it "does not change slug on non-name changes" do 
    c = FactoryGirl.create(:character)
    first_slug = c.slug
    refreshed_c = Character.find c.id
    refreshed_c.description = '[i]Some words[/i]'
    refreshed_c.save!
    refreshed_c.slug.should be == first_slug
  end

  it "does not require description or thread id" do 
    c = FactoryGirl.build(:character)
    c.description = nil
    c.bgg_thread_id = nil
    c.save!
    c.id.should be
  end

  it "sets status to the accepted values" do 
    c = FactoryGirl.create(:character)
    c.status = 'WIP'
    expect(c.status).to eq('WIP')
    c.status = 'REVIEW'
    expect(c.status).to eq('REVIEW')
    c.status = 'HIDE'
    expect(c.status).to eq('HIDE')
  end

  it "does not set status to unknown values" do
    c = FactoryGirl.create(:character)
    expect {c.status = 'ILLEGAL'}.to raise_error
  end

  it "translates to full status readily" do 
    c = FactoryGirl.create(:character)
    expect(c.full_status_name).to eq('Work in progress')
    c.status = 'REVIEW'
    expect(c.full_status_name).to eq('Ready for comments')
  end

  it "defaults status to WIP" do 
    c = FactoryGirl.build(:character)
    expect(c.status).to eq('WIP')
  end

  it "locates everything with a particular status" do
    c1 = FactoryGirl.create(:character, name: 'C1', status: 'WIP')
    c2 = FactoryGirl.create(:character, name: 'C2', status: 'REVIEW')
    c3 = FactoryGirl.create(:character, name: 'C3', status: 'REVIEW')
    c4 = FactoryGirl.create(:character, name: 'C4', status: 'WIP')
    expect(Character.find_by_status('WIP').order('id desc').to_a).to eq([c4,c1])
  end
end
