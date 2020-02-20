class ProductsController < ApplicationController
  def index
    products = Product.all
    render :index, locals: { products: products }
  end
end
