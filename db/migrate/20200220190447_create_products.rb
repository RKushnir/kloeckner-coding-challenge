class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.text :part_number, null: false, index: { unique: true }
      t.text :branch_code, null: false
      t.integer :part_price_usd_cents, null: false
      t.text :short_description

      t.timestamps
    end
  end
end
