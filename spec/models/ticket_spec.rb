require 'rails_helper'

RSpec.describe Ticket, type: :model do
    
  #before(:each) do
    #Ticket.destroy_all # Clears all tickets to prevent duplicate names
 # end
  
    let (:region) {FactoryBot.build(:region)}
    let (:organization) {FactoryBot.build(:organization)}
    let (:ticket) { FactoryBot.build(:ticket) }
    let (:ticket_without_organization) { FactoryBot.build(:ticket_without_organization) }   
    let (:ticket_with_org) { FactoryBot.build(:ticket, organization: organization)}
   # let (:org_ticket) { FactoryBot.build(:ticket, organization: organization, closed: false)}


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
          expect(ticket_without_organization.captured?).to eq false
          expect(ticket_with_org.captured?).to eq true
        end

      end
    
      describe "scope tests" do
        it "scopes closed tickets" do
          ticket = FactoryBot.create(:ticket, closed: true)
          expect(Ticket.closed).to include(ticket)
          expect(Ticket.open).to_not include(ticket)
        end

        it "scopes organization ticket tests" do
          org_ticket = FactoryBot.create(:ticket, organization: organization, closed: false)
          expect(Ticket.organization(org_ticket.organization_id)).to include(org_ticket)
          expect(Ticket.organization(ticket_without_organization.organization_id)).to_not include(ticket_without_organization)
        end

        
        it "scopes all_organization ticket tests" do
          org_ticket2 = FactoryBot.create(:ticket, organization: organization, closed: false)
          ticket_without_organization = FactoryBot.create(:ticket_without_organization, closed: false)
          expect(Ticket.all_organization).to include(org_ticket2)
          expect(Ticket.all_organization).to_not include(ticket_without_organization) ##problem line
        end

        it "scopes closed_organization ticket tests" do
          closed_org_ticket = FactoryBot.create(:ticket, organization: organization, closed: true)
          open_org_ticket = FactoryBot.create(:ticket, organization: organization, closed: false)
          expect(Ticket.closed_organization(closed_org_ticket.organization_id)).to include(closed_org_ticket)#why this broke?
          expect(Ticket.closed_organization(open_org_ticket.organization_id)).to_not include(open_org_ticket)
        end
        
        it "scopes region ticket tests" do
          region = FactoryBot.create(:region)
          region_ticket_closed = FactoryBot.create(:ticket, region: region, closed: true)
          expect(Ticket.region(region_ticket_closed.region_id)).to include(region_ticket_closed)
        end

        it "scopes resource_category ticket tests" do
          resource_category = FactoryBot.create(:resource_category)
          resource_ticket = FactoryBot.create(:ticket, resource_category: resource_category, closed: false)
          expect(Ticket.resource_category(resource_ticket.resource_category_id)).to include(resource_ticket)
        end

      end
end
