# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name    Faker::Name.first_name
    last_name     Faker::Name.last_name
    profile_name  Faker::Name.name
    sequence(:email){ |n| "#{n}#{Faker::Internet.email}"}
    password   "password"
  end
end
