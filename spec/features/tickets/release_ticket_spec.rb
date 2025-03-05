require 'rails_helper'

RSpec.describe 'Releasing a ticket by an', type: :feature do
  
    before do
        @ticket = create(:ticket)
        @user = create(:user, :admin)
    end

    it 'can be used' do

        log_in_as @user
        visit dashboard_path

        click_on @ticket.name
    
        click_on 'Release'
    
        expect(current_path).to eq dashboard_path


    end


end
