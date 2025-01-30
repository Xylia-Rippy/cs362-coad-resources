require 'rails_helper'

RSpec.describe Ticket, type: :model do

    let (:ticket) { Ticket.new(id: 123) }
    let (:org_ticket){  
    region = Region.create!(name: "region1")
    resource = ResourceCategory.create!(name: "resource2")
    org = Organization.create!(
      name: "test",
      email: "test1@test.edu",
      phone: "+1-648-578-9924",
      status: :approved, 
      primary_name: "test", 
      secondary_name: "tset", 
      secondary_phone: "+1-775-835-1459" 
    )
    Ticket.create!(
      name: "ticket",
      phone: "+1-556-555-1212",
      region_id: region.id,
      resource_category_id: resource.id,
      organization_id: org.id,
      closed: false
    )}
    let (:org_ticket_closed){  
    region = Region.create!(name: "region2")
    resource = ResourceCategory.create!(name: "resource1")
    org = Organization.create!(
      name: "test1",
      email: "test@test.edu",
      phone: "+1-668-578-9924",
      status: :approved, 
      primary_name: "test1", 
      secondary_name: "tset1", 
      secondary_phone: "+1-775-835-1469" 
    )
    Ticket.create!(
      name: "ticket2",
      phone: "+1-555-555-1212",
      region_id: region.id,
      resource_category_id: resource.id,
      organization_id: org.id,
      closed: true

    )}



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


        it "validates name length" do
          expect(ticket).to validate_length_of(:description).is_at_most(1020)
        end

        it "validates presence of phone" do
          expect(ticket).to validate_presence_of(:phone)
        end

        describe "validates if phony_plausible is true" do
          it {should allow_value('+1 895-447-2315').for(:phone)}
          it {should_not allow_value('895-447-2315').for(:phone)}
          it {should_not allow_value('fish').for(:phone)}
        end



      end


    
      describe "member function tests" do
        it "converts to string" do
          expect(ticket.to_s).to eq "Ticket 123"
        end

        it "ticket is open" do
          expect(ticket.open?).to eq true
        end

        it "ticket has an organization" do
          expect(ticket.captured?).to eq false
          expect(org_ticket.captured?).to eq true
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

        it "scopes organization ticket tests" do
          expect(Ticket.organization(org_ticket.organization_id)).to include(org_ticket)
          expect(Ticket.organization(ticket.organization_id)).to_not include(ticket)
        end

        
        it "scopes all_organization ticket tests" do
          expect(Ticket.all_organization()).to include(org_ticket)
          expect(Ticket.all_organization()).to_not include(ticket)
        end

        it "scopes closed_organization ticket tests" do
          expect(Ticket.closed_organization(org_ticket_closed.organization_id)).to include(org_ticket_closed)
          expect(Ticket.closed_organization(org_ticket.organization_id)).to_not include(org_ticket)
        end

        it "scopes region ticket tests" do
          expect(Ticket.region(org_ticket.region_id)).to include(org_ticket)
          expect(Ticket.region(org_ticket_closed.region_id)).to include(org_ticket_closed)
        end

        it "scopes resource_category ticket tests" do
          expect(Ticket.resource_category(org_ticket.resource_category)).to include(org_ticket)
          expect(Ticket.resource_category(org_ticket_closed.resource_category)).to include(org_ticket_closed)
        end

      end
end
