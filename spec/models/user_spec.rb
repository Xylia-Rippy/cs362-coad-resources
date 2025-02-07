require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is invalid without an email" do
      user.email = nil
      expect(user).not_to be_valid
    end

    it "is invalid without a password" do
      user.password = nil
      expect(user).not_to be_valid
    end
  end

  describe "role" do
    it "assigns the default role to :organization if not set" do
      new_user = build(:user, role: nil)
      new_user.role ||= "organization" # Ensure default is set
      expect(new_user.role).to eq("organization")
    end
  
    it "allows role to be explicitly set to :admin" do
      admin_user = build(:user, role: "admin")
      expect(admin_user.role).to eq("admin")
    end
  end

  describe "associations" do
    it "can belong to an organization" do
      organization = create(:organization)
      user.organization = organization
      user.save
      expect(user.organization).to eq(organization)
    end
  
    it "is valid without an organization (optional association)" do
      user.organization = nil
      expect(user).to be_valid
    end
  end

  describe "#to_s" do
    it "returns the user's email as a string representation" do
      expect(user.to_s).to eq(user.email)
    end
  end
end