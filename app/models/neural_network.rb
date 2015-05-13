require 'ruby-fann'

class NeuralNetwork < ActiveRecord::Base

  belongs_to :currency, inverse_of: :neural_network
  has_one :prediction

  #for now, it predicts only the following day
  MAX_INPUT_LAYER_SIZE = 40
  MAX_HIDDEN_LAYER_SIZE = 50
  MAX_EPOCHS = 50
  MAX_OUTPUTS = 1
  MSE = 0.0000000001
  ACCEPTABLE_ERROR = 0.01
  TRAINING_DATA_PERCENTAGE = 0.8

  self.after_initialize do
    self.max_nr_of_days = 30
  end

  def predict
    if(self.prediction == nil)
      @exchange_rates = self.currency.exchange_rates
      @exchange_rates.sort_by { |er| er.time}
      daily_values = []
      @exchange_rates.each do |er|
        daily_values << (er.last)
      end

      self.create_prediction

      optimise_training daily_values


      predicted_rates = @fann.run(daily_values.last(MAX_INPUT_LAYER_SIZE).map!{ |dv| dv / NORMALIZATION_CONSTANT}).map!{|dv| dv * NORMALIZATION_CONSTANT}

      (0..predicted_rates.size - 1).each do |i|
        #ASS: I'm getting the data for today at the beginning of the day
        #TODO change from create to new
        self.prediction.exchange_rates.create(subject: @exchange_rates.first.subject, ref_cr: @exchange_rates.first.ref_cr,
                                              last: predicted_rates[i], time: DateTime.now + (i + 1).days, predicted: true)
      end
    end
    self.prediction
  end

  #TODO: make it vary the parameters for input layer size, hidden layer size, number of epochs
  def optimise_training(daily_values)
    inputs = [], outputs = []
    (0..(daily_values.size - self.max_nr_of_days - MAX_INPUT_LAYER_SIZE)).each do |i|
      inputs[i] = daily_values[i .. i + MAX_INPUT_LAYER_SIZE - 1]
      outputs[i] = daily_values[i + MAX_INPUT_LAYER_SIZE .. i + self.max_nr_of_days + MAX_INPUT_LAYER_SIZE - 1]
    end

    nr_train = (TRAINING_DATA_PERCENTAGE*inputs.size).floor
    nr_validate = inputs.size - nr_train

    train_inputs = inputs.first(nr_train)
    train_outputs = outputs.first(nr_train)
    validate_inputs = inputs.last(nr_validate)
    validate_outputs = outputs.last(nr_validate)

    train(train_inputs, train_outputs)
    validate(validate_inputs, validate_outputs)
  end

  #TODO: maybe search a way of quantifying the difference between outputs and desired outputs which is better than the average difference
  def validate(inputs, desired_outputs)
    avg = 0.0
    nr = 0
    chi_sq = 0.0
    (0..inputs.size - 1).each do |i|
      output = @fann.run(inputs[i].map!{ |dv| dv / NORMALIZATION_CONSTANT}).map!{|dv| dv * NORMALIZATION_CONSTANT}

      avg += (output - desired_outputs[i]).map!{ |x| x.abs }.reduce(:+)
      nr += output.size
      chi_sq += compute_chi(output, desired_outputs[i])
    end
    self.prediction.average_difference = avg / nr
    self.prediction.chi_squared = chi_sq
  end

  def train(inputs, desired_outputs)
    inputs = inputs.map!{|x| x.map!{ |y| y / NORMALIZATION_CONSTANT}}
    desired_outputs.map!{|x| x.map!{ |y| y / NORMALIZATION_CONSTANT}}

    inputs.each do |i|
      i.each do |x|
        raise "inputs not in bounds, #{x}!"  unless x.between?(0, 1)
      end
    end
    desired_outputs.each do |i|
      i.each do |x|
        raise "inputs not in bounds, #{x}!"  unless x.between?(0, 1)
      end
    end

    train = RubyFann::TrainData.new(inputs: inputs, desired_outputs: desired_outputs)
    @fann = RubyFann::Standard.new(:num_inputs=>MAX_INPUT_LAYER_SIZE,
                                   :hidden_neurons=>[MAX_HIDDEN_LAYER_SIZE, MAX_HIDDEN_LAYER_SIZE], :num_outputs=>self.max_nr_of_days)
    @fann.train_on_data(train, MAX_EPOCHS, 0, MSE) # 1000 max_epochs, 10 errors between reports and 0.1 desired MSE (mean-squared-error)
  end

  def compute_chi(obtained, expected)
    sum = 0.0
    (0..obtained.size - 1).each do |i|
      sum += (obtained[i] - expected[i])/expected[i]
    end
    sum
  end

  def normalize(exchange_rates)
    exchange_rates.sort_by!{ |er| er.time }
    normalized_data = []
    exchange_rates.each do |er|
      normalized_data << (er.last/NORMALIZATION_CONSTANT)
    end
    normalized_data
  end

  def denormalize(normalized_data)
    exchange_rates = []
    normalized_data.each_index do |i|
      exchange_rates << ExchangeRate.new(time: DateTime.now + i.days, last: normalized_data[i]*NORMALIZATION_CONSTANT)
    end
    exchange_rates
  end

end
