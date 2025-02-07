FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" } # Ensure unique email
    password { "password" }
    role { 1 }

    trait :admin do
      role { 0 }
    end

    trait :with_organization do
      association :organization
    end
  end
end