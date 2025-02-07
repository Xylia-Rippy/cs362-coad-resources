require 'rails_helper'

RSpec.describe ResourceCategory, type: :model do
  

  # let (:resource) { ResourceCategory.new(name: "Test ResourceCategory", active: true) }
  let (:active_resource) { FactoryBot.create(:resource_category) }
  let (:inactive_resource) { FactoryBot.create(:inactive_resource_category) }


  it "exists" do
    ResourceCategory.new
  end

  describe "attribute tests" do
    it "responds to name" do
      expect(active_resource).to respond_to(:name)
    end

    it "responds to active" do
      expect(active_resource).to respond_to(:active)
    end
    it "should have and belong to many organizations" do
      should have_and_belong_to_many(:organizations)
    end

    it "should have many tickets" do
      should have_many(:tickets)
    end
  end

  describe "validation tests" do
    it "validates presence of name" do
      expect(active_resource).to validate_presence_of(:name)
    end

    it "validates name length" do
      should validate_length_of(:name).is_at_most(255)
      should validate_length_of(:name).is_at_least(1)
    end

    it "validates uniqueness of name" do
      create(:resource_category)
      expect(build(:resource_category)).to_not be_valid
    end
  end

  describe "member function tests" do
    it "activates resource" do
      resource = ResourceCategory.new(name: "Test ResourceCategory", active: false)

      resource.activate
      expect(resource.active).to eq(true)
    end

    it "deactivates resource" do
      resource = ResourceCategory.new(name: "Test ResourceCategory", active: true)

      resource.deactivate
      expect(resource.active).to eq(false)
    end

    it "checks if resource is inactive" do
      resource = ResourceCategory.new(name: "Test ResourceCategory", active: true)
      expect(resource.inactive?).to eq(false)

      resource = ResourceCategory.new(name: "Test ResourceCategory", active: false)
      expect(resource.inactive?).to eq(true)
    end

    it "returns the name as a string" do
      expect(active_resource.to_s).to eq("Test ResourceCategory")
    end
  end

  describe "static class functions tests" do
    it "creates and finds unspecified resource" do
      unspecResource = ResourceCategory.unspecified
      expect(unspecResource).to be_a(ResourceCategory)
      expect(unspecResource.name).to eq("Unspecified")
    end
  end

  describe "scope tests" do
    it "scopes active resources" do
      resource = ResourceCategory.create!(name: "Test ResourceCategory", active: true)

      expect(ResourceCategory.active).to include(resource)
      expect(ResourceCategory.inactive).to_not include(resource)
    end

    it "scopes inactive resources" do
      resource = ResourceCategory.create!(name: "Test ResourceCategory", active: false)

      expect(ResourceCategory.active).to_not include(resource)
      expect(ResourceCategory.inactive).to include(resource)
    end
  end
end
