require 'rails_helper'

RSpec.describe "predictions/new", type: :view do
  before(:each) do
    assign(:prediction, Prediction.new(
      :last_ad => 1
    ))
  end

  it "renders new prediction form" do
    render

    assert_select "form[action=?][method=?]", predictions_path, "post" do

      assert_select "input#prediction_last_ad[name=?]", "prediction[last_ad]"
    end
  end
end
