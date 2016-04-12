source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# Use postgres as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'dotenv-rails', '>= 2.0.1'

gem 'activeadmin', '1.0.0.pre2'
gem 'devise'

# Amazon product API wrapper
gem 'vacuum'
gem 'sidekiq'

# AWS SDK for mailers etc
gem 'aws-sdk-rails'

# sinatra to support sidekiq web ui
gem 'sinatra', require: nil

# Pretty icon fonts
gem 'font-awesome-rails'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use state machine to track a Reservation's state
# https://github.com/state-machines/state_machines-activerecord
gem 'state_machines-activerecord'

# Use Bootstrap as the application's front-end framework
gem 'bootstrap-sass', '~> 3.3.6'
# Use Slim template
gem 'slim-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # [SJP] Run RSpec for tests
  gem 'rspec-rails'
  gem 'capybara'
end

group :test do
  # Use factory girl for mocking out models
  # https://github.com/thoughtbot/factory_girl_rails
  gem 'factory_girl_rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

