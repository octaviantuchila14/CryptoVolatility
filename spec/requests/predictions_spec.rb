require 'rails_helper'

RSpec.describe "Predictions", type: :request do
  describe "GET /predictions" do
    it "works! (now write some real specs)" do
      get predictions_path
      expect(response).to have_http_status(200)
    end
  end
end
