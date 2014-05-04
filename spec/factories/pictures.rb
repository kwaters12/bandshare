# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :picture do
    association :album,    :factory => :album
    association :user,     :factory => :user
    caption "MyString"
    description "MyText"
    asset ""
  end
end
