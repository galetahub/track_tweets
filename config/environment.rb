$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require File.expand_path('../boot', __FILE__)

ENV['RACK_ENV'] ||= 'development'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, ENV['RACK_ENV'].to_sym) if defined?(Bundler)

require "track_tweets"

# Initialize the track_tweets API
TrackTweets.initialize!
