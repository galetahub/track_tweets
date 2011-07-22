require 'active_support'
require 'mongo_mapper'
require 'logger'
require 'yaml'
require 'multi_json'
require 'json'

module TrackTweets
  autoload :API, 'track_tweets/api'
  autoload :Checker, 'track_tweets/checker'
  autoload :Utils, 'track_tweets/utils'
  
  module Models
    autoload :Base, 'track_tweets/models/base'
    autoload :Group, 'track_tweets/models/group'
    autoload :TrackItem, 'track_tweets/models/track_item'
    autoload :TrackItemStat, 'track_tweets/models/track_item_stat'
    autoload :Tweet, 'track_tweets/models/tweet'
    autoload :JobBase, 'track_tweets/models/job_base'
    autoload :TrackJob, 'track_tweets/models/track_job'
    autoload :StatJob, 'track_tweets/models/stat_job'
  end
  
  ACTIVE = 1
  STOPPED = 2
  BANNED = 3
  
  #
  # TrackTweets.logger.info 'Demo convert'
  #
  def self.logger
    @logger ||= create_logger(ENV['RACK_ENV'])
  end
  
  def self.logger_mongodb
    @logger_mongodb ||= create_logger('mongodb')
  end
  
  def self.initialize!
    config_file = File.expand_path('../../config/mongo.yml', __FILE__)
    
    if File.exists?(config_file)
      config = YAML.load( File.read(config_file) )
      ::MongoMapper.setup(config, ENV['RACK_ENV'], :logger => TrackTweets.logger_mongodb)
    end
    
    ::MultiJson.engine = :json_gem
    ActiveSupport::XmlMini.backend = 'Nokogiri'
  end
  
  protected
  
    def self.create_logger(filename)
      logfile = File.open(File.expand_path("../../log/#{filename}.log", __FILE__), 'a')
      logfile.sync = true
      Logger.new(logfile)
    end
end

require 'track_tweets/version'
