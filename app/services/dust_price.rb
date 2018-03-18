# Returns dust price for cards
class DustPrice
  PRICE_FOR_FREE = 0
  PRICE_FOR_COMMON = 40
  PRICE_FOR_RARE = 100
  PRICE_FOR_EPIC = 400
  PRICE_FOR_LEGENDARY = 1600

  def self.calc(rarity, amount = 1)
    case rarity
      when 'Free' then PRICE_FOR_FREE
      when 'Common' then PRICE_FOR_COMMON * amount
      when 'Rare' then PRICE_FOR_RARE * amount
      when 'Epic' then PRICE_FOR_EPIC * amount
      when 'Legendary' then PRICE_FOR_LEGENDARY
    end
  end
end
