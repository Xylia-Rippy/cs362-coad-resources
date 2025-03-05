require 'rails_helper'

RSpec.describe 'Capturing a ticket', type: :feature do
   
    before do
        @ticket = create(:ticket_without_organization)
        @user = create(:user, :organization_approved)
    end

    it 'can be used' do

        log_in_as @user
        visit dashboard_path

        click_on 'Tickets'

        click_on @ticket.name
    
        click_on 'Capture'
    
        expect(current_path).to eq dashboard_path


    end

end
