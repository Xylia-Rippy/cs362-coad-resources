
FactoryBot.define do
  factory :ticket do
    #id { "123" }
    sequence(:name) { |n| "Ticket#{n}" } 
    phone { "+1 800-555-1234" }
    closed { false }
    description { "Sample emergency assistance request" }
    association :region
    association :resource_category
    association :organization
  end

  factory :ticket_without_organization, parent: :ticket do
    #id { "123" }
    sequence(:name) { |n| "Ticket#{n}" } 
    phone { "+1 800-555-1234" }
    closed { false }
    description { "Sample emergency assistance request" }
    association :region
    association :resource_category
    organization { nil }
  end
end