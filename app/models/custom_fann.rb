class CustomFann < ActiveRecord::Base
  #can be used to
  def training_callback(args)
    node_val = args[0]
    weight1 = args[1]
    delta = args[2]
    iterations = args[3]

    res_weight = weight1 * LEARNING_RATE + delta * (1 - weight1)

    if(iterations == MAX_ITERATIONS)
      node_val -= 1
      args[0] = node_val
      return -1
    end
    args[1] = res_weight
    return
  end
end
