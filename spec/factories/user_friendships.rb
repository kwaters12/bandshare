# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_friendship do
    association :user, factory: :user
    association :friend, factory: :user

    factory :pending_user_friendship do
      state 'pending'
    end

    factory :requested_user_friendship do
      state 'requested'
    end

    factory :accepted_user_friendship do
      state 'accepted'
    end
    
    factory :blocked_user_friendship do
      state 'blocked'
    end
  end
end
