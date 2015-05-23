require 'rails_helper'

RSpec.describe "portfolios/edit", type: :view do
  before(:each) do
    @portfolio = assign(:portfolio, Portfolio.create!(
      :p_return => 1.5,
      :variance => 1.5
    ))
  end

  it "renders the edit portfolio form" do
    render

    assert_select "form[action=?][method=?]", portfolio_path(@portfolio), "post" do

      assert_select "input#portfolio_p_return[name=?]", "portfolio[p_return]"

      assert_select "input#portfolio_variance[name=?]", "portfolio[variance]"
    end
  end
end
