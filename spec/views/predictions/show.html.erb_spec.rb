require 'rails_helper'

RSpec.describe "predictions/show", type: :view do
  before(:each) do
    @prediction = assign(:prediction, Prediction.create!(
      :average_difference => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
  end
end
