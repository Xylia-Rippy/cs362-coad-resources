require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  let!(:admin) { create(:user, role: :admin, email: "admin@example.com") }
  let(:user) { create(:user, organization: create(:organization, status: :submitted)) }
  let(:organization) { create(:organization, :approved, transportation: :yes) }
  let(:unapproved_user) { create(:user, organization: nil) }

  describe 'GET #index' do
    context 'as signed-in user' do
      it 'returns a successful response' do
        sign_in user
        get :index
        expect(response).to be_successful
      end
    end

    context 'as non-signed-in user' do
      it 'redirects to sign in' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'as admin' do
      it 'allows access' do
        sign_in admin
        get :index
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #new' do
    it 'returns success for unapproved user' do
      sign_in unapproved_user
      get :new
      expect(response).to be_successful
    end

    it 'redirects non-signed-in user' do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects admin' do
      sign_in admin
      get :new
      expect(response).to redirect_to(dashboard_path)
    end
  end

  describe 'POST #create' do
    context 'as unapproved user' do
      before { sign_in unapproved_user }

      it 'creates a new organization and redirects' do
        expect {
          post :create, params: { organization: attributes_for(:organization, transportation: :yes) }
        }.to change(Organization, :count).by(1)
        expect(response).to redirect_to organization_application_submitted_path
      end

      it 'renders new on failure' do
        post :create, params: { organization: { name: '' } }
        expect(response).to have_http_status(:ok)
      end
    end

    it 'redirects non-signed-in user' do
      post :create, params: { organization: attributes_for(:organization) }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects admin' do
      sign_in admin
      post :create, params: { organization: attributes_for(:organization) }
      expect(response).to redirect_to(dashboard_path)
    end
  end

  describe 'GET #edit' do
    it 'returns ok for signed-in user with org' do
      sign_in user
      user.update(organization: organization)
      get :edit, params: { id: organization.id }
      expect(response).to have_http_status(:ok)
    end

    it 'redirects non-signed-in user' do
      get :edit, params: { id: organization.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'allows admin to access edit' do
      admin.update(organization: organization) # ✅ Corrected association
      sign_in admin
      get :edit, params: { id: organization.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PATCH #update' do
    it 'updates organization for user and redirects' do
      sign_in user
      user.update(organization: organization)
      patch :update, params: { id: organization.id, organization: { name: 'Updated Name' } }
      organization.reload
      expect(organization.name).to eq('Updated Name')
      expect(response).to redirect_to organization_path(organization)
    end

    it 'renders edit on failure' do
      sign_in user
      user.update(organization: organization)
      patch :update, params: { id: organization.id, organization: { name: '' } }
      expect(response).to have_http_status(:ok)
    end

    it 'redirects non-signed-in user' do
      patch :update, params: { id: organization.id, organization: { name: 'Test' } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'allows admin to update' do
      admin.update(organization: organization) # ✅ Corrected association
      sign_in admin
      patch :update, params: { id: organization.id, organization: { name: 'New Name' } }
      organization.reload
      expect(organization.name).to eq('New Name')
      expect(response).to redirect_to organization_path(organization)
    end
  end

  describe 'GET #show' do
    it 'returns ok for signed-in user with approved org' do
      sign_in user
      user.update(organization: organization)
      get :show, params: { id: organization.id }
      expect(response).to have_http_status(:ok)
    end

    it 'redirects non-signed-in user' do
      get :show, params: { id: organization.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'allows admin to view' do
      sign_in admin
      get :show, params: { id: organization.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #approve' do
    it 'approves org as admin' do
      sign_in admin
      post :approve, params: { id: organization.id }
      organization.reload
      expect(organization.approved?).to be true
      expect(response).to redirect_to organizations_path
    end

    it 'redirects non-signed-in user' do
      post :approve, params: { id: organization.id }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'POST #reject' do
    it 'rejects org as admin' do
      sign_in admin
      post :reject, params: { id: organization.id, organization: { rejection_reason: 'Incomplete documents' } }
      organization.reload
      expect(organization.rejected?).to be true
      expect(organization.rejection_reason).to eq('Incomplete documents')
      expect(response).to redirect_to organizations_path
    end

    it 'redirects non-signed-in user' do
      post :reject, params: { id: organization.id, organization: { rejection_reason: 'Reason' } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
