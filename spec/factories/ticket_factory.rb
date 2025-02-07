FactoryBot.define do

    factory :ticket do
      id {"123"}
      name { "Ticket 123" }
      phone {'+1 895-447-2315'}
      closed {false}
      association :region
      association :resource_category
      association :organization 

    end

    factory :ticket_without_organization do
      id {"123"}
      name { "Ticket 123" }
      phone {'+1 895-447-2315'}
      closed {false}
      association :region
      association :resource_category
      organization_id {nil}
    end

  
  end

