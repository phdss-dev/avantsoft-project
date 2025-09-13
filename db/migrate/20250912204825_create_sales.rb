class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales do |t|
      t.references :client, null: false, foreign_key: true
      t.integer :value
      t.datetime :date
      t.text :description

      t.timestamps
    end
  end
end
