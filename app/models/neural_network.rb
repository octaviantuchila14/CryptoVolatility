require 'ruby-fann'

class NeuralNetwork < ActiveRecord::Base

  belongs_to :currency, inverse_of: :neural_network

  #for now, it predicts only the following day
  MAX_INPUT_LAYER_SIZE = 7
  MAX_HIDDEN_LAYER_SIZE = 11
  MAX_EPOCHS = 1000
  MAX_OUTPUTS = 1
  MSE = 0.0000000001
  ACCEPTABLE_ERROR = 0.01

  def initialize
    self.max_nr_of_days = 30
  end

  def train(inputs, desired_outputs)
    train = RubyFann::TrainData.new(inputs: inputs, desired_outputs: desired_outputs)
    @fann = RubyFann::Standard.new(:num_inputs=>MAX_INPUT_LAYER_SIZE,
                                   :hidden_neurons=>[MAX_HIDDEN_LAYER_SIZE, MAX_HIDDEN_LAYER_SIZE], :num_outputs=>self.max_nr_of_days)
    @fann.train_on_data(train, MAX_EPOCHS, 0, MSE) # 1000 max_epochs, 10 errors between reports and 0.1 desired MSE (mean-squared-error)
  end


  def give_result(days = self.max_nr_of_days)
  end

  #make market data be between 0 and 1
  def normalise

  end

end
