$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require File.expand_path('../boot', __FILE__)

ENV['RACK_ENV'] ||= 'development'
ENV['TMPDIR'] ||= File.expand_path('../../tmp', __FILE__)

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, ENV['RACK_ENV']) if defined?(Bundler)

if ENV['RACK_ENV'] == 'development'
  log = File.new( File.expand_path('../../log/development.log', __FILE__), "a")
  STDOUT.reopen(log)
  STDERR.reopen(log)
end

require "rack/contrib"
require "track_tweets"

# Initialize the track_tweets API
TrackTweets.initialize!
