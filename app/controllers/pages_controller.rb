class PagesController < ApplicationController
  include SubscribeController
  skip_before_action :check_access, only: %i[index decks about]

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: {
          standard_decks: ActiveModel::Serializer::CollectionSerializer.new(Deck.of_format('standard').includes(:player).order(power: :desc).limit(6), each_serializer: DeckSerializer),
          wild_decks: ActiveModel::Serializer::CollectionSerializer.new(Deck.of_format('wild').includes(:player).order(power: :desc).limit(6), each_serializer: DeckSerializer),
          news: ActiveModel::Serializer::CollectionSerializer.new(News.order(id: :desc).limit(4), each_serializer: NewsSerializer)
        }
      end
    end
  end

  def decks
    respond_to do |format|
      format.html
      format.json do
        render json: {
          standard_decks: ActiveModel::Serializer::CollectionSerializer.new(Deck.of_format('standard').includes(:player).order(power: :desc), each_serializer: DeckSerializer),
          wild_decks: ActiveModel::Serializer::CollectionSerializer.new(Deck.of_format('wild').includes(:player).order(power: :desc), each_serializer: DeckSerializer)
        }
      end
    end
  end

  def about; end

  def collection
    @cards = Card.includes(:collection).collectible
    @packs = current_user.positions.collect_ids
  end

  def unusable
    @unusable_cards = current_user.unusable_cards
  end

  def personal
    @user = current_user
  end

  private def filter_params
    params.permit(:playerClass, :power, :formats, :style)
  end
end
