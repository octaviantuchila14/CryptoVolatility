require 'rails_helper'

RSpec.describe "Marketplaces", type: :request do
  describe "GET /marketplaces" do
    it "works! (now write some real specs)" do
      get marketplaces_path
      expect(response).to have_http_status(200)
    end
  end
end
