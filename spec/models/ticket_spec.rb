require 'rails_helper'

RSpec.describe Ticket, type: :model do

    let (:ticket) { Ticket.new }

    it "exists" do
        Ticket.new
      end
    describe "attribute tests" do
        it "responds to name" do
        expect(ticket).to respond_to(:name)
            end

        it "responds to description" do
            expect(ticket).to respond_to(:description)
            end

        it "responds to phone" do
            expect(ticket).to respond_to(:phone)
            end 

        it "responds if closed exists" do
            expect(ticket).to respond_to(:closed)
            end 

        it "responds if closed time exists" do
            expect(ticket).to respond_to(:closed_at)
            end 

        it "Belongs to region" do
            should belong_to(:region)
            end

        it "Belongs to resource category" do
            should belong_to(:resource_category)
            end

        it "Belongs to organization" do
            should belong_to(:organization).optional
            end
    end
    
    describe "validation tests" do
        it "validates presence of name" do
          expect(ticket).to validate_presence_of(:name)
        end
    
        it "validates name length" do
          expect(ticket).to validate_length_of(:name).is_at_most(255)
          expect(ticket).to validate_length_of(:name).is_at_least(1)
        end
      end
    
      describe "member function tests" do
        it "converts to string" do
          expect(ticket.to_s).to eq "Ticket 123"
        end
      end
    
      describe "scope tests" do
        it "scopes closed tickets" do
          region = Region.create!(name: "region1")
          resource = ResourceCategory.create!(name: "resource1")
    
          ticket = Ticket.create!(
            name: "ticket",
            phone: "+1-555-555-1212",
            region_id: region.id,
            resource_category_id: resource.id,
            closed: true
          )
    
          # How we look at scopes:
          #Ticket.closed
          #Ticket.open
    
          expect(Ticket.closed).to include(ticket)
          expect(Ticket.open).to_not include(ticket)
        end
      end
        

end
