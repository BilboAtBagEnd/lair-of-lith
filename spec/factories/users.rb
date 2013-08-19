# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :unconfirmed_user, class: User do
    name 'Unconfirmed User'
    email 'unconfirmed@lairoflith.com'
    password 'testtest'
    password_confirmation 'testtest'
  end
  factory :user, class: User do
    name 'Test User 1'
    email 'test.user.1@lairoflith.com'
    password 'testtest'
    password_confirmation 'testtest'
    confirmed_at Time.now
  end
  factory :user_other, class: User do
    name 'Test User 2'
    email 'test.user.2@lairoflith.com'
    password 'testtest'
    password_confirmation 'testtest'
    confirmed_at Time.now
  end
end
