require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module HsDecks
    class Application < Rails::Application
        I18n.available_locales = [:en, :ru]
        config.i18n.default_locale = :en
        config.active_record.schema_format = :ruby
        config.generators do |g|
            g.test_framework :rspec, fixtures: true, views: false, view_specs: false, helper_specs: false,
                routing_specs: false, controller_specs: true, request_specs: false
            g.fixture_replacement :factory_girl, dir: 'spec/factories'
        end
        config.active_record.raise_in_transactional_callbacks = true
    end
end
