require 'rails_helper'

RSpec.describe NeuralNetwork, type: :model do

  MAX_NR_OF_DAYS = 30
  ACCEPTED_ERROR = 20

  before(:each) do
    @currency = FactoryGirl.create(:currency)
    @neural_network = NeuralNetwork.create
    @currency.neural_network = @neural_network
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

  it "creates a prediction" do
    exchange_rates = []
    (0..99).each do |i|
      exchange_rates << FactoryGirl.create(:exchange_rate, last: i, time: DateTime.now - i.days)
    end
    prediction = @neural_network.predict(exchange_rates)
    expect(prediction).to_not be(nil)

    #check that the number of exchange rates within the prediction is equal to the total number of tests
    #multiplied by the validation constant
    #don't check for the dates of the exchange rates because they may be shuffled randomly
    expect(prediction.exchange_rates.where("predicted = ? AND time < ?", true, DateTime.now).size).to eq(((exchange_rates.size - MAX_OUTPUT_LAYER_SIZE)*(1-TRAINING_RATIO)).ceil)
  end

  it "updates an existing prediction" do

  end

  it "validates a neural network" do
    exchange_rates = []
    (0..MAX_INPUT_LAYER_SIZE + MAX_OUTPUT_LAYER_SIZE - 1).each do |i|
      exchange_rates << FactoryGirl.create(:exchange_rate, last: i, time: DateTime.now - i.days)
      @currency.exchange_rates << FactoryGirl.create(:exchange_rate, last: i + 1, time: DateTime.now - i.days)
    end

    @neural_network.train_network([@neural_network.normalize(exchange_rates.first(MAX_INPUT_LAYER_SIZE))],
                                     [@neural_network.normalize(exchange_rates.last(MAX_OUTPUT_LAYER_SIZE))])

    @neural_network.validate_network([@neural_network.normalize(exchange_rates.first(MAX_INPUT_LAYER_SIZE))],
                             [@neural_network.normalize(exchange_rates.last(MAX_OUTPUT_LAYER_SIZE))])
    expect(@neural_network.prediction).to_not be(nil)
    expect(@neural_network.prediction.exchange_rates.size).to eq(MAX_OUTPUT_LAYER_SIZE)
    expect(@neural_network.prediction.first_ad).to_not be(0)
    expect(@neural_network.prediction.first_chisq).to_not be(0)
  end

end
