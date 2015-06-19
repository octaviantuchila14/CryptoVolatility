require 'rails_helper'

RSpec.describe "marketplaces/edit", type: :view do
  before(:each) do
    @marketplace = assign(:marketplace, Marketplace.create!())
  end

  it "renders the edit marketplace form" do
    render

    assert_select "form[action=?][method=?]", marketplace_path(@marketplace), "post" do
    end
  end
end
