require 'rails_helper'

RSpec.describe "marketplaces/new", type: :view do
  before(:each) do
    assign(:marketplace, Marketplace.new())
  end

  it "renders new marketplace form" do
    render

    assert_select "form[action=?][method=?]", marketplaces_path, "post" do
    end
  end
end
