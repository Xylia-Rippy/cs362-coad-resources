require 'rails_helper'

RSpec.describe Organization, type: :model do
  let(:organization) { build(:organization) }

  it "exists" do
    expect(build(:organization)).to be_a(Organization)
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(organization).to be_valid
    end

    it "is invalid without a name" do
      organization.name = nil
      expect(organization).to_not be_valid
    end

    it "is invalid without an email" do
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
      organization.email = "a" * 245 + "@example.com" # Adjusting for realistic limit
      expect(organization).to_not be_valid
    end

    it "validates the uniqueness of email" do
      existing_organization = create(:organization)
      new_organization = build(:organization, email: existing_organization.email)
      expect(new_organization).to_not be_valid
    end

    it "validates the uniqueness of name" do
      existing_organization = create(:organization)
      new_organization = build(:organization, name: existing_organization.name)
      expect(new_organization).to_not be_valid
    end

    it "validates the length of description" do
      organization.description = "a" * 1025 # Ensuring it exceeds limit
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
    it "sets default status to submitted for new records" do
      new_org = build(:organization, status: nil)
      expect(new_org.status).to eq("submitted")
    end
  end

  describe "methods" do
    it "approves the organization" do
      organization.update(status: :approved)
      expect(organization.status).to eq("approved")
    end

    it "rejects the organization" do
      organization.update(status: "rejected")
      expect(organization.status).to eq("rejected")
    end

    it "returns the name as a string" do
      expect(organization.to_s).to eq(organization.name)
    end
  end
end
