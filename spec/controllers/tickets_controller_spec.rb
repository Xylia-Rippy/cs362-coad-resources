require 'rails_helper'

#   tickets POST            /tickets(.:format)                 tickets#create  fully_done
#   new_ticket GET          /tickets/new(.:format)             tickets#new     fully_done
#   ticket GET              /tickets/:id(.:format)             tickets#show    Fully_done
#   capture_ticket POST     /tickets/:id/capture(.:format)     tickets#capture fully_done
#   release_ticket POST     /tickets/:id/release(.:format)     tickets#release fully_done
#   close_ticket PATCH      /tickets/:id/close(.:format)       tickets#close   
#   DELETE                  /tickets/:id(.:format)             tickets#destroy 


RSpec.describe TicketsController, type: :controller do

    describe 'as a logged out user' do

        let(:user) { FactoryBot.create(:user) }

        it {    post(:create, params: { ticket: FactoryBot.attributes_for(:ticket) })
                expect(response).to be_successful } #fail

        it {    region = create(:region)
                organization = create(:organization)
                resource_category = create(:resource_category)

                post(:create, params: { ticket: FactoryBot.attributes_for(:ticket,
                region_id: region.id,
                organization_id: organization.id,
                resource_category_id: resource_category.id)
                })
                expect(response).to redirect_to ticket_submitted_path } #it works

        it { expect(get(:new)).to be_successful }
        
        
        it {    
                show_test = create(:ticket)
                get( :show, params: { id: show_test.id})
                expect(response).to redirect_to dashboard_path 
            }

        it {    show_test1 = create(:ticket)
                post( :capture, params: { id: show_test1.id})
                expect(response).to redirect_to dashboard_path }

        it {    show_test1 = create(:ticket)
                post( :release, params: { id: show_test1.id})
                expect(response).to redirect_to dashboard_path }


        it {    show_test1 = create(:ticket)
                patch( :close, params: { id: show_test1.id})
                expect(response).to redirect_to dashboard_path }

        it {    show_test1 = create(:ticket)
                delete( :close, params: { id: show_test1.id})
                expect(response).to redirect_to dashboard_path }

    end


    describe 'as a logged in user' do

        let(:user) { FactoryBot.create(:user) }
        before(:each) { sign_in user }

        it { expect(post(:create, params: { ticket: FactoryBot.attributes_for(:ticket) })).to be_successful }

        it {    region = create(:region)
                organization = create(:organization)
                resource_category = create(:resource_category)

                post(:create, params: { ticket: FactoryBot.attributes_for(
                    :ticket,
                    region_id: region.id,
                    organization_id: organization.id,
                    resource_category_id: resource_category.id
                )})
                expect(response).to redirect_to ticket_submitted_path } #it works

        it { expect(get(:new)).to be_successful }

        it {    show_test1 = create(:ticket)
                get( :show, params: { id: show_test1.id})
                expect(response).to redirect_to dashboard_path }

        it {    show_test1 = create(:ticket)
                post( :capture, params: { id: show_test1.id})
                expect(response).to redirect_to dashboard_path }
        
        it {    show_test1 = create(:ticket)
                post( :release, params: { id: show_test1.id})
                expect(response).to redirect_to dashboard_path }


        it {    show_test1 = create(:ticket)
                patch( :close, params: { id: show_test1.id})
                expect(response).to redirect_to dashboard_path }




    end



    describe 'as a logged in user org approved' do

        let(:user) { FactoryBot.create(:user, :organization_approved) }
        before(:each) { sign_in user }

        it { expect(post(:create, params: { ticket: FactoryBot.attributes_for(:ticket) })).to be_successful }


        it {    region = create(:region)
                organization = create(:organization)
                resource_category = create(:resource_category)

                post(:create, params: { ticket: FactoryBot.attributes_for(
                    :ticket,
                    region_id: region.id,
                    organization_id: organization.id,
                    resource_category_id: resource_category.id
                )})
            expect(response).to redirect_to ticket_submitted_path } #it works

        it { expect(get(:new)).to be_successful }


        it {    show_test3 = create(:ticket)
                get( :show, params: { id: show_test3.id})
                expect(response).to be_successful }

        it {    show_test1 = create(:ticket)
                post( :capture, params: { id: show_test1.id})
                expect(response).to be_successful }


        it {    show_test1 = create(:ticket_without_organization)
                post( :capture, params: { id: show_test1.id})
                expect(response).to redirect_to dashboard_path << '#tickets:open' }



        it {    show_test1 = create(:ticket)
                post( :release, params: { id: show_test1.id})
                expect(response).to be_successful }


        it {    
                show_test1 = create(:ticket, organization_id: user.organization_id)
                #pp show_test1.organization_id
                #user.organization_id
                post( :release, params: { id: show_test1.id})
                expect(response).to redirect_to dashboard_path << '#tickets:organization' }



        it {    show_test1 = create(:ticket)
                patch( :close, params: { id: show_test1.id})
                expect(response).to be_successful }


        it {    show_test1 = create(:ticket, organization_id: user.organization_id)
                patch( :close, params: { id: show_test1.id})
                expect(response).to redirect_to dashboard_path << '#tickets:organization' }






    end



    describe 'as an admin' do

        let(:user) { FactoryBot.create(:user, :admin) }
        before(:each) { sign_in user }
        it { expect(post(:create, params: { ticket: FactoryBot.attributes_for(:ticket) })).to be_successful }

        it {    region = create(:region)
                organization = create(:organization)
                resource_category = create(:resource_category)

                post(:create, params: { ticket: FactoryBot.attributes_for(
                    :ticket,
                    region_id: region.id,
                    organization_id: organization.id,
                    resource_category_id: resource_category.id
                )})
            expect(response).to redirect_to ticket_submitted_path } #it works

        it { expect(get(:new)).to be_successful }


        it {    show_test2 = create(:ticket)
                get( :show, params: { id: show_test2.id})
                expect(response).to be_successful }


        it {    show_test1 = create(:ticket)
                post( :capture, params: { id: show_test1.id})
                expect(response).to redirect_to dashboard_path }






        it {    show_test1 = create(:ticket)
                post( :release, params: { id: show_test1.id})
                expect(response).to redirect_to dashboard_path << '#tickets:captured' }





        it {    show_test1 = create(:ticket)
                patch( :close, params: { id: show_test1.id})
                expect(response).to redirect_to dashboard_path << '#tickets:open' }


        it {    show_test1 = create(:ticket)
                delete( :destroy, params: { id: show_test1.id})
                expect(response).to redirect_to (dashboard_path << '#tickets') }

        


    end

end
