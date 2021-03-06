class PositionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :card

  def card
    card = object.card
    {
      id: card.id,
      name: card.locale_name('en'),
      type: card.type,
      cost: card.cost,
      rarity: card.rarity,
      image: card.image_en
    }
  end
end
