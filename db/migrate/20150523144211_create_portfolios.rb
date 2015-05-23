class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.date :start_date
      t.date :end_date
      t.float :p_return
      t.float :variance

      t.timestamps null: false
    end
  end
end
