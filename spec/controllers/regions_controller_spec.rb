require 'rails_helper'

# GET    /regions(.:format)           regions#index done
# POST   /regions(.:format)           regions#create 
# GET    /regions/new(.:format)       regions#new
# GET    /regions/:id/edit(.:format)  regions#edit
# GET    /regions/:id(.:format)       regions#show
# PATCH  /regions/:id(.:format)       regions#update
# PUT    /regions/:id(.:format)       regions#update
# DELETE /regions/:id(.:format)       regions#destroy

RSpec.describe RegionsController, type: :controller do

  describe 'as a logged out user' do
    let(:user) { FactoryBot.create(:user) }

    it { expect(get(:index)).to redirect_to new_user_session_path }
    it {
      post(:create, params: { region: FactoryBot.attributes_for(:region) })
      expect(response).to redirect_to new_user_session_path
    }
    it { expect(get(:new)).to redirect_to new_user_session_path }
  end

  describe 'as a logged in user' do
    let(:user) { FactoryBot.create(:user) }
    before(:each) { sign_in user }

    it { expect(get(:index)).to redirect_to dashboard_path }
    it {
      post(:create, params: { region: FactoryBot.attributes_for(:region) })
      expect(response).to redirect_to dashboard_path
    }
    it { expect(get(:new)).to redirect_to dashboard_path }
  end

  describe 'as an admin' do
    let(:user) { FactoryBot.create(:user, :admin) }
    before(:each) { sign_in user }

    it { expect(get(:index)).to be_successful }
    it {
      post(:create, params: { region: FactoryBot.attributes_for(:region) })
      expect(response).to redirect_to regions_path
    }
    it { expect(get(:new)).to be_successful }
  end

end