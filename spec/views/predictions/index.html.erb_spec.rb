require 'rails_helper'

RSpec.describe "predictions/index", type: :view do
  before(:each) do
    assign(:predictions, [
      Prediction.create!(
        :last_ad => 1
      ),
      Prediction.create!(
        :last_ad => 1
      )
    ])
  end

end
