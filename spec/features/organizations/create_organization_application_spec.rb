require 'rails_helper'

RSpec.describe 'Creating an Organization Application', type: :feature do
  it 'can be used' do
    visit new_organization_application_path

    # Inspect page if failure persists
    # save_and_open_page

    # # Fix: Use actual values Rails renders ("1" instead of true)
    # find("input[name='organization[liability_insurance]'][value='1']").click
    # find("input[name='organization[agreement_one]'][value='1']").click
    # find("input[name='organization[agreement_two]'][value='1']").click
    # find("input[name='organization[agreement_three]'][value='1']").click
    # find("input[name='organization[agreement_four]'][value='1']").click
    # find("input[name='organization[agreement_five]'][value='1']").click
    # find("input[name='organization[agreement_six]'][value='1']").click
    # find("input[name='organization[agreement_seven]'][value='1']").click
    # find("input[name='organization[agreement_eight]'][value='1']").click

    fill_in 'What is your name?', with: 'Doe, John'
    fill_in 'Organization Name', with: 'Test Organization'
    fill_in 'What is your title? (if applicable)', with: 'Director'
    fill_in 'What is your direct phone number? Cell phone is best.', with: '555-123-4567'
    fill_in 'Who may we contact regarding your organization\'s application if we are unable to reach you?', with: 'Jane Smith'
    fill_in 'What is a good secondary phone number we may reach your organization at?', with: '555-987-6543'
    fill_in 'What is your Organization\'s email?', with: 'test@example.com'
    fill_in 'Description', with: 'We provide food and water in emergencies.'

    check(ResourceCategory.first.name) if ResourceCategory.any?

    find("input[name='organization[transportation]'][value='yes']").click

    click_button 'Apply'

    expect(current_path).to eq organization_application_submitted_path
    expect(page).to have_text('Application submitted successfully')
  end
end
