require 'rails_helper'

RSpec.describe 'Creating an Organization Application', type: :feature do
  it 'can be used' do
    visit new_organization_application_path

    fill_in 'Name', with: 'Test Organization'
    fill_in 'Email', with: 'test@example.com'

    click_on 'Submit'

    expect(current_path).to eq organization_application_submitted_path # Ensuring correct path
    expect(page.body).to have_text('Application submitted successfully')
  end
end
