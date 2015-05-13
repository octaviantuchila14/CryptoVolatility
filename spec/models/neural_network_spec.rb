require 'rails_helper'

RSpec.describe NeuralNetwork, type: :model do

  MAX_NR_OF_DAYS = 30
  ACCEPTED_ERROR = 20
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
=begin
  it "returns a prediction having 30 days" do
    currency = FactoryGirl.create(:currency)
    (0..100).each do |i|
      currency.exchange_rates << FactoryGirl.create(:exchange_rate, subject: currency.name, last: 10*i, time: DateTime.now - i.days)
    end

    prediction = currency.neural_network.predict
    expect(prediction.average_difference).to be > 0
  end

  it "gives a relatively accurate prediction for models which are predictable" do
    currency = FactoryGirl.create(:currency)
    (0..99).each do |i|
      currency.exchange_rates << FactoryGirl.create(:exchange_rate, subject: currency.name, last: i, time: DateTime.now - i.days)
    end
    prediction = currency.neural_network.predict
    (100...129).each do |i|
      expect(prediction.exchange_rates[i - 100].last).to be_between(i - ACCEPTED_ERROR, i + ACCEPTED_ERROR)
    end

  end
=end


  it "transforms exchange rates into normalized data" do
    exchange_rates = []
    (0..9).each do |i|
      exchange_rates << FactoryGirl.create(:exchange_rate, last: i, time: DateTime.now - i.days)
    end
    exchange_rates.sort_by!{|er| er.time}

    neural_network = NeuralNetwork.create
    normalized_data = neural_network.normalize(exchange_rates)

    expect(normalized_data.size).to eq(exchange_rates.size)
    exchange_rates.each_index do |i|
      expect(normalized_data[i] * NORMALIZATION_CONSTANT).to eq(exchange_rates[i].last)
    end
  end

  it "transforms normalized data into exchange rates" do
    normalized_data = []
    (0..9).each do |i|
      normalized_data << i / NORMALIZATION_CONSTANT
    end

    neural_network = NeuralNetwork.create
    exchange_rates = neural_network.denormalize(normalized_data)

    expect(normalized_data.size).to eq(exchange_rates.size)
    exchange_rates.each_index do |i|
      expect(normalized_data[i] * NORMALIZATION_CONSTANT).to eq(exchange_rates[i].last)
      if(i + 1 < exchange_rates.size)
        expect(exchange_rates[i].time.day).to eq(exchange_rates[i + 1].time.day - 1)
      end
    end
  end

end
