require 'rails_helper'

RSpec.describe "predictions/show", type: :view do
  before(:each) do
    @prediction = assign(:prediction, Prediction.create!(
      :average_difference => 1
    ))
  end

end
