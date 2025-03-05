require 'rails_helper'

RSpec.describe 'User Registration', type: :feature do
  it 'can be used' do
    visit root_path
    click_link 'Sign up' # Fix for broken signup

    fill_in 'Email address', with: 'newuser@example.com'
    fill_in 'Password', with: 'SecurePass123'
    fill_in 'Password confirmation', with: 'SecurePass123'

    click_button 'Sign up' # Adjusted based on form structure

    expect(page.body).to have_text('Welcome! You have signed up successfully.')
  end
end
