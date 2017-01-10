class HearthpwnCollectionConstructor
    attr_reader :user, :cards

    def initialize(params)
        @user = params[:user]
        @cards = params[:cards]
    end

    def execute
        user.positions.destroy_all
        pos, t = [], Time.current
        cards.each { |key, value| pos.push "(#{Card.return_by_name(key).id}, '#{user.id}', 'User', '#{value}', '#{t}', '#{t}')" }
        Position.connection.execute "INSERT INTO positions (card_id, positionable_id, positionable_type, amount, created_at, updated_at) VALUES #{pos.join(", ")}" if pos.size > 0
    end
end