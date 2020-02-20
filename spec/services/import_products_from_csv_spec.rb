require "rails_helper"

RSpec.describe ImportProductsFromCsv, type: :service do
  subject(:service) { described_class.new }

  def run_import
    File.open("spec/fixtures/basic_products.csv") do |csv_file|
      service.call(csv_file)
    end
  end

  it "creates products corresponding to the rows in the given CSV file" do
    run_import

    expect(Product.all).to include(
      an_object_having_attributes(
        part_number: "0121F00548",
        branch_code: "TUC",
        part_price_usd_cents: 314,
        short_description: "GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56",
      ),
      an_object_having_attributes(
        part_number: "0121G00047P",
        branch_code: "TUC",
        part_price_usd_cents: 4250,
        short_description: "GALV x FAB x .026 x 29.88 x 17.56",
      ),
    )
  end

  it "deletes products that haven't been updated in the current run" do
    Product.create!(part_number: "Obsolete", branch_code: "TUC", part_price_usd_cents: 1)
    Product.create!(part_number: "0121F00548", branch_code: "OLD", part_price_usd_cents: 2)

    run_import

    expect(Product.all).to include(
      an_object_having_attributes(
        part_number: "0121F00548",
        branch_code: "TUC",
        part_price_usd_cents: 314,
        short_description: "GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56",
      ),
    )

    expect(Product.all).not_to include(
      an_object_having_attributes(
        part_number: "Obsolete",
      ),
    )
  end
end
