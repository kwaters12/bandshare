# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :instrument do
    name "MyString"
    description "MyText"
    available false
    price 1.5
    user nil
    document nil
  end
end
