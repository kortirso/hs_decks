class CardsStylesCompilerService
    def self.call
        open("#{Rails.root}/app/assets/stylesheets/short_cards.scss", 'w') do |f|
            f.puts '.costs .card .image, .check .card .image, #cards_list .card .image, #exchanges .card .image, #lines .card .image {'
            Card.all.order(cardId: :asc).each { |card| f.puts "&.card_#{card.cardId}{background-image: image-url('short_cards/#{card.cardId}_short.jpg')}" }
            f.puts '}'
        end
    end
end