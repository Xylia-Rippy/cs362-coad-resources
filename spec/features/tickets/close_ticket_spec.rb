require 'rails_helper'

RSpec.describe 'Closing a ticket', type: :feature do

    
    before do
        @ticket = create(:ticket)
        @user = create(:user, :admin)
    end

    it 'can be used' do

        log_in_as @user
        visit dashboard_path

        click_on @ticket.name
    
        click_on 'Close'
    
        expect(current_path).to eq dashboard_path
        expect(page.body).to have_text(@ticket.name)

    end


end
