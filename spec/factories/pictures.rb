# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :picture do
    album nil
    user nil
    caption "MyString"
    description "MyText"
    asset ""
  end
end
