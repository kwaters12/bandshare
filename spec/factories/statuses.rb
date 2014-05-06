# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :status do
    association :user,     :factory => :user
    content "MyString"
  end
end
