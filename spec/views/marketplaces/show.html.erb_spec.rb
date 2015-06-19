require 'rails_helper'

RSpec.describe "marketplaces/show", type: :view do
  before(:each) do
    @marketplace = assign(:marketplace, Marketplace.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
