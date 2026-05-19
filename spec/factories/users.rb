FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    sequence(:name) { |n| "User #{n}" }
    role { :normal }

    trait :admin do
      role { :admin }
    end

    trait :viewer do
      role { :viewer }
    end
  end
end
