FactoryBot.define do

    factory :ticket do
      id {"123"}
      name { "Ticket 123" }
      phone {'+1 895-447-2315'}
      closed {false}
      association :region
      association :active_resource_category
      association :organization 

    end

  
  end


          