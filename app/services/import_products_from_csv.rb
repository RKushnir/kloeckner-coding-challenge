require "csv"
require "database_lock"

class ImportProductsFromCsv
  IMPORT_LOCK_ID = 1
  ImportAlreadyInProgress = Class.new(StandardError)

  def call(csv_file)
    DatabaseLock.acquire(IMPORT_LOCK_ID) do
      new_import_version = select_next_import_version

      CSV.foreach(csv_file, col_sep: "|", headers: true, skip_blanks: true) do |row|
        persist_product(row["PART_NUMBER"],
          branch_code:          row["BRANCH_ID"],
          part_price_usd_cents: parse_price(row["PART_PRICE"]),
          short_description:    row["SHORT_DESC"],
          import_version:       new_import_version,
        )
      end

      delete_obsolete_products(new_import_version)
    end
  rescue DatabaseLock::Timeout
    raise ImportAlreadyInProgress
  end

  private

  def select_next_import_version
    ActiveRecord::Base.connection.select_value "SELECT nextval('products_import_version_seq')"
  end

  def persist_product(part_number, attributes)
    product = Product.find_or_initialize_by(part_number: part_number)
    product.update!(attributes)
  end

  def delete_obsolete_products(current_version)
    Product.where("import_version < ?", current_version).delete_all
  end

  def parse_price(value)
    (Float(value) * 100).to_i
  end
end
