require 'sidekiq'
require 'sidekiq-status'

Sidekiq.configure_client do |config|
    config.client_middleware do |chain|
        chain.add Sidekiq::Status::ClientMiddleware
    end
    config.redis = { namespace: 'hs_decks', url: 'redis://127.0.0.1:6379/0' }
end

Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
        chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes
    end
    config.redis = { namespace: 'hs_decks', url: 'redis://127.0.0.1:6379/0' }
end