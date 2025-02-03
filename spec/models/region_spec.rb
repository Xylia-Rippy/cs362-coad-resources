require 'rails_helper'

RSpec.describe Region, type: :model do
  let (:region) { 
  Ticket.new(name: "Unspecified"
  ) }
  it "exists" do
    Region.new

  end

  describe "attribute tests" do
    it "has a name" do
      region = Region.new
      expect(region).to respond_to(:name)
    end

    it "has a string representation that is its name" do
      name = 'Mt. Hood'
      region = Region.new(name: name)
      result = region.to_s
    end

    it "has many tickets" do
      should have_many(:tickets)
    end
  end

  describe "validation tests" do
    it "validates presence of name" do
      expect(region).to validate_presence_of(:name)
    end

    it "validates name length" do
      expect(region).to validate_length_of(:name).is_at_most(255)
      expect(region).to validate_length_of(:name).is_at_least(1)
    end

    it "validates name uniqueness" do
      should validate_uniqueness_of(:name).case_insensitive
    end

  end

  describe "member function tests" do

  it "returns the name as a string" do
    expect(region.to_s).to eq("Test Region")
  end
   # it "self.unspecified" do
    #  expect(region).to eq "Unspecified"
    #end
  end
end
