require 'rails_helper'

RSpec.describe 'User signs up and applies as an organization', type: :feature do
  it 'signs up and submits an organization application' do
    visit root_path

    # Step 1: Click Sign Up
    click_link 'Sign up'

    # Step 2: Fill in registration form
    fill_in 'Email', with: 'newuser@example.com'
    fill_in 'Password', with: 'SecurePass123'
    fill_in 'Password confirmation', with: 'SecurePass123'
    click_button 'Sign up'

    # Step 3: Handle confirmation if Devise confirmable is enabled
    if page.has_text?('A message with a confirmation link has been sent to your email address')
      user = User.find_by(email: 'newuser@example.com')
      user.update(confirmed_at: Time.current) if user && user.respond_to?(:confirmed_at)

      visit new_user_session_path
      fill_in 'Email', with: 'newuser@example.com'
      fill_in 'Password', with: 'SecurePass123'
      click_button 'Sign in'
      expect(page).to have_text('Signed in successfully')
    else
      expect(page).to have_text('Welcome! You have signed up successfully.')
    end

    # Step 4: Click "Create Application" on the dashboard
    click_link 'Create Application'

    # Step 5: Fill out required radio buttons
    find("input[name='organization[liability_insurance]'][value='true']", visible: false).click
    find("input[name='organization[agreement_one]'][value='true']", visible: false).click
    find("input[name='organization[agreement_two]'][value='true']", visible: false).click
    find("input[name='organization[agreement_three]'][value='true']", visible: false).click
    find("input[name='organization[agreement_four]'][value='true']", visible: false).click
    find("input[name='organization[agreement_five]'][value='true']", visible: false).click
    find("input[name='organization[agreement_six]'][value='true']", visible: false).click
    find("input[name='organization[agreement_seven]'][value='true']", visible: false).click
    find("input[name='organization[agreement_eight]'][value='true']", visible: false).click

    # Step 6: Fill in text fields
    fill_in 'What is your name?', with: 'Doe, John'
    fill_in 'Organization Name', with: 'Test Organization'
    fill_in 'What is your title? (if applicable)', with: 'Director'
    fill_in 'What is your direct phone number? Cell phone is best.', with: '555-123-4567'
    fill_in 'Who may we contact regarding your organization\'s application if we are unable to reach you?', with: 'Jane Smith'
    fill_in 'What is a good secondary phone number we may reach your organization at?', with: '555-987-6543'
    fill_in 'What is your Organization\'s email?', with: 'test@example.com'
    fill_in 'Description', with: 'We provide food and water in emergencies.'

    # Step 7: Check a resource category (if exists)
    check(ResourceCategory.first.name) if ResourceCategory.any?

    # Step 8: Select transportation
    find("input[name='organization[transportation]'][value='yes']", visible: false).click

    # Step 9: Submit form
    click_button 'Apply'

    # Step 10: Confirm success
    expect(current_path).to eq organization_application_submitted_path
    expect(page).to have_text('Thank you for applying')
  end
end
