require 'ruby-fann'

class NeuralNetwork < ActiveRecord::Base

  belongs_to :predictable, polymorphic: true

  def backpropagation_predictions(currency)
    start_date = currency.exchange_rates.sort_by {|er| er.date}.last.date
    last_date = currency.exchange_rates.sort_by {|er| er.date}.first.date
    returns = currency.all_returns(start_date, last_date)
    returns.map! { |r| r += NORMALIZATION_CONSTANT}

    create_groups(returns)
  end


end
