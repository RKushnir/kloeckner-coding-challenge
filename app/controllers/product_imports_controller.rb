class ProductImportsController < ApplicationController
  def new
    @product_import_form = ProductImportForm.new
  end

  def create
    @product_import_form = ProductImportForm.new

    if @product_import_form.validate(params.require(:product_import))
      ImportProductsFromCsv.new.call(@product_import_form.csv_file)

      flash[:notice] = t("product_imports.create.success")
      redirect_to root_path
    else
      flash.now[:alert] = t("product_imports.create.failure")
      render :new
    end
  end
end
