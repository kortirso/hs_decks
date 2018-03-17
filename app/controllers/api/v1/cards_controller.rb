module Api
  module V1
    class CardsController < Api::V1::BaseController
      resource_description do
        short 'Card information resources'
        formats ['json']
      end

      api :GET, '/v1/cards.json', 'Returns cards information'
      def index
        render json: ActiveModel::Serializer::CollectionSerializer.new(Card.order(id: :desc).includes(:player, :collection, :multi_class, :race), each_serializer: CardSerializer)
      end
    end
  end
end
