require 'rails_helper'

RSpec.describe 'User email addreses', type: :feature do

    before do
        @user = create(:user, :admin)
    end

    it 'it exists' do

        log_in_as @user
        visit users_path
        expect(page.body).to have_text(@user.email)


    end

end
