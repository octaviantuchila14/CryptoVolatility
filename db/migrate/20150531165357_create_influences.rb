class CreateInfluences < ActiveRecord::Migration
  def change
    create_table :influences do |t|
      t.integer :knn_id
      t.integer :article_id
      t.string :classification

      t.timestamps null: false
    end
  end
end
