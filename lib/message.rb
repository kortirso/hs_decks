require 'net/http'

class Message
    def initialize
        @uri = URI('https://omgvamp-hearthstone-v1.p.mashape.com/cards?collectible=1')
    end

    def get_request
        @req = Net::HTTP::Get.new(@uri)
        @req['X-Mashape-Key'] = ENV['HS_API_KEY']
        res = Net::HTTP.start(@uri.hostname, @uri.port, use_ssl: true) { |http| http.request(@req) }
        result = JSON.parse(res.body)
    end
end