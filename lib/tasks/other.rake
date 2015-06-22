namespace :other do

  @coins = ["btc", "ltc", "nmc", "nvc", "ppc", "xrp", "doge", "ftc", "nxt", "xpy"]

  task scrape_gt: :environment do
    @coins.each do |coin|
      csv_prices = Curl.post("https://www.google.com/trends/", {label: coin}).body_str
      file = File.join(Rails.root, 'tmp', 'csvFiles', label_str + ".csv")
      File.open(file, "w") do |file|
        csv_prices = ["DATE, TIME, Accuracy, r1, r2, r3\n", csv_prices].join if(["xrp", "xpy"].include?(coin))
        file.puts csv_prices.gsub(label_str + ", ", "")
      end
    end
  end

  task reccurent: :environment do
    tlearn = TLearn::Run.new(:number_of_nodes => 86,
                             :output_nodes    => 41..46,
                             :linear          => 47..86,
                             :weight_limit    => 1.00,
                             :connections     => [{1..81   => 0},
                                                  {1..40   => :i1..:i77},
                                                  {41..46  => 1..40},
                                                  {1..40   => 47..86},
                                                  {47..86  => [1..40, {:max => 1.0, :min => 1.0}, :fixed, :one_to_one]}])
    inputs = []
    outputs = []
    training_data = []

    (0..30).each do |i|
      inputs << []
      outputs << []
      (0..76).each do |j|
        inputs[i] << (i + j)/1000
      end

      (77..82).each do |j|
        outputs[i] << (76 + i + j)/1000
      end

      # p training_data
      # p "inputs are #{inputs[i]}"
      # p "outputs are #{outputs[i]}"
      training_data << {inputs[i] => outputs[i]}
    end


    # training_data = [{inputs[0] => outputs[0]}],
    #                 [{inputs[1] => outputs[1]}]

    tlearn.train(training_data, sweeps = 1000)
    res = tlearn.fitness(inputs[0], sweeps = 1000)

    pp "res is #{res.class}, #{res}"
  end

end


