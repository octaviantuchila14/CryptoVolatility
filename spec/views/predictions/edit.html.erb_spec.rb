require 'rails_helper'

RSpec.describe "predictions/edit", type: :view do
  before(:each) do
    @prediction = assign(:prediction, Prediction.create!(
      :average_difference => 1
    ))
  end

  it "renders the edit prediction form" do
    render

    assert_select "form[action=?][method=?]", prediction_path(@prediction), "post" do

      assert_select "input#prediction_average_difference[name=?]", "prediction[average_difference]"
    end
  end
end
