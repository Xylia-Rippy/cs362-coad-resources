require 'rails_helper'

RSpec.describe 'User Login', type: :feature do
  before do
    @user = create(:user, email: 'testuser@example.com', password: 'SecurePass123')
  end

  it 'can be used' do
    visit root_path
    click_link 'Log in' # Fix for navigation

    fill_in 'Email address', with: 'testuser@example.com'
    fill_in 'Password', with: 'SecurePass123'

    click_button 'Sign in' # Updated button

    expect(page.body).to have_text('Signed in successfully')
  end

  it 'shows an error for invalid credentials' do
    visit root_path
    click_link 'Log in'

    fill_in 'Email address', with: 'wronguser@example.com'
    fill_in 'Password', with: 'WrongPass123'

    click_button 'Sign in'

    expect(page.body).to have_text('Invalid Email or password.')
  end
end
