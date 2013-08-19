require 'spec_helper'

describe User do
  it "creates successfully" do
    user = FactoryGirl.create(:user)
    user.should be
    user.id.should be
  end

  it "checks for presence of name" do 
    user = FactoryGirl.build(:user)
    user.name = nil
    expect {user.save!}.to raise_error
  end

  it "checks for presence of email" do 
    user = FactoryGirl.build(:user)
    user.email = nil
    expect {user.save!}.to raise_error
  end

  it "checks for uniqueness of email" do 
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.build(:user)
    user2.name = 'Other Name'
    expect {user2.save!}.to raise_error
  end

  it "checks for uniqueness of name" do 
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.build(:user)
    user2.email = 'other@lairoflith.com'
    expect {user2.save!}.to raise_error
  end

  it "interprets uniqueness of name as case-insensitive" do 
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.build(:user)
    user2.name.upcase!
    expect {user2.save!}.to raise_error
  end

  it "interprets uniqueness of email as case-insensitive" do 
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.build(:user)
    user2.email.upcase!
    expect {user2.save!}.to raise_error
  end

  it "has a slug on creation" do
    user = FactoryGirl.create(:user)
    user.slug.should be
    user.slug.empty?.should be_false
  end

  it "changes slugs on case-insensitive name change" do
    user = FactoryGirl.create(:user)
    first_slug = user.slug
    user.name += '-New'
    user.save!
    user.slug.should_not be == first_slug
  end

  it "does not change slug on case-insensitive name change" do
    user = FactoryGirl.create :user
    first_slug = user.slug
    user.name = user.name.upcase
    user.save!
    user.slug.should be == first_slug
  end

  it "does not change slug on non-name changes" do 
    user = FactoryGirl.create :user
    first_slug = user.slug
    refreshed_user = User.find user.id
    refreshed_user.email = 'new-email@example.com'
    refreshed_user.save!
    refreshed_user.slug.should be == first_slug
  end
end
