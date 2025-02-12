FactoryBot.define do
    # this is factory is the one you will most likely use
    factory :resource_category, class: 'ResourceCategory' do
      sequence(:name) { |a| "Test ResourceCategory #{a}" }
      active { true }
    end

    factory :inactive_resource_category, class: 'ResourceCategory' do
      sequence(:name) { |a| "Test ResourceCategory #{a}" }
      active { false }
    end
end