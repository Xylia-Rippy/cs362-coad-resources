require 'rails_helper'

RSpec.describe Ticket, type: :model do

    let (:ticket) { Ticket.new }

    it "exists" do
        Ticket.new
      end
    
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
