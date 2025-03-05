require 'rails_helper'

RSpec.describe 'User Login', type: :feature do
  before do
    @user = create(:user, email: 'testuser@example.com', password: 'SecurePass123')
  end

  it 'can be used' do
    visit new_user_session_path

    fill_in 'Email', with: 'testuser@example.com'
    fill_in 'Password', with: 'SecurePass123'

    click_on 'Log in'

    expect(page.body).to have_text('Signed in successfully')
  end

  it 'shows an error for invalid credentials' do
    visit new_user_session_path

    fill_in 'Email', with: 'wronguser@example.com'
    fill_in 'Password', with: 'WrongPass123'

    click_on 'Log in'

    expect(page.body).to have_text('Invalid Email or password.')
  end
end
