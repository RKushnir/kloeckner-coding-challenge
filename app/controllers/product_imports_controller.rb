class ProductImportsController < ApplicationController
  def new
    form = ProductImportForm.new
    render :new, locals: { form: form }
  end

  def create
    form = ProductImportForm.new

    if form.validate(params.require(:product_import))
      begin
        ImportProductsFromCsv.new.call(form.csv_file)

        flash[:notice] = t("product_imports.create.success")
        redirect_to products_path
      rescue ImportProductsFromCsv::ImportAlreadyInProgress
        respond_with_error t("product_imports.create.already_in_progress"), form
      end
    else
      respond_with_error t("product_imports.create.failure"), form
    end
  end

  private

  def respond_with_error(error_message, form)
    flash.now[:alert] = error_message
    render :new, locals: { form: form }
  end
end
