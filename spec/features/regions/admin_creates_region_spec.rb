require 'rails_helper'

RSpec.describe 'Creating a Region', type: :feature do

    before do
        @user = create(:user, :admin)
    end

    it 'can create a region' do

        log_in_as @user
        visit regions_path

        click_on 'Add Region'
    
        fill_in 'Name', with: 'Test Name'
    
        click_on 'Add Region'
    
        expect(current_path).to eq regions_path
        expect(page.body).to have_text('Test Name')

    end


end
