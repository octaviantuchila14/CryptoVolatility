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

end
