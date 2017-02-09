class Api::V1::ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :image, :shop_id, :category_id
end
