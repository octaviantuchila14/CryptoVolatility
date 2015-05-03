class NeuralNetwork < ActiveRecord::Base
  #for now, it predicts only the following day
  MAX_INPUT_LAYER_SIZE = 7
  MAX_HIDDEN_LAYER_SIZE = 11
  MAX_EPOCHS = 10

=begin
  #returns & expectedReturns are of type ExchangeRate
  def optimize_parameters(returns, expectedReturns)

    best_f1 = -1
    bils = -1, bhls = -1, be = -1

    (1..MAX_INPUT_LAYER_SIZE).each do |ils|
      (1..MAX_HIDDEN_LAYER_SIZE).each do |hls|
        (1..MAX_EPOCHS).each do |e|

        end
      end
    end

  end
=end

end
