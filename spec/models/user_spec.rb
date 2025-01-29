require 'rails_helper'

RSpec.describe User, type: :model do

  let (:user) do 
    User.new(
      email: "test@example.com",
      phone: "123-456-7890",
      password: "password",
      role:  nil
    )

    describe "validations" do
      it "is valid with valid attributes" do
        expect(user).to be_valid
      end
  
      it "is invalid without an email" do
        user.email = nil
        expect(user).not_to be_valid
      end
  
      it "is invalid with a malformed email" do
        user.email = "invalid-email"
        expect(user).not_to be_valid
      end
  
      it "is invalid without a password" do
        user.password = nil
        expect(user).not_to be_valid
      end
  
      it "is invalid if the password is too short" do
        user.password = "short"
        expect(user).not_to be_valid
      end
  
      it "is invalid if the email is not unique" do
        # Create a user with the same email
        User.create(email: "test@example.com", password: "password")
        expect(user).not_to be_valid
      end
    end
  
    describe "role" do
      it "assigns the default role to :organization if not set" do
        user.save
        expect(user.role).to eq("organization")
      end
  
      it "allows role to be explicitly set to :admin" do
        user.role = "admin"
        user.save
        expect(user.role).to eq("admin")
      end
    end
  
    describe "associations" do
      it "can belong to an organization" do
        organization = Organization.create(name: "Test Organization")
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
        expect(user.to_s).to eq("test@example.com")
      end
    end

end
