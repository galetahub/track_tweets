# Configure Rack Envinronment
ENV['RACK_ENV'] = "test"

require File.expand_path('../../config/environment',  __FILE__)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you don't want RSpec's should and should_not
  # methods or matchers
  require 'rspec/expectations'
  config.include RSpec::Matchers
  
  require 'rack/test'
  config.include Rack::Test::Methods

  # == Mock Framework
  config.mock_with :rspec
  
  require 'database_cleaner'
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  config.after(:all) do
    DatabaseCleaner.clean
  end
end
