FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    phone { "123-456-7890" }
    password { "password" }
    role { :organization }

    trait :admin do
      role { :admin }
    end

    trait :with_organization do
      association :organization
    end
  end
end
