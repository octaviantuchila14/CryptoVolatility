require 'rails_helper'

RSpec.describe "portfolios/new", type: :view do
  before(:each) do
    assign(:portfolio, Portfolio.new(
      :p_return => 1.5,
      :variance => 1.5
    ))
  end

  it "renders new portfolio form" do
    render

    assert_select "form[action=?][method=?]", portfolios_path, "post" do

      assert_select "input#portfolio_p_return[name=?]", "portfolio[p_return]"

      assert_select "input#portfolio_variance[name=?]", "portfolio[variance]"
    end
  end
end
