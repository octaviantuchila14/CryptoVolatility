require 'rails_helper'

RSpec.describe "predictions/new", type: :view do
  before(:each) do
    assign(:prediction, Prediction.new(
      :average_difference => 1
    ))
  end

  it "renders new prediction form" do
    render

    assert_select "form[action=?][method=?]", predictions_path, "post" do

      assert_select "input#prediction_average_difference[name=?]", "prediction[average_difference]"
    end
  end
end
