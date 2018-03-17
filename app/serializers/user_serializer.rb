class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :role, :get_news
end
