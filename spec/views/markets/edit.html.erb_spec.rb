require 'rails_helper'

RSpec.describe "markets/edit", type: :view do
  before(:each) do
    @market = assign(:market, Market.create!())
  end

  it "renders the edit market form" do
    render

    assert_select "form[action=?][method=?]", market_path(@market), "post" do
    end
  end
end
