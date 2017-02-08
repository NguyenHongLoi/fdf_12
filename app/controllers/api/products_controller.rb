class Api::ProductsController < ApplicationController

  def index
    start_offset = params[:offset]
    max_products = Product.all.size
    products = Product.all.limit(Settings.limit_products_json).offset start_offset
    next_number = start_offset.to_i + Settings.limit_products_json
    if next_number < max_products
      render json: {
        products: products.as_json(only: [:id, :name,
          :description, :price, :image, :shop_id, :category_id]),
        next_products: Settings.next_products_json + next_number.to_s,
        product_end: Settings.product_end_false_json,
      }
    else
      render json: {
        products: products.as_json(only: [:id, :name,
          :description, :price, :image]),
        product_end: Settings.product_end_true_json,
        product_end_reason: Settings.product_end_reason_json
      }
    end
  end
end
