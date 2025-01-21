require 'rails_helper'

RSpec.describe Organization, type: :model do
  
  let (:org) { Organization.new }

  it "exists" do
    Organization.new
  end

  it "responds to name" do
    expect(org).to respond_to(:name)
  end

  it "responds to status" do
    expect(org).to respond_to(:status)
  end

  it "responds to phone" do
    expect(org).to respond_to(:phone)
  end

  it "responds to email" do
    expect(org).to respond_to(:email)
  end

  it "responds to description" do
    expect(org).to respond_to(:description)
  end

  it "has many users" do
    should have_many(:users)
  end

  it "has many tickets" do
    should have_many(:tickets)
  end


end
