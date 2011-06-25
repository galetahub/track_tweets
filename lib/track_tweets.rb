require 'active_support'
require 'mongo_mapper'
require 'logger'
require 'yaml'

module TrackTweets
  autoload :API, 'track_tweets/api'
  
  module Models
    autoload :Group, 'track_tweets/models/group'
  end
  
  #
  # TrackTweets.logger.info 'Demo convert'
  #
  def self.logger
    @logger ||= begin
      logfile = File.open(File.expand_path('../../log/application.log', __FILE__), 'w')
      logfile.sync = true
      Logger.new(logfile)
    end
    
    @logger
  end
  
  def self.initialize!
    config_file = File.expand_path('../../config/mongo.yml', __FILE__)
    
    if File.exists?(config_file)
      config = YAML.load( File.read(config_file) )
      ::MongoMapper.setup(config, ENV['RACK_ENV'], :logger => TrackTweets.logger)
    end
  end
end
