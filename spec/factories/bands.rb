# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :band do
    name "MyString"
    genres "MyText"
    links "MyText"
    address "MyString"
  end
end
