require 'rails_helper'

RSpec.describe 'Updating an Organization', type: :feature do
  before do
    @user = create(:user, :organization)
    @organization = create(:organization, users: [@user]) # Associate user with org
  end

  it 'can be used' do
    log_in_as @user
    visit edit_organization_path(@organization)

    fill_in 'Name', with: 'Updated Organization'
    click_on 'Save Changes'

    expect(current_path).to eq organization_path(@organization)
    expect(page.body).to have_text('Updated Organization')
  end
end
