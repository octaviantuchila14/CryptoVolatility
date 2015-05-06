require 'rails_helper'

RSpec.describe "neural_networks/index", type: :view do
  before(:each) do
    assign(:neural_networks, [
      NeuralNetwork.create!(),
      NeuralNetwork.create!()
    ])
  end

  it "renders a list of neural_networks" do
    render
  end
end
