require 'rails_helper'

RSpec.describe Organization, type: :model do
  
  let (:organization) do
    Organization.new(
      name: "Test Organization",
      status: :submitted,
      phone: "123-456-7890",
      email: "test@example.com",
      description: "Test description",
      rejection_reason: nil,
      liability_insurance: false,
      primary_name: "Primary Contact",
      secondary_name: "Secondary Contact",
      secondary_phone: "987-654-3210",
      title: "Manager",
      transportation: :yes
      )

  it "exists" do
    Organization.new
  end

  describe "validations" do
    it "is valid with valid attrabutes" do
      expect(organization).to be_valid
    end

    it "is invalid without a name" do
      organization.name = nil
      expect(organization).to_not be_valid
    end

    it "is invalid without a email" do
      organization.email = nil
      expect(organization).to_not be_valid
    end

    it "is invalid without a phone" do
      organization.phone = nil
      expect(organization).to_not be_valid
    end

    it "is invalid without a primary_name" do
      organization.primary_name = nil
      expect(organization).to_not be_valid
    end

    it "is invalid without a secondary_name" do
      organization.secondary_name = nil
      expect(organization).to_not be_valid
    end

    it "validates the length of email" do
      organization.email = "a" *256 +"@example.com"
      expect(organization).to_not be_valid
    end

    it "validates the uniqueness of email" do
      Organization.create!(
        name: "Another Organization",
        phone: "123-555-6789",
        email: "test@example.com",
        primary_name: "Primary",
        secondary_name: "Secondary",
        secondary_phone: "123-555-1234",
        status: :submitted,
        transportation: :yes
      )
      expect(organization).to_not be_valid
    end
  

    it "validates the uniqueness of name" do
      create(:organization, name: organization.name)
      expect(organization).to_not be_valid
    end

   it "validates the length of description" do
      organization.description = "a" * 1021
      expect(organization).to_not be_valid
    end
  end


  describe "associations" do
    it { should have_many(:users) }
    it { should have_many(:tickets) }
    it { should have_and_belong_to_many(:resource_categories) }
  end

  describe "enums" do
    it "defines status as an enum with expected values" do
      expect(Organization.statuses.keys).to match_array(["approved", "submitted", "rejected", "locked"])
    end

    it "defines transportation as an enum with expected values" do
      expect(Organization.transportations.keys).to match_array(["yes", "no", "maybe"])
    end
  end

  describe "callbacks" do
    it "sets defult status to submitted for new records" do
      new_org = Organization.new
      expect(new_org.status).to eq("submitted")
    end
  end

  describe "methods" do
    it "approves the organization" do
      organization.approve
      expect(organization.status).to eq("approved")
    end

    it "rejects the organization" do
      organization.reject
      expect(organization).to eq("rejected")
    end

    it "returns the name as a string" do
      expect(organization.to_s).to eq("Test Organization")
    end
  end

end
end
