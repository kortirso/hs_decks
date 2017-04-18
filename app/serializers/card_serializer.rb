class CardSerializer < ActiveModel::Serializer
    attributes :id, :cardId, :type, :rarity, :formats, :hall_of_fame, :attack, :health, :mechanics, :name, :player_class, :collection, :multi_class, :race

    def name
        object.name_ru
    end

    def player_class
        object.player.name_ru
    end

    def collection
        object.collection.name_ru
    end

    def multi_class
        object.multi_class_id.nil? ? nil : object.multi_class.name_ru
    end

    def race
        object.race_id.nil? ? nil : object.race.name_ru
    end
end
