class AddMaxReturnToPortfolio < ActiveRecord::Migration
  def change
    add_column :portfolios, :max_return, :float
  end
end
