require 'spec_helper'

describe User do
  it "creates successfully" do
    user = FactoryGirl.create(:user)
    user.should be
  end

  it "has a slug on creation" do
    user = FactoryGirl.create(:user)
    user.slug.should be
    user.slug.empty?.should be_false
  end

  it "changes slugs on case-insensitive name change" do
    user = FactoryGirl.create(:user)
    first_slug = user.slug
    user.name = user.name + '-New'
    user.save!
    user.slug.should be
    user.slug.empty?.should be_false
    user.slug.should_not be == first_slug
  end

  it "does not change slug on case-insensitive name change" do
    user = FactoryGirl.create :user
    first_slug = user.slug
    user.name = user.name.upcase
    user.save!
    user.slug.should be
    user.slug.empty?.should be_false
    user.slug.should be == first_slug
  end
end
