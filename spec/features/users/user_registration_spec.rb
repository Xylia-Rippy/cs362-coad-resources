require 'rails_helper'

RSpec.describe 'User Registration', type: :feature do
  it 'shows a confirmation message after sign up' do
    visit root_path
    click_link 'Sign up'

    fill_in 'Email', with: 'newuser@example.com'
    fill_in 'Password', with: 'SecurePass123'
    fill_in 'Password confirmation', with: 'SecurePass123'

    click_button 'Sign up'

    expect(page).to have_text(
      'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
    )
  end
end
