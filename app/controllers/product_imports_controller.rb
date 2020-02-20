class ProductImportsController < ApplicationController
  def new
    form = ProductImportForm.new
    render :new, locals: { form: form }
  end

  def create
    form = ProductImportForm.new

    if form.validate(params.require(:product_import))
      ImportProductsFromCsv.new.call(form.csv_file)

      flash[:notice] = t("product_imports.create.success")
      redirect_to products_path
    else
      flash.now[:alert] = t("product_imports.create.failure")
      render :new, locals: { form: form }
    end
  end
end
