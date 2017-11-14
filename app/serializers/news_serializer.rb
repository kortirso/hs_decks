class NewsSerializer < ActiveModel::Serializer
    attributes :id, :label, :caption, :link, :date

    def date
        object.created_at.strftime('%Y.%m.%d')
    end
end
