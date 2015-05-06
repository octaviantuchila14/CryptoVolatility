require 'ruby-fann'

class NeuralNetwork < ActiveRecord::Base

  belongs_to :currency, inverse_of: :neural_network

  #for now, it predicts only the following day
  MAX_INPUT_LAYER_SIZE = 7
  MAX_HIDDEN_LAYER_SIZE = 11
  MAX_EPOCHS = 1000
  MAX_OUTPUTS = 1
  MSE = 0.0000000001

  def train(inputs, desired_outputs)
    train = RubyFann::TrainData.new(inputs: inputs, desired_outputs: desired_outputs)
    @fann = RubyFann::Standard.new(:num_inputs=>3, :hidden_neurons=>[3, 3], :num_outputs=>1)
    @fann.train_on_data(train, MAX_EPOCHS, 0, MSE) # 1000 max_epochs, 10 errors between reports and 0.1 desired MSE (mean-squared-error)
  end

  def give_result(time)
  end

end
