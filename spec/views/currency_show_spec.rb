require 'spec_helper'

describe 'currencies/show.html.erb' do

  it 'she can choose a time and ask for a prediction' do
    assign(:currency, FactoryGirl.create(:currency))

    render
    expect(rendered).to have_selector("input[value='100']")
  end
end
