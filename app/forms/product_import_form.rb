require "csv"

class ProductImportForm
  include ActiveModel::Model

  attr_accessor :csv_file, :delete_obsolete_products

  def initialize
    self.delete_obsolete_products = false
  end

  def validate(params)
    self.csv_file = params[:csv_file]
    self.delete_obsolete_products = params[:delete_obsolete_products] == "1"

    if csv_file.blank?
      errors.add :base, I18n.t("product_import_form.file_blank")
      return
    end

    CSV.foreach(csv_file, col_sep: "|", headers: true, skip_blanks: true).with_index(2) do |row, line_number|
      validate_single_csv_row(row, line_number)
    end

    errors.empty?
  end

  private

  def validate_single_csv_row(csv_row, line_number)
    if csv_row["PART_NUMBER"].blank?
      add_csv_row_error_message I18n.t("product_import_form.part_number_blank"), line_number
    end

    if csv_row["BRANCH_ID"].blank?
      add_csv_row_error_message I18n.t("product_import_form.branch_id_blank"), line_number
    end

    if csv_row["PART_PRICE"].blank?
      add_csv_row_error_message I18n.t("product_import_form.part_price_blank"), line_number
    else
      unless valid_number?(csv_row["PART_PRICE"])
        add_csv_row_error_message I18n.t("product_import_form.part_price_not_a_number"), line_number
      end
    end
  end

  def valid_number?(value)
    Float(value)
    true
  rescue ArgumentError
    false
  end

  def add_csv_row_error_message(error_message, line_number)
    errors.add :base, I18n.t("product_import_form.csv_error_prefix", line_number: line_number) + error_message
  end
end
