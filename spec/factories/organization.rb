FactoryBot.define do
  factory :organization do
    name { "Test Organization" }
    status { :submitted }
    phone { "123-456-7890" }
    email { "test@example.com" }
    description { "Test description" }
    rejection_reason { nil }
    liability_insurance { false }
    primary_name { "Primary Contact" }
    secondary_name { "Secondary Contact" }
    secondary_phone { "987-654-3210" }
    title { "Manager" }
    transportation { :yes }
  
    trait :approved do
      status { :approved }
    end

    trait :rejected do
      status { :rejected }
    end

    trait :locked do
      status { :locked }
    end
  end
end