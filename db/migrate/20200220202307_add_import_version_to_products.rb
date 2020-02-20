class AddImportVersionToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :import_version, :bigint, null: false, default: 0, index: true
  end
end
