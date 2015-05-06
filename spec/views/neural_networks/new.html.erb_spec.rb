require 'rails_helper'

RSpec.describe "neural_networks/new", type: :view do
  before(:each) do
    assign(:neural_network, NeuralNetwork.new())
  end

  it "renders new neural_network form" do
    render

    assert_select "form[action=?][method=?]", neural_networks_path, "post" do
    end
  end
end
