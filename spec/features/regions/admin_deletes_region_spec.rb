require 'rails_helper'

RSpec.describe 'Deleting a Region', type: :feature do

    before do
        @user = create(:user, :admin)
        @region = create(:region)
    end

    it 'can delete a region' do

        log_in_as @user
        visit regions_path

        #click_on 'La Pine'

        #find_by_id("region_#{@region.id}").find('a').click

        click_on @region.name

        click_on 'Delete'

        expect(current_path).to eq regions_path
        expect(page.body).to have_text("Region #{@region.name} was deleted. Associated tickets now belong to the 'Unspecified' region")
    end
end
