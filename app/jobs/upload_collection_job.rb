# Job for uploading collection from HearthPWN
class UploadCollectionJob < ApplicationJob
    queue_as :default

    def perform(args)
        cards = Hearthpwn::CollectionParserService.call(username: args[:username])
        if cards.empty?
            result = 'Такого пользователя не существует или коллекция не доступна'
        else
            Hearthpwn::CollectionConstructorService.call(user: args[:user], cards: cards)
            result = 'Коллекция карт успешно загружена'
        end
        UserMailer.upload_collection_email(message: result, user: args[:user], username: args[:username]).deliver
    end
end
