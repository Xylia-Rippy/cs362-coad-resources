require 'rails_helper'

RSpec.describe Organization, type: :model do

    let (:org) { Organization.new }

    it "exists" do
        Organization.new
    end

    it "responds to name" do
        expect(org).to respond_to(:name)
    end

    it "has many users" do
        should have_many(:users)
    end

end
