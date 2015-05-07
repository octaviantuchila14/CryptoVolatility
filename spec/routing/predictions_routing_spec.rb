require "rails_helper"

RSpec.describe PredictionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/predictions").to route_to("predictions#index")
    end

    it "routes to #new" do
      expect(:get => "/predictions/new").to route_to("predictions#new")
    end

    it "routes to #show" do
      expect(:get => "/predictions/1").to route_to("predictions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/predictions/1/edit").to route_to("predictions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/predictions").to route_to("predictions#create")
    end

    it "routes to #update" do
      expect(:put => "/predictions/1").to route_to("predictions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/predictions/1").to route_to("predictions#destroy", :id => "1")
    end

  end
end
