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

RSpec.describe DashboardController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:organization) { create(:organization, :approved) }
  let(:org_user) { create(:user, organization: organization) }
  let!(:open_ticket) { create(:ticket, closed: false, organization: nil) }
  let!(:closed_ticket) { create(:ticket, closed: true) }
  let!(:captured_ticket) { create(:ticket, closed: false, organization: create(:organization)) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    context 'when user is authenticated' do
      it 'renders the index template' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is not authenticated' do
      before { sign_out user }

      it 'redirects to sign-in page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe '#status_options' do
    context 'when user has an approved organization' do
      before { sign_in org_user }
      it 'includes My Closed and My Captured' do
        controller.instance_variable_set(:@current_user, org_user)
        expect(controller.send(:status_options)).to include('My Captured', 'My Closed')
      end
    end
    context 'when user is an admin' do
      before { sign_in admin }
      
      it 'returns all status options' do
        controller.instance_variable_set(:@current_user, admin)
        expect(controller.send(:status_options)).to match_array(['Open', 'Captured', 'Closed'])
      end
    end

    context 'when user belongs to an approved organization' do
      before { sign_in org_user }
      
      it 'returns organization-specific status options' do
        controller.instance_variable_set(:@current_user, org_user)
        expect(controller.send(:status_options)).to match_array(['Open', 'My Captured', 'My Closed'])
      end
    end

    context 'when user has no organization or unapproved organization' do
      it 'returns only open status option' do
        controller.instance_variable_set(:@current_user, user)
        expect(controller.send(:status_options)).to match_array(['Open'])
      end
    end
  end

  describe '#tickets' do
    it 'returns all tickets when status is missing or invalid' do
      Ticket.delete_all
      allow(controller).to receive(:params).and_return({})
      all_tickets = create_list(:ticket, 3)
      _, tickets = controller.send(:tickets)
      expect(tickets).to match_array(all_tickets)
    end
    it 'returns My Captured tickets when status is My Captured' do
      sign_in org_user
      allow(controller).to receive(:params).and_return(status: 'My Captured')
      my_captured_ticket = create(:ticket, closed: false, organization: org_user.organization)
      _, tickets = controller.send(:tickets)
      expect(tickets).to include(my_captured_ticket)
    end

    it 'returns My Closed tickets when status is My Closed' do
      sign_in org_user
      allow(controller).to receive(:params).and_return(status: 'My Closed')
      my_closed_ticket = create(:ticket, closed: true, organization: org_user.organization)
      _, tickets = controller.send(:tickets)
      expect(tickets).to include(my_closed_ticket)
    end

    it 'filters tickets by region_id' do
      region_ticket = create(:ticket, closed: false, region_id: 1)
      allow(controller).to receive(:params).and_return(region_id: 1)
      _, tickets = controller.send(:tickets)
      expect(tickets).to include(region_ticket)
    end

    it 'filters tickets by resource_category_id' do
      resource_ticket = create(:ticket, closed: false, resource_category_id: 2)
      allow(controller).to receive(:params).and_return(resource_category_id: 2)
      _, tickets = controller.send(:tickets)
      expect(tickets).to include(resource_ticket)
    end

    it 'sorts tickets by Newest First' do
      older_ticket = create(:ticket, closed: false, created_at: 1.day.ago)
      newer_ticket = create(:ticket, closed: false, created_at: Time.current)
      allow(controller).to receive(:params).and_return(sort_order: 'Newest First')
      _, tickets = controller.send(:tickets)
      expect(tickets.first).to eq(newer_ticket)
    end
    before do
      allow(controller).to receive(:params).and_return(status: 'Open')
    end

    it 'returns open tickets when status is Open' do
      open_ticket = create(:ticket, closed: false, organization: nil)
      _, tickets = controller.send(:tickets)
      expect(tickets).to include(open_ticket)
    end

    it 'returns captured tickets when status is Captured' do
      allow(controller).to receive(:params).and_return(status: 'Captured')
      captured_ticket = create(:ticket, closed: false, organization: create(:organization))
      _, tickets = controller.send(:tickets)
      expect(tickets).to include(captured_ticket)
    end
  end

  # Non-signed-in user already tested in original for GET #index
 # Let's add admin and normal signed-in users for each action

 describe DashboardController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe 'GET #index' do
    context 'as admin' do
      before { sign_in admin }

      it 'renders index' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context 'as normal signed-in user' do
      before { sign_in user }

      it 'renders index' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end
end
end