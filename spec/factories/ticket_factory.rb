FactoryBot.define do
  factory :ticket do
    sequence(:name) { |n| "Ticket#{n}" }
    phone { "+1 800-555-1234" }
    closed { false }
    description { "Sample emergency assistance request" }
    association :region
    association :resource_category
    association :organization

    #added opened trait
    trait :open do
      closed { false }
    end

    #added closed trait
    trait :closed do
      closed { true }
    end

    #added captured trait 
    trait :captured do 
      association :organization
    end
  end

  factory :ticket_without_organization, parent: :ticket do #made it into it's oen factory but having a parent.
    organization { nil }
  end
end
