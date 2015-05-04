require 'rails_helper'

RSpec.describe NeuralNetwork, type: :model do

  ACCEPTED_ERROR = 0.3

  #tests training function
  it "can create a f(x) = x function" do

    nn = NeuralNetwork.new
    returns = [[0.1, 0.1, 0.1]]
    expected_returns = [[0.2]]
    nn.train(returns, expected_returns)

    v_returns = [0.1, 0.1, 0.1]
    v_expected_return = [0.2]
    expect((nn.predict(v_returns))[0] - v_expected_return[0]).to be < ACCEPTED_ERROR
  end

  #tests training function
  it "can create a f(x) = x function with more examples" do

    nn = NeuralNetwork.new
    returns = [[0.2, 0.2, 0.2], [0.25, 0.25, 0.25], [0.3, 0.3, 0.3], [0.35, 0.35, 0.35], [0.4, 0.4, 0.4], [0.5, 0.5, 0.5]]
    expected_returns = [[0.4], [0.5], [0.6], [0.7], [0.8], [1.0]]
    nn.train(returns, expected_returns)

    v_returns = [0.2, 0.2, 0.2]
    v_expected_return = [0.4]
    expect((nn.predict(v_returns))[0] - v_expected_return[0]).to be < ACCEPTED_ERROR
  end
end
