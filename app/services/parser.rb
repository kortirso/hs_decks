require 'open-uri'
require 'nokogiri'

module Parser
    class CollectionParser
        attr_reader :uri
        attr_accessor :list

        def initialize(username)
            @uri = "http://www.hearthpwn.com/members/#{username}/collection"
            @list = {}
        end

        def parsing
            begin
                doc = Nokogiri::HTML(open(uri))
            rescue OpenURI::HTTPError
                return nil
            end
            doc.css('.owns-card').each do |card|
                if list[card['data-card-name']].nil?
                    list[card['data-card-name']] = card.at_css('.inline-card-count')['data-card-count'].to_i
                else
                    list[card['data-card-name']] += card.at_css('.inline-card-count')['data-card-count'].to_i
                end
            end
            list
        end
    end
end