require 'rails_helper'

RSpec.describe NeuralNetwork, type: :model do

  #tests training function
  it "can create a linear function between expected returns and actual returns" do
    returns = Set.new
    returns.add(ExchangeRate.new(subject: "^GSPC", last: 2, ref_cr: "usd", date: Date.today - 5))
    returns.add(ExchangeRate.new(subject: "^GSPC", last: 2, ref_cr: "usd", date: Date.today - 4))
    expected_return = ExchangeRate.new(subject: "^GSPC", last: 4, ref_cr: "usd", date: Date.today - 3)

    nn = NeuralNetwork.new(epochs:3, hidden_layer_size:3, input_layer_size:2)
    nn.train(returns, expected_return)


    v_returns = Set.new
    v_returns.add(ExchangeRate.new(subject: "^GSPC", last: 2, ref_cr: "usd", date: Date.today - 2))
    v_returns.add(ExchangeRate.new(subject: "^GSPC", last: 2, ref_cr: "usd", date: Date.today - 1))
    v_expected_return = ExchangeRate.new(subject: "^GSPC", last: 4, ref_cr: "usd", date: Date.today)

    expect(nn.predict(v_returns)).to equal(v_expected_return)
  end
end
