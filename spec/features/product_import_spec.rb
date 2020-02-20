require "rails_helper"

RSpec.describe "Product import", type: :feature do
  def find_row(part_number)
    find("tr td:nth-child(2)", text: part_number).find(:xpath, "..")
  end

  scenario "creating products via CSV file upload" do
    visit "/product_import/new"
    attach_file "CSV File", "spec/fixtures/basic_products.csv"
    click_button "Import"
    expect(page).to have_content(".flash-notice", "Products were successfully imported")

    within(find_row("0121F00548")) do
      expect(page).to have_text("TUC")
      expect(page).to have_text("3.14")
      expect(page).to have_text("GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56")
    end
  end

  scenario "initiating an import while another import is already running" do
    import_service = instance_double(ImportProductsFromCsv)
    allow(ImportProductsFromCsv).to receive(:new).and_return(import_service)
    allow(import_service).to receive(:call).and_raise(ImportProductsFromCsv::ImportAlreadyInProgress)

    visit "/product_import/new"
    attach_file "CSV File", "spec/fixtures/basic_products.csv"
    click_button "Import"

    expect(page).to have_content(".flash-alert", "Another import process is already running")
  end
end
