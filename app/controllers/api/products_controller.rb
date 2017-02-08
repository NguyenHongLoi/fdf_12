class Api::ProductsController < ApplicationController

  def index
    start = params[:offset]
    max_products = Product.all.size
    @products = Product.all.limit(Settings.limit_products_json).offset(start)
    next_number = start.to_i + Settings.limit_products_json
    if next_number < max_products
      render json: {
        products: @products.as_json(only: [:id, :name,
          :description, :price, :image]),
        next_products: +(next_number).to_s,
        product_end: Settings.product_end_true_json
      }
    else
      render json: {
        products: @products.as_json(only: [:id, :name,
          :description, :price, :image]),
        product_end: Settings.product_end_false_json
      }
    end
  end
end