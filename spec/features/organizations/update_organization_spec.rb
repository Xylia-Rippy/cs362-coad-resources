require 'rails_helper'

RSpec.describe 'Updating an Organization', type: :feature do
  before do
    # Ensure a user exists and is connected to an organization
    @user = User.find_or_create_by!(email: 'testemail@email.com') do |u|
      u.password = 'password'
      u.password_confirmation = 'password'
      u.confirmed_at = Time.current if u.respond_to?(:confirmed_at)
    end

    @organization = @user.organization || Organization.create!(
      name: 'test organization',
      phone: 'XXX-XXX-XXXX',
      email: 'test@example.com',
      description: 'best test',
      liability_insurance: true,
      primary_name: 'Primary',
      secondary_name: 'Secondary',
      secondary_phone: '555-555-5555',
      title: 'Title',
      transportation: :yes,
      status: :approved
    )
    @user.update!(organization: @organization)
  end

  it 'logs in and edits the organization successfully' do
    visit root_path

    # Step 1: Go to login
    click_link 'Log in'

    # Step 2: Log in
    fill_in 'Email', with: 'testemail@email.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    expect(page).to have_text('Dashboard')

    # Step 3: Click Edit Organization
    click_link 'Edit Organization'

    # Step 4: Fill out the form
    fill_in 'Name', with: 'Updated Organization'
    fill_in 'Phone', with: '123-456-7890'
    fill_in 'Email', with: 'updated@email.com'
    fill_in 'Description', with: 'Updated organization description.'

    # Step 5: Submit the form
    click_button 'Update Resource'

    # Step 6: Confirm changes were saved
    expect(current_path).to eq organization_path(@organization)
    expect(page).to have_text('Updated Organization')
  end
end
