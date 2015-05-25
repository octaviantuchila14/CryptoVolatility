class SetVarianceDefaultValue < ActiveRecord::Migration
  def change
    change_column :portfolios, :variance, :float, default: 0
  end
end