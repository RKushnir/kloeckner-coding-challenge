require "rails_helper"

RSpec.describe "Product import", type: :feature do
  scenario "creating products via CSV file upload" do
    visit "/product_import/new"
    attach_file "CSV File", "spec/fixtures/basic_products.csv"
    click_button "Import"

    # within("tr", text: "0121F00548") do
    #   expect(page).to have_text("TUC")
    #   expect(page).to have_text("3.14")
    #   expect(page).to have_text("GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56")
    # end
  end
end
