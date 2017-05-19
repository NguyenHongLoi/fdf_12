class V1::ProductsController < V1::BaseController
  def index
    products = []
    if params[:category_id].present?
      Product.includes(:shop).find_each do |t|
        if t.category_id.to_s == params[:category_id] &&
          t.product_domains.api_find_product_domains(params[:domain_id])
            products << t
        end
      end
    elsif params[:shop_id].present?
      Product.includes(:shop).find_each do |t|
        if t.shop_id.to_s == params[:shop_id] &&
          t.product_domains.api_find_product_domains(params[:domain_id])
            products << t
        end
      end
    else
      Product.includes(:shop).find_each do |t|
        if t.product_domains.api_find_product_domains(params[:domain_id])
          products << t
        end
      end
    end
    if products.present?
      result = ActiveModel::Serializer::CollectionSerializer.new(products,
        each_serializer: ProductSerializer)
      response_success t("api.success"), result
    else
      response_not_found t "api.error_products_not_found"
    end
  end
end
