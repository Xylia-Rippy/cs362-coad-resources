require 'rails_helper'

RSpec.describe ResourceCategoriesController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:resource_category) { create(:resource_category) }

  describe 'GET #index' do
    it 'redirects non-authenticated users' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'allows authenticated users' do
      sign_in admin
      get :index
      expect(response).to have_http_status(:ok)

    end
  end

  describe 'POST #new' do
    before {sign_in admin}

    it 'creates new resource category' do
      expect(get(:new)).to be_successful
    end

  end

  describe 'POST #create' do
    before { sign_in admin }

    context 'with valid attributes' do
      it 'creates a new category' do
        expect {
          post :create, params: { resource_category: { name: 'New Category' } }
        }.to change(ResourceCategory, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a category' do
        expect {
          post :create, params: { resource_category: { name: '' } }
        }.not_to change(ResourceCategory, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in admin }

    context 'with valid attributes' do
      it 'updates the category' do
        patch :update, params: { id: resource_category.id, resource_category: { name: 'Updated Name' } }
        expect(resource_category.reload.name).to eq('Updated Name')
      end
    end

    context 'with invalid attributes' do
      it 'updates the category' do
        patch :update, params: { id: resource_category.id, resource_category: { name: '' } }
        expect(resource_category.reload.name).to_not eq('')
      end
    end
  end

  describe 'PATCH #activate' do
    before { sign_in admin }
    
    context 'successful activation' do
      it 'activates the category' do
        allow_any_instance_of(ResourceCategory).to receive(:activate).and_return(true)
        patch :activate, params: { id: resource_category.id }

        expect(response).to redirect_to(resource_category)
        expect(flash[:notice]).to eq('Category activated.')
      end
    end

    context 'unsuccessful activation' do
      it 'activates the category' do
        allow_any_instance_of(ResourceCategory).to receive(:activate).and_return(false)
        patch :activate, params: { id: resource_category.id }

        expect(response).to redirect_to(resource_category)
        expect(flash[:alert]).to eq('There was a problem activating the category.')
      end
    end
  end

  describe 'PATCH #deactivate' do
    before { sign_in admin }

    context 'successful deactivation' do
      it 'deactivates the category' do
        allow_any_instance_of(ResourceCategory).to receive(:deactivate).and_return(true)
        patch :deactivate, params: { id: resource_category.id }

        expect(response).to redirect_to(resource_category)
        expect(flash[:notice]).to eq('Category deactivated.')
      end
    end

    context 'unsuccessful deactivation' do
      it 'deactivates the category' do
        allow_any_instance_of(ResourceCategory).to receive(:deactivate).and_return(false)
        patch :deactivate, params: { id: resource_category.id }

        expect(response).to redirect_to(resource_category)
        expect(flash[:alert]).to eq('There was a problem deactivating the category.')
      end
    end

  end

  describe 'DELETE #destroy' do
    before { sign_in admin }

    it 'deletes the category' do
      resource_category = create(:resource_category)
      delete(:destroy, params: {id: resource_category.id})
      expect(response).to redirect_to resource_categories_path
    end
  end
end