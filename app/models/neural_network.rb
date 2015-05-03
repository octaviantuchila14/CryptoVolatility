require 'ruby-fann'

class NeuralNetwork < ActiveRecord::Base
  #for now, it predicts only the following day
  MAX_INPUT_LAYER_SIZE = 7
  MAX_HIDDEN_LAYER_SIZE = 11
  MAX_EPOCHS = 1000
  MAX_OUTPUTS = 1
  MSE = 0.1

  def train(inputs, desired_outputs)
    train = RubyFann::TrainData.new(inputs: inputs, desired_outputs: desired_outputs)
    @fann = RubyFann::Standard.new(:num_inputs=>3, :hidden_neurons=>[2, 8, 4, 3, 4], :num_outputs=>1)
    @fann.train_on_data(train, MAX_EPOCHS, 10, MSE) # 1000 max_epochs, 10 errors between reports and 0.1 desired MSE (mean-squared-error)
  end

  def predict(input)
    @fann.run(input)
  end

end
