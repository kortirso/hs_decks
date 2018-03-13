source 'https://rubygems.org'

ruby '2.3.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.1.4'
gem 'therubyracer', platforms: :ruby

# Use postgresql as the database for Active Record
gem 'pg', '0.21'

# Use Puma as the app server
gem 'puma', '3.10.0'

# Add Webpack
gem 'foreman'
gem 'webpacker', '~> 3.3.0'
gem 'webpacker-react', '~> 0.3.2'

# Store secrets
gem 'figaro'

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

# Admin panel
gem 'rails_admin', '1.3.0'

# Scrape hearthpwn data
gem 'nokogiri'

# Background-jobs
gem 'redis', '~> 3.0'
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

# Mailer
gem 'premailer-rails'

# Scraping decks
gem 'watir', '6.10.0'
gem 'webdrivers', '~> 3.0'

group :development, :test do
  gem 'database_cleaner'
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
  gem 'simplecov', require: false
end
