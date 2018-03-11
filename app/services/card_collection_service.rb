require 'net/http'

class CardCollectionService
  attr_reader :uri

  def initialize(locale = 'en')
    @uri = URI("https://omgvamp-hearthstone-v1.p.mashape.com/cards?collectible=1&locale=#{full_locale(locale)}")
  end

  def get_cards
    req = Net::HTTP::Get.new(uri)
    req['X-Mashape-Key'] = ENV['HS_API_KEY']
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    result = JSON.parse(res.body)
  end

  private def full_locale(locale)
    case locale
      when 'en' then 'enUS'
      when 'ru' then 'ruRU'
    end
  end
end