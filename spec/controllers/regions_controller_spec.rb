require 'rails_helper'

RSpec.describe RegionsController, type: :controller do
  let(:region) { FactoryBot.create(:region) }
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  describe 'as a logged out user' do
    it 'redirects index to login' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects show to login' do
      get :show, params: { id: region.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects create to login' do
      post :create, params: { region: FactoryBot.attributes_for(:region) }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects new to login' do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects edit to login' do
      get :edit, params: { id: region.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects update to login' do
      patch :update, params: { id: region.id, region: { name: 'Updated Name' } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects destroy to login' do
      delete(:destroy, params: {id: region.id})
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'as a logged in non-admin user' do
    let(:user) { FactoryBot.create(:user) }
    before { sign_in user }

    it 'redirects index to dashboard' do
      get :index
      expect(response).to redirect_to(dashboard_path)
    end

    it 'redirects show to dashboard' do
      get :show, params: { id: region.id }
      expect(response).to redirect_to(dashboard_path)
    end

    it 'redirects create to dashboard' do
      post :create, params: { region: FactoryBot.attributes_for(:region) }
      expect(response).to redirect_to(dashboard_path)
    end

    it 'redirects new to dashboard' do
      get :new
      expect(response).to redirect_to(dashboard_path)
    end

    it 'redirects edit to dashboard' do
      get :edit, params: { id: region.id }
      expect(response).to redirect_to(dashboard_path)
    end

    it 'redirects update to dashboard' do
      patch :update, params: { id: region.id, region: { name: 'Updated Name' } }
      expect(response).to redirect_to(dashboard_path)
    end

    it 'redirects destroy to dashboard' do
      delete(:destroy, params: {id: region.id})
      expect(response).to redirect_to(dashboard_path)
    end
  end

  describe 'as an admin' do
    let(:admin) { FactoryBot.create(:user, :admin) }
    before { sign_in admin }

    describe 'GET #index' do
      it 'returns a success response and includes regions' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        get :show, params: { id: region.id }
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid parameters' do
        it 'creates a new region and redirects' do
          expect {
            post :create, params: { region: FactoryBot.attributes_for(:region) }
          }.to change(Region, :count).by(1)
          expect(response).to redirect_to(regions_path)
          expect(flash[:notice]).to eq('Region successfully created.')
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new region and renders new' do
          expect {
            post :create, params: { region: { name: '' } }
          }.not_to change(Region, :count)
        end
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        get :edit, params: { id: region.id }
        expect(response).to be_successful
      end
    end

    describe 'PATCH #update' do
      context 'with valid parameters' do
        it 'updates the region and redirects' do
          patch :update, params: { id: region.id, region: { name: 'Updated Name' } }
          expect(region.reload.name).to eq('Updated Name')
          expect(response).to redirect_to(region)
          expect(flash[:notice]).to eq('Region successfully updated.')
        end
      end

      context 'with invalid parameters' do
        it 'does not update the region and renders edit' do
          patch :update, params: { id: region.id, region: { name: '' } }
          expect(region.reload.name).not_to eq('')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes the region and redirects' do
        region_to_delete = create(:region)
        
        delete(:destroy, params: {id: region_to_delete.id})
        expect(response).to redirect_to(regions_path)
        expect(flash[:notice]).to eq("Region #{region_to_delete.name} was deleted. Associated tickets now belong to the 'Unspecified' region.")
      end
    end
  end
end
