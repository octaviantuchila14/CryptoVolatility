require 'rails_helper'

RSpec.describe "neural_networks/edit", type: :view do
  before(:each) do
    @neural_network = assign(:neural_network, NeuralNetwork.create!())
  end

  it "renders the edit neural_network form" do
    render

    assert_select "form[action=?][method=?]", neural_network_path(@neural_network), "post" do
    end
  end
end
