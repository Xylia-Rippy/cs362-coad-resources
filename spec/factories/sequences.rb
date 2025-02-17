FactoryBot.define do
  sequence (:email) { |n| "fake#{n}@organization.com"}
  sequence (:name) {  |n| "Faker#{n}"}
end