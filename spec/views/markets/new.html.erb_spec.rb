require 'rails_helper'

RSpec.describe "markets/new", type: :view do
  before(:each) do
    assign(:market, Market.new())
  end

  it "renders new market form" do
    render

    assert_select "form[action=?][method=?]", markets_path, "post" do
    end
  end
end
