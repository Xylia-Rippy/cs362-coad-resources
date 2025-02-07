FactoryBot.define do
    # this is factory is the one you will most likely use
    factory :resource_category, class: 'ResourceCategory' do
      name { "Test ResourceCategory" }
      active { true }
    end

    factory :inactive_resource_category, class: 'ResourceCategory' do
      name { "Test ResourceCategory" }
      active { false }
    end
end