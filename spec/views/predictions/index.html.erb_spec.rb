require 'rails_helper'

RSpec.describe "predictions/index", type: :view do
  before(:each) do
    assign(:predictions, [
      Prediction.create!(
        :average_difference => 1
      ),
      Prediction.create!(
        :average_difference => 1
      )
    ])
  end

  it "renders a list of predictions" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
