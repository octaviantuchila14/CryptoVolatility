require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the PredictionsHelper. For example:
#
# describe PredictionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe PredictionsHelper, type: :helper do

  it 'can produce a hash of exchange rates with times mapped to values' do
    ers = []
    5.times do |i|
      ers << FactoryGirl.create(:exchange_rate, time: DateTime.now - (5 - i).days, last: i)
    end
    h_ers = estimates_as_hash(ers)
    expect(h_ers.size).to eq(ers.size)
    ers.each do |er|
      expect(h_ers.has_key?(er.time)).to be(true)
      expect(h_ers[er.time]).to eq(er.last)
    end
  end


end
