class UsersChannel < ApplicationCable::Channel  
    def subscribed
        stream_from "user_#{params['user_id']}_channel"
    end
end