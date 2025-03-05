FactoryBot.define do
  factory :organization do
    sequence(:name)  { |n| "Test Organization #{n}" }  # Ensure unique name
    sequence(:email) { |n| "test#{n}@example.com" }    # Ensure unique email

    status                { :submitted }  # Default status (submitted)
    phone                 { "123-456-7890" }
    description           { "a" * 1000 }  # Matches validation constraints
    rejection_reason      { nil }
    liability_insurance   { false }
    primary_name         { "Primary Contact" }
    secondary_name       { "Secondary Contact" }
    secondary_phone      { "987-654-3210" }
    title                { "Manager" }
    transportation       { 1 }  # Matches schema integer representation

    trait :approved do
      status { :approved }
    end

    trait :rejected do
      status { :rejected }
    end

    trait :locked do
      status { :locked }
    end

    trait :submitted do
      status { :submitted }
    end

    after(:build) { |organization| organization.status ||= 1 }
  end
end
