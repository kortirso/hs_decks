class Api::V1::PublicController < Api::V1::BaseController
    resource_description do
        short 'Public information resources'
        formats ['json']
    end

    api :GET, '/v1/public/all.json', 'Returns all public information'
    def all
        info = {
            news: ActiveModel::Serializer::CollectionSerializer.new(News.order(id: :desc), each_serializer: NewsSerializer),
            decks: ActiveModel::Serializer::CollectionSerializer.new(Deck.all, each_serializer: DeckSerializer),
            version: '0.4.1'
        }
        render json: info
    end
end