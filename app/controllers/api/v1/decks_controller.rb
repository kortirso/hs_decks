module Api
    module V1
        class DecksController < Api::V1::BaseController
            before_action :find_deck, only: :show

            resource_description do
                short 'Decks information resources'
                formats ['json']
            end

            api :GET, '/v1/decks.json', 'Returns the information about all expert decks'
            def index
                data = {
                    decks: ActiveModel::Serializer::CollectionSerializer.new(Deck.all.includes(:player, :style, :user, :positions), each_serializer: DeckSerializer)
                }
                render json: data
            end

            api :GET, '/v1/decks/:id.json', 'Returns the information about speсific deck'
            error code: 400, desc: 'Game showing error'
            example "error: 'Game does not exist'"
            def show
                data = {
                    deck: DeckSerializer::WithCards.new(@deck)
                }
                render json: data
            end

            private

            def find_deck
                @deck = Deck.find_by(id: params[:id])
                render json: { error: 'Game does not exist' } if @deck.nil?
            end
        end
    end
end
