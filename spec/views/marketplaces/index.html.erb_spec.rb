require 'rails_helper'

RSpec.describe "marketplaces/index", type: :view do
  before(:each) do
    assign(:marketplaces, [
      Marketplace.create!(),
      Marketplace.create!()
    ])
  end

  it "renders a list of marketplaces" do
    render
  end
end
