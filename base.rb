rvmrc = <<-RVMRC
rvm use 1.9.2@#{app_name} --create
RVMRC

create_file ".rvmrc", rvmrc

gem "test-unit",          :group => :test
gem "shoulda",            :group => :test
gem "factory_girl_rails", :group => :test
gem "cucumber-rails",     :group => :test
gem "capybara",           :group => :test
gem "selenium-webdriver", :group => :test
gem "spork",              :group => :test
gem "launchy",            :group => :test
gem "mocha",              :group => :test
gem "simplecov",          :group => :test

generators = <<-GENERATORS

    config.generators do |g|
      g.stylesheets false
      g.test_framework :shoulda
      g.fallbacks[:shoulda] = :test_unit
      g.integration_tool :cucumber
      g.fixture_replacement :factory_girl
    end
GENERATORS

application generators

inside('public/javascripts') do
	FileUtils.rm_rf %w(controls.js dragdrop.js effects.js prototype.js rails.js)
end

get "http://code.jquery.com/jquery-latest.min.js",  "public/javascripts/jquery.js"
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"

gsub_file 'config/application.rb', 'config.action_view.javascript_expansions[:defaults] = %w()', 'config.action_view.javascript_expansions[:defaults] = %w(jquery.js jquery-ui.js rails.js)'

create_file "log/.gitkeep"
create_file "tmp/.gitkeep"

run "rm public/index.html"

generate 'cucumber:install', '--capybara', '--testunit', '--spork'

git :init
git :add => "."