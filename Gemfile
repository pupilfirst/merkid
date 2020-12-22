source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 5.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Customizable, no-DSL admin interface.
gem 'administrate', '~> 0.14.0'
gem 'administrate-field-active_storage', '~> 0.3.6'
gem 'administrate_exportable', github: 'SourceLabsLLC/administrate_exportable'

# rubyzip is a Ruby module for reading and writing zip files.
gem 'rubyzip', '~> 2.3'

# Rack Middleware for handling CORS, required to serve static assets such as fonts
gem 'rack-cors', '~> 1.1', require: 'rack/cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development do
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano-rbenv'
  gem 'capistrano3-puma'
  gem 'capistrano-sidekiq', '~> 2.0.0.beta5'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# APPLICATION SPECIFIC SETUP
gem "letter_opener", :group => :development
gem "sidekiq"
gem 'font-awesome-sass'
gem 'postmark-rails'
gem "sentry-raven", '~>3.1.1'
# Manage email css
gem 'roadie-rails', '~> 2.2'
# github api
gem "octokit", "~> 4.0"
# skylight
gem "skylight", "~> 4.2.3"

group :production do
  gem 'aws-sdk-s3', '~> 1.35 ', require: false
end

gem 'kaminari'

group :development do
  gem 'faker'
end
