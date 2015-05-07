require 'ruby-fann'

class NeuralNetwork < ActiveRecord::Base

  belongs_to :currency, inverse_of: :neural_network
  has_one :prediction

  #for now, it predicts only the following day
  MAX_INPUT_LAYER_SIZE = 40
  MAX_HIDDEN_LAYER_SIZE = 50
  MAX_EPOCHS = 1000
  MAX_OUTPUTS = 1
  MSE = 0.0000000001
  ACCEPTABLE_ERROR = 0.01
  NORMALISATION_CONSTANT = 2000

  self.after_initialize do
    self.max_nr_of_days = 30
  end


  def train(inputs, desired_outputs)
    train = RubyFann::TrainData.new(inputs: inputs, desired_outputs: desired_outputs)
    @fann = RubyFann::Standard.new(:num_inputs=>MAX_INPUT_LAYER_SIZE,
                                   :hidden_neurons=>[MAX_HIDDEN_LAYER_SIZE, MAX_HIDDEN_LAYER_SIZE], :num_outputs=>self.max_nr_of_days)
    @fann.train_on_data(train, MAX_EPOCHS, 0, MSE) # 1000 max_epochs, 10 errors between reports and 0.1 desired MSE (mean-squared-error)
  end

  def predict
    if(self.prediction == nil)
      @exchange_rates = ExchangeRate.where(subject: self.currency.name)
      #@exchange_rates = ExchangeRate.where(subject: self.currency.name, date: Date.today - self.max_nr_of_days..Date.today)
      @exchange_rates.sort_by { |er| er.date}
      daily_values = []
      @exchange_rates.each do |er|
        daily_values << (er.last / NORMALISATION_CONSTANT)
      end
      optimise_training daily_values

      self.create_prediction
      self.prediction.exchange_rates = @fann.run(daily_values.last(self.max_nr_of_days))
    end
    prediction
  end

  #TODO: make it vary the parameters for input layer size, hidden layer size, number of epochs
  def optimise_training(daily_values)
    inputs = [], outputs = []
    (1..(daily_values.size - self.max_nr_of_days - MAX_INPUT_LAYER_SIZE)) do |i|
      inputs << daily_values.between(i, i + MAX_INPUT_LAYER_SIZE - 1)
      outputs << daily_values.between(i + MAX_INPUT_LAYER_SIZE, i + self.max_nr_of_days + MAX_INPUT_LAYER_SIZE - 1)
    train(inputs, outputs)
  end

end
