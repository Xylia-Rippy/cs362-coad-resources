FactoryBot.define do

    factory :ticket do
      name { "Ticket name" }
      phone {'+1 895-447-2315'}
      closed {false}
      association :region
      association :resource_category
      association :organization

    end

  
  end


          