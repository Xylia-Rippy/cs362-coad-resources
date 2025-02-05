require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TIcketsHelper. For example:
#
# describe TIcketsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TicketsHelper, type: :helper do

    it "format phone number for number" do
        expect(helper.format_phone_number('4452341111')).to eq "+14452341111"
        expect(helper.format_phone_number('+1 445-234-1111')).to eq "+14452341111"
        expect(helper.format_phone_number('445-234-1111')).to eq "+14452341111" 
        expect(helper.format_phone_number('445 234 1111')).to eq "+14452341111"
        expect(helper.format_phone_number('+1 445 234 1111')).to eq "+14452341111"
        expect(helper.format_phone_number('(+1)445-234-1111')).to eq "+14452341111"
        expect(helper.format_phone_number('1+ 445-234-1111')).to eq "+14452341111"
        expect(helper.format_phone_number('+1/445/234/1111')).to eq "+14452341111"
        expect(helper.format_phone_number('445/234/1111')).to eq "+14452341111"
        expect(helper.format_phone_number('cat')).to eq nil

    end

end
