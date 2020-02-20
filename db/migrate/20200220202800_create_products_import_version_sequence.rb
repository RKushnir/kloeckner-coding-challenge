class CreateProductsImportVersionSequence < ActiveRecord::Migration[6.0]
  def up
    execute "CREATE SEQUENCE products_import_version_seq"
  end

  def down
    execute "DROP SEQUENCE products_import_version_seq"
  end
end
