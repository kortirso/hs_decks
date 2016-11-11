class DeckSerializer < ActiveModel::Serializer
    attributes :id, :name, :price, :formats, :power, :player_name, :style_name

    def player_name
        object.player.name_en
    end

    def style_name
        object.style.try(:name_en)
    end
end
