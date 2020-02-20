require "rails_helper"

RSpec.describe ImportProductsFromCsv, type: :service do
  subject(:service) { described_class.new }

  it "creates products corresponding to the rows in the given CSV file" do
    File.open("spec/fixtures/basic_products.csv") do |csv_file|
      service.call(csv_file)

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
  end
end
