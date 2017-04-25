module Hearthpwn
    class CollectionConstructorService
        def self.call(args, pos = [], t = Time.current)
            args[:user].positions.destroy_all
            args[:cards].each do |key, value|
                card = Card.return_by_name(key)
                pos.push "(#{card.id}, '#{args[:user].id}', 'User', '#{value}', '#{t}', '#{t}')" if card.present?
            end
            Position.connection.execute "INSERT INTO positions (card_id, positionable_id, positionable_type, amount, created_at, updated_at) VALUES #{pos.join(", ")}" if pos.size > 0
        end
    end
end