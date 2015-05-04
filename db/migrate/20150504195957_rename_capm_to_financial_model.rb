class RenameCapmToFinancialModel < ActiveRecord::Migration
  def change
    rename_table :capms, :financial_models
  end
end
