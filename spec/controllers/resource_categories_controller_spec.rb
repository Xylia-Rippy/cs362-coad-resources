require 'rails_helper'

RSpec.describe ResourceCategoriesController, type: :controller do

    describe 'as a logged out user' do
        let(:user) { FactoryBot.create(:user) }
    
        it { expect(get(:index)).to redirect_to new_user_session_path }
        it {
          post(:create, params: { resource_category: FactoryBot.attributes_for(:resource_category) })
          expect(response).to redirect_to new_user_session_path
        }
        it { expect(get(:new)).to redirect_to new_user_session_path }
      end

end
