class UploadCollectionJob < ApplicationJob
    queue_as :default

    def perform(user, username)
        cards = Parser::HearthpwnCollectionParser.new(username).parsing
        if cards.nil?
            result = 'Такого пользователя не существует'
        else
            HearthpwnCollectionConstructor.new({ user: user, cards: cards }).execute
            result = 'Коллекция карт успешно загружена'
        end
        UserMailer.upload_collection(result, user, username).deliver
    end
end
