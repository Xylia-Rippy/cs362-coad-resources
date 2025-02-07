require 'rails_helper'

RSpec.describe DashboardHelper, type: :helper do
  describe "#dashboard_for" do
    let(:admin) { double("User", admin?: true, organization: nil) }
    let(:submitted_user) { double("User", admin?: false, organization: double("Organization", submitted?: true, approved?: false)) }
    let(:approved_user) { double("User", admin?: false, organization: double("Organization", submitted?: false, approved?: true)) }
    let(:regular_user) { double("User", admin?: false, organization: nil) }

    it "returns 'admin_dashboard' for admin users" do
      expect(helper.dashboard_for(admin)).to eq('admin_dashboard')
    end

    it "returns 'organization_submitted_dashboard' for users with submitted organizations" do
      expect(helper.dashboard_for(submitted_user)).to eq('organization_submitted_dashboard')
    end

    it "returns 'organization_approved_dashboard' for users with approved organizations" do
      expect(helper.dashboard_for(approved_user)).to eq('organization_approved_dashboard')
    end

    it "returns 'create_application_dashboard' for users without an organization" do
      expect(helper.dashboard_for(regular_user)).to eq('create_application_dashboard')
    end
  end
end
