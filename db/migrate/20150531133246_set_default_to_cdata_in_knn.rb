class SetDefaultToCdataInKnn < ActiveRecord::Migration
  def change
    change_column :knns, :cdata, :hstore, default: {}
  end
end
