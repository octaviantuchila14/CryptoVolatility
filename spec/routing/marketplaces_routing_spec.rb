require "rails_helper"

RSpec.describe MarketplacesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/marketplaces").to route_to("marketplaces#index")
    end

    it "routes to #new" do
      expect(:get => "/marketplaces/new").to route_to("marketplaces#new")
    end

    it "routes to #show" do
      expect(:get => "/marketplaces/1").to route_to("marketplaces#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/marketplaces/1/edit").to route_to("marketplaces#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/marketplaces").to route_to("marketplaces#create")
    end

    it "routes to #update" do
      expect(:put => "/marketplaces/1").to route_to("marketplaces#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/marketplaces/1").to route_to("marketplaces#destroy", :id => "1")
    end

  end
end
