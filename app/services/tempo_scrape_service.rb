require 'watir'

class TempoScrapeService
    attr_reader :browser, :user_id

    def initialize
        @browser = Watir::Browser.new :chrome, headless: true
        @user_id = User.find_by(email: 'kortirso@gmail.com').id
    end

    def perform(filename)
        decks_file = File.read("#{Rails.root}/db/scrapes/#{filename}")
        JSON.parse(decks_file).each { |deck| create_deck(deck) }
    end

    private

    def create_deck(deck, price = 0)
        browser.goto(deck['url'])

        Watir::Wait.until { browser.div(class: 'db-deck-cards').exists? }

        deck = Deck.create name: deck['name'], name_en: deck['name'], playerClass: deck['player_class'], formats: deck['formats'], link: deck['url'], user_id: user_id, player_id: Player.find_by(name_en: deck['player_class']).id, power: deck['power'], author: deck['author'], reno_type: deck['reno']

        browser.elements(class: 'db-deck-card').each do |elem|
            card_name = elem.div(class: 'db-deck-card-name').text
            card = Card.find_by(name_en: card_name)
            amount = elem.div(class: 'db-deck-card-qty').present? ? elem.div(class: 'db-deck-card-qty').text : 1
            deck.positions.create(amount: amount, card_id: card.id)
            price += DustPrice.calc(card.rarity, amount.to_i)
        end
        deck.update(price: price)

        puts "Deck #{deck['name']} is loaded"
        sleep(1)
    end
end