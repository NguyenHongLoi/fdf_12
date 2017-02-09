class ShopSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :status, :avatar, :averate_rating,
    :owner_id
end
