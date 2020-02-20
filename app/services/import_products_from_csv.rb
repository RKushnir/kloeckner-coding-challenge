require "csv"
require "database_lock"

class ImportProductsFromCsv
  IMPORT_LOCK_ID = 1
  ImportAlreadyInProgress = Class.new(StandardError)

  class ProductRow
    def initialize(csv_row)
      @csv_row = csv_row
    end

    def part_number
      @csv_row["PART_NUMBER"]
    end

    def branch_code
      @csv_row["BRANCH_ID"]
    end

    def part_price_usd_cents
      parse_price(@csv_row["PART_PRICE"])
    end

    def short_description
      @csv_row["SHORT_DESC"]
    end

    private

    def parse_price(value)
      (Float(value) * 100).to_i
    end
  end

  def call(csv_file)
    prevent_concurrent_imports do
      new_import_version = select_next_import_version

      CSV.foreach(csv_file, col_sep: "|", headers: true, skip_blanks: true) do |row|
        product_row = ProductRow.new(row)
        persist_product(product_row, new_import_version)
      end

      delete_obsolete_products(new_import_version)
    end
  end

  private

  def prevent_concurrent_imports(&block)
    DatabaseLock.acquire(IMPORT_LOCK_ID, &block)
  rescue DatabaseLock::Timeout
    raise ImportAlreadyInProgress
  end

  def select_next_import_version
    ActiveRecord::Base.connection.select_value "SELECT nextval('products_import_version_seq')"
  end

  def persist_product(product_row, import_version)
    product = Product.find_or_initialize_by(part_number: product_row.part_number)
    product.update!(
      branch_code:          product_row.branch_code,
      part_price_usd_cents: product_row.part_price_usd_cents,
      short_description:    product_row.short_description,
      import_version:       import_version,
    )
  end

  def delete_obsolete_products(current_version)
    Product.where("import_version < ?", current_version).delete_all
  end
end
