FactoryBot.define do
  factory :organization do
    sequence(:name) { |n| "Test Organization #{n}" } # Ensure unique name
    status { 1 } # Aligning with integer status from schema
    phone { "123-456-7890" }
    sequence(:email) { |n| "test#{n}@example.com" } # Ensure unique email
    description { "a" * 1000 } # Adjust description length to fit within validation constraints
    rejection_reason { nil }
    liability_insurance { false }
    primary_name { "Primary Contact" }
    secondary_name { "Secondary Contact" }
    secondary_phone { "987-654-3210" }
    title { "Manager" }
    transportation { 1 } # Aligning with integer transportation from schema

    trait :approved do
      status { 0 }
    end

    trait :rejected do
      status { 2 }
    end

    trait :locked do
      status { 3 }
    end

    after(:build) do |organization|
      organization.status ||= 1 # Default status to submitted if not set
    end
  end
end
