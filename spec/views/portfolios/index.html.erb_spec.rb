require 'rails_helper'

RSpec.describe "portfolios/index", type: :view do
  before(:each) do
    assign(:portfolios, [
      Portfolio.create!(
        :p_return => 1.5,
        :variance => 1.5
      ),
      Portfolio.create!(
        :p_return => 1.5,
        :variance => 1.5
      )
    ])
  end

  it "renders a list of portfolios" do
    render
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
