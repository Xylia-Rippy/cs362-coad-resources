require 'rails_helper'

RSpec.describe ResourceCategory, type: :model do

  let (:resource) { ResourceCategory.new }

  it "exists" do
    ResourceCategory.new
  end

  it "responds to name" do
    expect(resource).to respond_to(:name)
  end

  it "responds to active" do
    expect(resource).to respond_to(:active)
  end

  it "should have and belong to many organizations" do
    should have_and_belong_to_many(:organizations)
  end

  it "should have many tickets" do
    should have_many(:tickets)
  end

end
