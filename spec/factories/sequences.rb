FactoryBot.define do
  sequence :email do |n|
    "fake#{n}@factory.com"
  end

  sequence :name do |n|
    "fake_#{n}"
  end
end