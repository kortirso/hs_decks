require 'open-uri'
require 'nokogiri'

module Hearthpwn
  # load collection from Hearthpwn
  class CollectionLoadingService
    def self.call(args)
      uri = "http://www.hearthpwn.com/members/#{args[:username]}/collection"
      begin
        Nokogiri::HTML(open(uri))
      rescue OpenURI::HTTPError
        return nil
      end
    end
  end
end
