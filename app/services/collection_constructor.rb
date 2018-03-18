# Collection build service
class CollectionConstructor
  attr_reader :cards_params, :user, :old_params

  def initialize(params)
    @cards_params = init_params(params[:cards].to_h)
    @user = params[:user]
    @old_params = user.positions.collect_ids_as_hash
  end

  def build_collection
    update_collection
    adding_to_collection
  end

  private def init_params(params)
    params.map { |key, value| params[key] = value.to_i }
    params
  end

  private def update_collection
    positions = user.positions
    old_params.each do |key, value|
      next unless cards_params.keys.include?(key)
      new_amount = cards_params[key]
      if new_amount.zero?
        positions.find_by(card_id: key.to_i).destroy
      elsif value != new_amount
        positions.find_by(card_id: key.to_i).update(amount: new_amount)
      end
    end
  end

  private def adding_to_collection
    pos = []
    t = Time.current
    cards_params.each { |key, value| pos.push "(#{key}, '#{user.id}', 'User', '#{value}', '#{t}', '#{t}')" if !old_params.keys.include?(key) && value != 0 }
    Position.connection.execute "INSERT INTO positions (card_id, positionable_id, positionable_type, amount, created_at, updated_at) VALUES #{pos.join(', ')}" unless pos.size.zero?
  end
end
