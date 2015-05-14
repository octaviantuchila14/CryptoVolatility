require 'rails_helper'

RSpec.describe "predictions/edit", type: :view do
  before(:each) do
    @prediction = assign(:prediction, Prediction.create!(
      :last_ad => 1
    ))
  end

  it "renders the edit prediction form" do
    render

    assert_select "form[action=?][method=?]", prediction_path(@prediction), "post" do

      assert_select "input#prediction_last_ad[name=?]", "prediction[last_ad]"
    end
  end
end
