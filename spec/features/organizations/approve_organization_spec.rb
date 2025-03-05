require 'rails_helper'

RSpec.describe 'Approving an Organization', type: :feature do
  before do
    @admin = create(:user, :admin)
    @organization = create(:organization, :submitted) # Ensure correct enum status
  end

  it 'can be used' do
    log_in_as @admin
    visit organizations_path

    click_on @organization.name
    click_on 'Approve'

    expect(current_path).to eq organizations_path
    expect(page.body).to have_text('has been approved') # Generalized for dynamic text
  end
end
