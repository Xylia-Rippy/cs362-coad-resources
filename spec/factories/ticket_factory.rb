FactoryBot.define do

    factory :ticket do
      name { "Ticket name" }
      phone {'+1 895-447-2315'}
      closed {false}
      resource_category_id { FactoryBot.resource_category}
      organization_id {FactoryBot.organization}
      region_id {FactoryBot.region}

    end

  
  end