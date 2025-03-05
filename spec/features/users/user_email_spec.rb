require 'rails_helper'

RSpec.describe 'User email addresses', type: :feature do
  before do
    @admin = create(:user, :admin, email: 'admin@example.com')
    @unconfirmed_user = create(:user, confirmed_at: nil, email: 'unconfirmed@example.com')
  end

  it 'displays the email of an authenticated user' do
    log_in_as @admin
    visit users_path # Ensuring correct path

    expect(page.body).to have_text(@admin.email)
  end

  it 'prevents unauthenticated access' do
    visit users_path

    expect(current_path).to eq new_user_session_path
    expect(page.body).to have_text('You need to sign in or sign up before continuing.')
  end

  it 'prevents unconfirmed users from logging in' do
    visit new_user_session_path

    fill_in 'Email', with: @unconfirmed_user.email
    fill_in 'Password', with: 'password' # Default password

    click_on 'Log in'

    expect(page.body).to have_text(/confirm your email/i) # Ensures flexible matching
  end
end
