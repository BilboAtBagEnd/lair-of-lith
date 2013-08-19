# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :character do
    name 'A Very Long Name Indeed'
    user_id 1
    description "[b]A title[/b]\r\n\r\nSome words"
    bgg_thread_id 1
  end
end
