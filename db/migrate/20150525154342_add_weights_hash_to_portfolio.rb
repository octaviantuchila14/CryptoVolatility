class AddWeightsHashToPortfolio < ActiveRecord::Migration
  def change
    add_column :portfolios, :weights, :hstore
  end
end
