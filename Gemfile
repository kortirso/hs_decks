source 'https://rubygems.org'

ruby '2.4.2'

git_source(:github) do |repo_name|
    repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
    "https://github.com/#{repo_name}.git"
end

gem 'jquery-rails'
gem 'rails', '5.1.4'
gem 'therubyracer', platforms: :ruby

# Use postgresql as the database for Active Record
gem 'pg', '0.21'

# Use Puma as the app server
gem 'puma', '3.10.0'

# Use SCSS for stylesheets
gem 'sass-rails', '5.0.6'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '3.2.0'

# Add Webpack
gem 'foreman'
gem 'webpacker', '3.0.2'
gem 'webpacker-react', '~> 0.3.2'

gem 'redis', '~> 3.0'

# Store secrets
gem 'figaro'

# Foundation for frontend
gem 'foundation-rails', '6.4.1.2'

# Auto-prefixing CSS for cross-browser compat.
gem 'autoprefixer-rails', '6.7.6'

# Use Slim as the templating engine. Better than ERB
gem 'slim'

# Authentication
gem 'devise', github: 'plataformatec/devise'

# Simple Forms
gem 'simple_form'

# I18n
gem 'route_translator'

# Fast batch record creation (used by migration tasks)
gem 'activerecord-import'

#gem 'remotipart', github: 'mshibuya/remotipart'
#gem 'whenever'
#gem 'jquery-ui-rails'
#gem 'rails4-autocomplete'

# Admin panel
gem 'rails_admin', '1.2.0'

# Scrape hearthpwn data
gem 'nokogiri'

# Background-jobs
gem 'redis-namespace'
gem 'sidekiq', '5.0.5'

# Text editor
gem 'trix'

# Model Serializers
gem 'active_model_serializers', '~> 0.10.0'
gem 'oj'
gem 'oj_mimic_json'

# API description
gem 'apipie-rails'

# Friendly names
gem 'babosa'
gem 'friendly_id', '~> 5.1.0'

# Code analyzation
gem 'rubocop', '~> 0.49.1', require: false

group :development, :test do
    gem 'factory_bot_rails'
    gem 'rails-controller-testing'
    gem 'rspec-rails'
end

group :development do
    gem 'capistrano', require: false
    gem 'capistrano-bundler', require: false
    gem 'capistrano-rails', require: false
    gem 'capistrano-rvm', require: false
    gem 'capistrano-sidekiq', require: false
    gem 'listen', '~> 3.0.5'
    gem 'spring'
    gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
    gem 'json_spec'
    gem 'shoulda-matchers'
end
