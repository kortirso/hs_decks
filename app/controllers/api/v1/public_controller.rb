module Api
  module V1
    class PublicController < Api::V1::BaseController
      resource_description do
        short 'Public information resources'
        formats ['json']
      end

      api :GET, '/v1/public/all.json', 'Returns all public information'
      def all
        data = {
          news: ActiveModel::Serializer::CollectionSerializer.new(News.order(id: :desc), each_serializer: NewsSerializer),
          decks: ActiveModel::Serializer::CollectionSerializer.new(Deck.all.includes(:player, :style, :user, :positions), each_serializer: DeckSerializer),
          about: ActiveModel::Serializer::CollectionSerializer.new(About.order(id: :desc).includes(:fixes), each_serializer: AboutSerializer),
          version: About.last.version
        }
        render json: data
      end

      api :POST, '/v1/public/all_post.json', 'Returns all public information'
      def all_post
        data = {
          news: ActiveModel::Serializer::CollectionSerializer.new(News.order(id: :desc), each_serializer: NewsSerializer),
          decks: ActiveModel::Serializer::CollectionSerializer.new(Deck.all.includes(:player, :style, :user, :positions), each_serializer: DeckSerializer),
          about: ActiveModel::Serializer::CollectionSerializer.new(About.order(id: :desc).includes(:fixes), each_serializer: AboutSerializer),
          version: About.last.version
        }
        render json: data, status: 200
      end
    end
  end
end
