class AboutSerializer < ActiveModel::Serializer
    attributes :id, :version, :label_en, :label_ru
    has_many :fixes
end
