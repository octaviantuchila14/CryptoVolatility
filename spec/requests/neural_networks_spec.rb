require 'rails_helper'

RSpec.describe "NeuralNetworks", type: :request do
  describe "GET /neural_networks" do
    it "works! (now write some real specs)" do
      get neural_networks_path
      expect(response).to have_http_status(200)
    end
  end
end
