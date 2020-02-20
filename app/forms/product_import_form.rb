class ProductImportForm
  include ActiveModel::Model

  attr_accessor :csv_file

  def validate(params)
    self.csv_file = params[:csv_file]
    true
  end
end
