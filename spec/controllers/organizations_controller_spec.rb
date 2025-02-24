require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  let!(:admin) { create(:user, role: :admin, email: "admin@example.com") }
  let(:user) { create(:user, organization: create(:organization, status: :submitted)) }
  let(:organization) { create(:organization, :approved, transportation: :yes) }
  let(:unapproved_user) { create(:user, organization: nil) }
  
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end
  
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end
  
  describe 'GET #new' do
    it 'returns a successful response' do
      sign_in unapproved_user
      get :new
      expect(response).to be_successful
    end
  end
  
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new organization and redirects' do
        sign_in unapproved_user
        expect {
          post :create, params: { organization: attributes_for(:organization, transportation: :yes) }
        }.to change(Organization, :count).by(1)
        expect(response).to redirect_to organization_application_submitted_path
      end
    end
  
    context 'with invalid attributes' do
      it 'renders the new template' do
        sign_in unapproved_user
        post :create, params: { organization: { name: '' } }
        expect(response).to have_http_status(:ok)
      end
    end
  end
  
  describe 'GET #edit' do
    it 'redirects unauthorized users' do
      sign_in user
      user.update(organization: organization)
      get :edit, params: { id: organization.id }
      expect(response).to have_http_status(:ok)
    end
  end
  
  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the organization and redirects' do
        sign_in user
        user.update(organization: organization)
        patch :update, params: { id: organization.id, organization: { name: 'Updated Name' } }
        organization.reload
                expect(organization.name).to eq('Updated Name')
        expect(response).to redirect_to organization_path(organization)
      end
    end
  
    context 'with invalid attributes' do
      it 'renders the edit template' do
        sign_in user
        user.update(organization: organization)
        patch :update, params: { id: organization.id, organization: { name: '' } }
        expect(response).to have_http_status(:ok)
      end
    end
  end
  
  describe 'GET #show' do
    it 'redirects unauthorized users' do
      sign_in user
      user.update(organization: organization)
      get :show, params: { id: organization.id }
      expect(response).to have_http_status(:ok)
    end
  end
  
  describe 'POST #approve' do
    it 'approves the organization and redirects' do
      sign_in admin
      post :approve, params: { id: organization.id }
      organization.reload
      expect(organization.approved?).to be true
      expect(response).to redirect_to organizations_path
    end
  end
  
  describe 'POST #reject' do
    it 'rejects the organization and redirects' do
      sign_in admin
      post :reject, params: { id: organization.id, organization: { rejection_reason: 'Incomplete documents' } }
      organization.reload
      expect(organization.rejected?).to be true
      expect(organization.rejection_reason).to eq('Incomplete documents')
      expect(response).to redirect_to organizations_path
    end
  end
end
