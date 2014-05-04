FactoryGirl.define do
  factory :album do
    association :user,     :factory => :user    
    title Faker::Company.catch_phrase
  end
end
