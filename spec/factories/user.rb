FactoryBot.define do
  factory :user do
    email
    password { "password" }

    before(:create, &:skip_confirmation!)

    trait :organization_approved do
      role { :organization }
      organization_id { create(:organization, :approved).id }
    end

    trait :organization_unapproved do
      role { :organization }
      organization_id { create(:organization).id }
    end

    trait :admin do
      role { :admin }
    end

    trait :organization_admin do
      role { :organization }
    end
  end
end

