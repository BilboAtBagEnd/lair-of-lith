source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# Use devise for authentication
gem 'devise'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Decode HTML entities when received on the wire
gem 'htmlentities'

# Friendly slugs
gem 'friendly_id', github: 'FriendlyId/friendly_id', branch: 'master'

# Sanitize all HTML input/output.
gem 'sanitize'

# BB Code for comments and descriptions
gem 'rbbcode', github: 'jarrett/rbbcode', branch: 'master'

# Sitemaps
gem 'sitemap_generator'

# Pagination 
gem 'kaminari'

# Tagging
gem 'acts-as-taggable-on'

# Exception notification
gem 'exception_notification'

# Google analytics server-side events
gem 'gabba'

# Searching 
#gem 'thinking-sphinx'

# Testing 
group :development, :test do 
  gem 'byebug'
  gem 'rspec-rails'
end
group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'roo' # Spreadsheets
end
group :test do 
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'email_spec'
  gem 'poltergeist'
end
group :production do
  gem 'rails_12factor'
end

ruby "2.1.2"
