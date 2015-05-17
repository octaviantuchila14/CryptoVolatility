require 'rails_helper'

RSpec.describe "markets/index", type: :view do
  before(:each) do
    assign(:markets, [
      Market.create!(),
      Market.create!()
    ])
  end

  it "renders a list of markets" do
    render
  end
end
