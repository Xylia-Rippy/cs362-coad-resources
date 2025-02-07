require 'rails_helper'

RSpec.describe Ticket, type: :model do
    let (:ticket) { FactoryBot.build(:ticket) }

    



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
          ticket = = FactoryBot.build_stubbed(:ticket, organization_id: nil)
          organization = FactoryBot.build_stubbed(:organization, name: "organization1")
          org_ticket = FactoryBot.build_stubbed(:ticket, organization_id: organization)
          expect(ticket.captured?).to eq false
          expect(org_ticket.captured?).to eq true
        end

      end
    
      describe "scope tests" do
        it "scopes closed tickets" do
          ticket = FactoryBot.build_stubbed(:ticket, closed: true)
          expect(Ticket.closed).to include(ticket)
          expect(Ticket.open).to_not include(ticket)
        end

        it "scopes organization ticket tests" do
          organization = FactoryBot.build_stubbed(:organization, name: "organization1")
          org_ticket = FactoryBot.build_stubbed(:ticket, organization_id: organization)
          ticket = FactoryBot.build_stubbed(:ticket, closed: true)
          expect(Ticket.organization(org_ticket.organization_id)).to include(org_ticket)
          expect(Ticket.organization(ticket.organization_id)).to_not include(ticket)
        end

        
        it "scopes all_organization ticket tests" do
          organization = FactoryBot.build_stubbed(:organization, name: "organization1")
          org_ticket = FactoryBot.build_stubbed(:ticket, organization_id: organization, closed: false)
          ticket = FactoryBot.build_stubbed(:ticket, closed: false)
          expect(Ticket.all_organization()).to include(org_ticket)
          expect(Ticket.all_organization()).to_not include(ticket)
        end

        it "scopes closed_organization ticket tests" do
          organization = FactoryBot.build_stubbed(:organization, name: "organization1")
          org_ticket = FactoryBot.build_stubbed(:ticket, organization_id: organization, closed: false)
          org_ticket_closed = FactoryBot.build_stubbed(:ticket, organization_id: organization, closed: true)
          expect(Ticket.closed_organization(org_ticket_closed.organization_id)).to include(org_ticket_closed)
          expect(Ticket.closed_organization(org_ticket.organization_id)).to_not include(org_ticket)
        end

        it "scopes region ticket tests" do
          region = FactoryBot.build_stubbed(:region, name: "region1")
          region_ticket = FactoryBot.build_stubbed(:ticket, organization_id: region, closed: false)
          region_ticket_closed = FactoryBot.build_stubbed(:ticket, organization_id: region, closed: true)
          expect(Ticket.region(region_ticket.region_id)).to include(region_ticket)
          expect(Ticket.region(region_ticket_closed.region_id)).to include(region_ticket_closed)
        end

        it "scopes resource_category ticket tests" do
          resource = FactoryBot.build_stubbed(:active_resource_category, name: "resource1")
          resource_ticket = FactoryBot.build_stubbed(:ticket, organization_id: resource, closed: false)
          resource_ticket_closed = FactoryBot.build_stubbed(:ticket, organization_id: resource, closed: true)
          expect(Ticket.resource_category(resource_ticket.resource_category_id)).to include(resource_ticket)
          expect(Ticket.resource_category(resource_ticket_closed.resource_category_id)).to include(resource_ticket_closed)
        end

      end
end
