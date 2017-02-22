class DomainSerializer < ActiveModel::Serializer
  attributes :id, :name, :owner, :status
end
