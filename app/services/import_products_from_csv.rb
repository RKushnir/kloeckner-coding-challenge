require "csv"

class ImportProductsFromCsv
  def call(csv_file)
    CSV.foreach(csv_file, col_sep: "|", headers: true, skip_blanks: true) do |row|
      product = Product.find_or_initialize_by(part_number: row["PART_NUMBER"])
      product.update!(
        branch_code:          row["BRANCH_ID"],
        part_price_usd_cents: parse_price(row["PART_PRICE"]),
        short_description:    row["SHORT_DESC"]
      )
    end
  end

  def parse_price(value)
    (Float(value) * 100).to_i
  end
end
