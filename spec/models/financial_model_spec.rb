require 'rails_helper'

RSpec.describe FinancialModel, type: :model do
  it "computes capm" do
    fm = FinancialModel.new
    expect(fm.capm(2, 10, 4)).to eq(16)
  end
end
