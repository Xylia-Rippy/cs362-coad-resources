require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
    describe '#full_title' do
    it 'returns the base title when no page title is given' do
      expect(helper.full_title).to eq('Disaster Resource Network')
    end

    it 'returns the full title when a page title is given' do
      expect(helper.full_title('About')).to eq('About | Disaster Resource Network')
    end
  end

end
