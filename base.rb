rvmrc = <<-RVMRC
rvm_gemset_create_on_use_flag=1
rvm gemset use #{app_name}
RVMRC

create_file ".rvmrc", rvmrc

gem "devise", "~> 1.1"
gem "high_voltage", "~> 0.9"
gem "paperclip", "~> 2.3"

gem "shoulda", "~> 2.11", :group => :test
gem "factory_girl_rails", "~> 1.0.0", :group => :test

generators = <<-GENERATORS

    config.generators do |g|
      g.test_framework :testunit, :fixture => true, :views => false
      g.integration_tool :testunit, :fixture => true, :views => true
    end
GENERATORS

application generators

get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js",  "public/javascripts/jquery.js"
get "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.1/jquery-ui.min.js", "public/javascripts/jquery-ui.js"
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"

gsub_file 'config/application.rb', 'config.action_view.javascript_expansions[:defaults] = %w()', 'config.action_view.javascript_expansions[:defaults] = %w(jquery.js jquery-ui.js rails.js)'

create_file "log/.gitkeep"
create_file "tmp/.gitkeep"
create_file "app/views/pages/.gitkeep"

git :init
git :add => "."