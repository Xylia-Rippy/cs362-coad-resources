require 'rails_helper'

RSpec.describe 'User Registration', type: :feature do
  it 'can be used' do
    visit new_user_registration_path

    fill_in 'Email', with: 'newuser@example.com'
    fill_in 'Password', with: 'SecurePass123'
    fill_in 'Password confirmation', with: 'SecurePass123'

    click_on 'Sign Up', match: :first # Avoid ambiguity

    expect(page.body).to have_text('Welcome! You have signed up successfully.')
  end
end
