require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe 'GET #index' do
    context 'as an admin' do
      before do
        sign_in admin
        get :index
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'as a logged-in user' do
      before do
        sign_in user
        get :index
      end

      it 'redirects to the dashboard' do
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'as a logged-out user' do
      before do
        get :index
      end

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end

