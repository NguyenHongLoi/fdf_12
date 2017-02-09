class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :image, :shop_id, :category_id,
    :status, :start_hour, :end_hour
  belongs_to :shop
end
