require 'rails_helper'

RSpec.describe NeuralNetwork, type: :model do

  #tests training function
  it "can create a linear function between expected returns and actual returns" do

    nn = NeuralNetwork.new
    returns = [[2, 2, 2], [3, 3, 3]]
    expected_returns = [4, 6]
    nn.train(returns, expected_returns)

    v_returns = [1, 1]
    v_expected_return = [2]
    expect(nn.predict(v_returns)).to equal(v_expected_return)
  end
end
