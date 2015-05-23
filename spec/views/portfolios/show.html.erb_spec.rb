require 'rails_helper'

RSpec.describe "portfolios/show", type: :view do
  before(:each) do
    @portfolio = assign(:portfolio, Portfolio.create!(
      :p_return => 1.5,
      :variance => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
  end
end
