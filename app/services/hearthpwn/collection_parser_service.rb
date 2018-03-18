require 'nokogiri'

module Hearthpwn
  # collection parser from Hearthpwn
  class CollectionParserService
    def self.call(args, cards = {})
      doc = Hearthpwn::CollectionLoadingService.call(username: args[:username])
      return {} if doc.nil?
      doc.css('.owns-card').each do |card|
        if cards[card['data-card-name']].nil?
          cards[card['data-card-name']] = card.at_css('.inline-card-count')['data-card-count'].to_i
        else
          cards[card['data-card-name']] += card.at_css('.inline-card-count')['data-card-count'].to_i
          cards[card['data-card-name']] = 2 if cards[card['data-card-name']] > 2
        end
      end
      cards
    end
  end
end
