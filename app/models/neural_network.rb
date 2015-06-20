require 'ruby-fann'

class NeuralNetwork < ActiveRecord::Base

  belongs_to :predictable, polymorphic: true

  def backpropagation_predictions(currency)
    start_date = currency.exchange_rates.sort_by {|er| er.date}.first.date
    last_date = currency.exchange_rates.sort_by {|er| er.date}.last.date
    returns = currency.all_returns(start_date, last_date)
    returns.map! { |r| r + NORMALIZATION_CONSTANT}

    pp "the currency passed as parameter: #{currency.full_name}"
    pp "the returns passed as parameter are: #{returns.size}"
    predicted_returns = cross_validate(returns)
    predicted_returns.map! { |r| r - NORMALIZATION_CONSTANT}

    last_currency_er = currency.exchange_rates.last
    val = last_currency_er.last
    date = last_currency_er.date

    predicted_ers = []
    (0..OUTPUT_LS - 1).each do |i|
      val *= (1 + predicted_returns[i])
      date += 1.day
      predicted_ers << ExchangeRate.new(last: val, date: date, predictable: currency, predicted: true)
    end
    p_ers = currency.exchange_rates.select{|er| er.predicted == false}.sort_by{|er| er.date}.last(4) + predicted_ers
    predicted_ers =  normalisation(p_ers).drop(4)

    predicted_ers
  end

  def cross_validate(returns)
    inputs = []
    desired_outputs = []
    while(returns.size >= INPUT_LS + OUTPUT_LS)
      inputs << returns.first(INPUT_LS)
      desired_outputs << returns.first(INPUT_LS + OUTPUT_LS).last(OUTPUT_LS)
      returns.slice!(0)
    end

    train = RubyFann::TrainData.new(inputs: inputs, desired_outputs: desired_outputs)
    fann = RubyFann::Standard.new(num_inputs: INPUT_LS, hidden_neurons: [HIDDEN_LS, HIDDEN_LS], num_outputs: OUTPUT_LS)
    fann.train_on_data(train, MAX_ITERATIONS, 0, MSE) # 1000 max_epochs, 10 errors between reports and 0.1 desired MSE (mean-squared-error)
    fann.run(returns.last(INPUT_LS))
  end

  def normalisation(p_ers)
    p_ers.each_index do |i|
      if(i >= 4)
        rel_last = p_ers[i - 4..i].map{|er| er.last}
        p_ers[i].last = (0..LEARNING_C.size - 1).inject(0) {|s, j| s + LEARNING_C[j] * rel_last[j]}
        #(0...array_A.count).inject(0) {|r, i| r + array_A[i]*array_B[i]}
      end
    end
  end

  def optimise_network_parameters
    best_input_ls = 0
    least_differece = 0
  end

end
