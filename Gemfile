source 'https://rubygems.org'

ruby '2.0.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Sunspot to implement Solr based search
# gem 'sunspot_rails'
# gem 'kaminari'
# gem 'sunspot_with_kaminari'
# gem 'sunspot_solr'

#PG full text search
gem 'pg_search'
gem 'progress_bar'

# To See which action is causing memory leak
gem "oink"

# Haml replaces erb
gem 'haml'
# Bootstrap and sass for page layouts
gem 'bootstrap-sass', '~> 3.4.1'
# Use Simpleform to create forms with complete html input
gem 'simple_form'
# Use Devise for user authentication system
gem 'devise'
# Paginate will add pages for index; bootstrap compatible
gem 'will_paginate'
gem 'bootstrap-will_paginate'
# Paginate alphabetically (for CC's index)
gem 'alphabetical_paginate'

# Replaces webrick
gem 'puma'
# Replace puma
# gem "passenger"
gem 'unicorn'
gem 'unicorn-worker-killer'

# Use postgresql as the production database for Heroku and in developement as well
gem 'pg'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console

  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Use mailcatcher to test sending verification emails
  gem 'mailcatcher'
end

group :test do
  # Use minitest-reporters to add color to the console for tests
  gem 'minitest-reporters'

  # Use mini_backtrace to hide backtrace going through gems
  gem 'mini_backtrace'
end

group :production do
  # Use postgresql as the production database for Heroku


  # Needed for heroku
  gem 'rails_12factor'

  # For Heroku addon new-relic to keep the dyno alive
  # gem 'newrelic_rpm'
end
