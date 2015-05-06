require 'rails_helper'

RSpec.describe "neural_networks/show", type: :view do
  before(:each) do
    @neural_network = assign(:neural_network, NeuralNetwork.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
