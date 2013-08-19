require 'spec_helper'

describe CharacterVersion do
  it "saves successfully" do
    cv = FactoryGirl.create(:character_version)
    cv.id.should be
  end

  it "validates presence of character_id" do
    cv = FactoryGirl.build(:character_version)
    cv.character_id = nil
    expect {cv.save!}.to raise_error
  end

  it "validates presence of version" do
    cv = FactoryGirl.build(:character_version)
    cv.version = nil
    expect {cv.save!}.to raise_error
  end

  it "validates presence of csv" do
    cv = FactoryGirl.build(:character_version)
    cv.csv = nil
    expect {cv.save!}.to raise_error
  end

  it "validates uniqueness of version within scope of character_id" do
    cv1 = FactoryGirl.create(:character_version)
    cv2 = FactoryGirl.build(:character_version)
    expect {cv2.save!}.to raise_error
  end

  it "allows duplicates of versions outside of character_ids" do 
    cv1 = FactoryGirl.create(:character_version)
    cv2 = FactoryGirl.build(:character_version)
    cv2.character_id = 2
    cv2.save!
    cv2.id.should be
  end
end
