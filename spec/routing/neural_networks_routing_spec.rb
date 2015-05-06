require "rails_helper"

RSpec.describe NeuralNetworksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/neural_networks").to route_to("neural_networks#index")
    end

    it "routes to #new" do
      expect(:get => "/neural_networks/new").to route_to("neural_networks#new")
    end

    it "routes to #show" do
      expect(:get => "/neural_networks/1").to route_to("neural_networks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/neural_networks/1/edit").to route_to("neural_networks#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/neural_networks").to route_to("neural_networks#create")
    end

    it "routes to #update" do
      expect(:put => "/neural_networks/1").to route_to("neural_networks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/neural_networks/1").to route_to("neural_networks#destroy", :id => "1")
    end

  end
end
