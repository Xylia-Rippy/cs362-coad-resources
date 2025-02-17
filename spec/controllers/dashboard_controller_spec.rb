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
    before do
      allow(controller).to receive(:params).and_return(status: 'Open')
    end

    it 'returns open tickets when status is Open' do
      open_ticket = create(:ticket, closed: false, organization: nil)  # Ensure organization is nil

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