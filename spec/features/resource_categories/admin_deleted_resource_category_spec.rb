require 'rails_helper'

RSpec.describe 'Deleting a Resource Category', type: :feature do

    before do
        @user = create(:user, :admin)
        @resource_category = create(:resource_category)
    end

    it "can delete resource category" do
        log_in_as @user

        visit resource_categories_path

        click_on @resource_category.name

        click_on 'Delete'

        expect(current_path).to eq resource_categories_path
    end

end
