class SetDefaultValueToVolume < ActiveRecord::Migration
  def change
    change_column :exchange_rates, :volume, :float, default: 0
  end
end
