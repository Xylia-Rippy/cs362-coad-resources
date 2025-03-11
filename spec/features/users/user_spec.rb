require 'rails_helper'

RSpec.describe "GET /users", type: :request do
  let(:admin_user) do
    User.create!(
      email: 'admin@example.com',
      password: 'password',
      role: :admin,
      confirmed_at: Time.current
    )
  end

  let(:regular_user) do
    User.create!(
      email: 'user@example.com',
      password: 'password',
      role: :organization,
      confirmed_at: Time.current
    )
  end

  context 'when logged in as an admin' do
    it 'allows access and shows all users' do
      sign_in admin_user
      get users_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(admin_user.email)
    end
  end

  context 'when logged in as a regular user' do
    it 'redirects to dashboard' do
      sign_in regular_user
      get users_path
      expect(response).to redirect_to(dashboard_path)
    end
  end

  context 'when not logged in' do
    it 'redirects to login page' do
      get users_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
