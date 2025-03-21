require 'rails_helper'

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
    context 'as admin' do
      before { sign_out user }
      before { sign_in admin }

      it 'renders index' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
    context 'non-admin user' do
      it 'renders the index template' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context 'user is logged out' do
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
end
