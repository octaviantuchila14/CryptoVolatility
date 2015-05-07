require 'rails_helper'

RSpec.describe NeuralNetwork, type: :model do

  MAX_NR_OF_DAYS = 30
  ACCEPTED_ERROR = 0.3
=begin
  #tests training function
  it "can create a f(x) = x function" do

    nn = NeuralNetwork.new
    returns = [[0.1, 0.1, 0.1]]
    expected_returns = [[0.2]]
    nn.train(returns, expected_returns)

    v_returns = [0.1, 0.1, 0.1]
    v_expected_return = [0.2]
    expect((nn.give_result(v_returns))[0] - v_expected_return[0]).to be < ACCEPTED_ERROR
  end

  #tests training function
  it "can create a f(x) = x function with more examples" do

    nn = NeuralNetwork.new
    returns = [[0.2, 0.2, 0.2], [0.25, 0.25, 0.25], [0.3, 0.3, 0.3], [0.35, 0.35, 0.35], [0.4, 0.4, 0.4], [0.5, 0.5, 0.5]]
    expected_returns = [[0.4], [0.5], [0.6], [0.7], [0.8], [1.0]]
    nn.train(returns, expected_returns)

    v_returns = [0.2, 0.2, 0.2]
    v_expected_return = [0.4]
    expect((nn.give_result(v_returns))[0] - v_expected_return[0]).to be < ACCEPTED_ERROR
  end
=end

  it "returns a prediction having 30 days" do
    currency = FactoryGirl.create(:currency)
    currency.create_neural_network
    (1..30 + 1).each do
      FactoryGirl.create(:exchange_rate, name: currency.name)
    end

    prediction = currency.neural_network.give_result
    expect(prediction.f1).to be between(0, 1)
    expect(prediction.accuracy).to be between(0, 1)
    expect(prediction.recall).to be between(0, 1)
  end

end
