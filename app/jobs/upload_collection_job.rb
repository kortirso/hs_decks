class UploadCollectionJob < ApplicationJob
    queue_as :default

    def perform(user, username)
        list = Parser::CollectionParser.new(username).parsing
        if list.nil?
            result = 'Такого пользователя не существует'
        else
            user.positions.destroy_all
            positions, t = [], Time.current
            list.each { |key, value| positions.push "(#{Card.return_by_name(key).id}, '#{user.id}', 'User', '#{value}', '#{t}', '#{t}')" }
            Position.connection.execute "INSERT INTO positions (card_id, positionable_id, positionable_type, amount, created_at, updated_at) VALUES #{positions.join(", ")}" if positions.size > 0
            result = 'Коллекция карт успешно загружена'
        end
        UserMailer.upload_collection(result, user, username).deliver
    end
end
