class NewsSerializer < ActiveModel::Serializer
    attributes :id, :url_label, :label, :caption, :image, :link
end
