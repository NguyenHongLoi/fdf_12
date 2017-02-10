class UserSerializer < ActiveModel::Serializer
  attributes :authentication_token, :id, :name, :email, :avatar, :chatwork_id
end
