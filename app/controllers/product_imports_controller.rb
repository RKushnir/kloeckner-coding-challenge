class ProductImportsController < ApplicationController
  def new
    @product_import_form = ProductImportForm.new
  end

  def create
    @product_import_form = ProductImportForm.new
  end
end
