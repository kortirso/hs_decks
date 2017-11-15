class DeckSerializer < ActiveModel::Serializer
    attributes :id, :name, :price, :power, :player_name, :slug, :formats

    def player_name
        object.player.name_en
    end

    def style_name
        object.style.try(:name_en)
    end

    def expert
        object.user.username
    end

    def mana_curve
        object.positions.amount_by_mana
    end

    class WithCards < self
        attributes :caption
        has_many :positions
    end
end
