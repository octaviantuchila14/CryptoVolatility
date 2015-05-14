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

    prediction = currency.@neural_network.predict
    expect(prediction.average_difference).to be > 0
  end

  it "gives a relatively accurate prediction for models which are predictable" do
    currency = FactoryGirl.create(:currency)
    (0..99).each do |i|
      currency.exchange_rates << FactoryGirl.create(:exchange_rate, subject: currency.name, last: i, time: DateTime.now - i.days)
    end
    prediction = currency.@neural_network.predict
    (100...129).each do |i|
      expect(prediction.exchange_rates[i - 100].last).to be_between(i - ACCEPTED_ERROR, i + ACCEPTED_ERROR)
    end

  end
=end

  before(:each) do
    @neural_network = NeuralNetwork.create
  end


  it "transforms exchange rates into normalized data" do
    exchange_rates = []
    (0..9).each do |i|
      exchange_rates << FactoryGirl.create(:exchange_rate, last: i, time: DateTime.now - i.days)
    end
    exchange_rates.sort_by!{|er| er.time}

    normalized_data = @neural_network.normalize(exchange_rates)

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

    exchange_rates = @neural_network.denormalize(normalized_data)

    expect(normalized_data.size).to eq(exchange_rates.size)
    exchange_rates.each_index do |i|
      expect(normalized_data[i] * NORMALIZATION_CONSTANT).to eq(exchange_rates[i].last)
      if(i + 1 < exchange_rates.size)
        expect(exchange_rates[i].time.day).to eq(exchange_rates[i + 1].time.day - 1)
      end
    end
  end

  it "cuts data into an array of inputs and outputs" do
    normalized_data = []
    (0..99).each do |i|
      normalized_data << i / NORMALIZATION_CONSTANT
    end

    input = @neural_network.separate_inputs(normalized_data)
    expect(input.size).to eq(normalized_data.size - MAX_INPUT_LAYER_SIZE - MAX_OUTPUT_LAYER_SIZE + 1)
    input.each_index do |i|
      expect(input[i].size).to eq(MAX_INPUT_LAYER_SIZE)
      input[i].each_index do |j|
        expect(input[i][j]).to eq(normalized_data[i + j])
      end
    end

    output = @neural_network.separate_outputs(normalized_data)
    expect(output.size).to eq(normalized_data.size - MAX_INPUT_LAYER_SIZE - MAX_OUTPUT_LAYER_SIZE + 1)
    output.each_index do |i|
      expect(output[i].size).to eq(MAX_OUTPUT_LAYER_SIZE)
      output[i].each_index do |j|
        expect(output[i][j]).to eq(normalized_data[MAX_INPUT_LAYER_SIZE + i + j])
      end
    end
  end


  it "trains a neural network which outputs predictions for MAX_PREDICTION_DAYS" do
    normalized_data = []
    (0..99).each do |i|
      normalized_data << i.to_f / NORMALIZATION_CONSTANT
    end

    input = @neural_network.separate_inputs(normalized_data)
    output = @neural_network.separate_outputs(normalized_data)

    fann = @neural_network.get_network
    expect(fann).to eq(nil)
    @neural_network.train_network(input, output)
    fann = @neural_network.get_network
    expect(fann).to_not eq(nil)

    verify_input = []
    (0..MAX_INPUT_LAYER_SIZE - 1).each do |i|
      verify_input <<  i.to_f/ NORMALIZATION_CONSTANT
    end
    verify_output = fann.run(verify_input)

    #p "inputs are #{verify_input}"
    #p "outputs are #{verify_output}"
    (MAX_INPUT_LAYER_SIZE..MAX_INPUT_LAYER_SIZE + MAX_OUTPUT_LAYER_SIZE - 1).each do |i|
      expect(verify_output[i - MAX_INPUT_LAYER_SIZE]).to be_between((i - ACCEPTABLE_RATE_VARIATION)/NORMALIZATION_CONSTANT,
                                                                    (i + ACCEPTABLE_RATE_VARIATION)/NORMALIZATION_CONSTANT);
    end

  end

  it "verifies the accuracy of the neural network, measuring with avergae difference and average last_chisq" do

  end

end
