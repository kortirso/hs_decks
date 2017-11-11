module SubscribeController
    extend ActiveSupport::Concern

    def subscribe
        current_user.subscribe_for_news
    end

    def unsubscribe
        current_user.unsubscribe_from_news
    end
end
