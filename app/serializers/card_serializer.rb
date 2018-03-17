class CardSerializer < ActiveModel::Serializer
  attributes :id, :cardId, :type, :rarity, :formats, :hall_of_fame, :attack, :health, :mechanics, :name, :player_class, :collection, :multi_class, :race

  def name
    object.locale_name('ru')
  end

  def player_class
    object.player.locale_name('ru')
  end

  def collection
    object.collection.locale_name('ru')
  end

  def multi_class
    object.multi_class_id.nil? ? nil : object.multi_class.locale_name('ru')
  end

  def race
    object.race_id.nil? ? nil : object.race.locale_name('ru')
  end
end
