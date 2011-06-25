module TrackTweets
  module Models
    class TrackItemStat
      include Base
      
      # Columns
      key :tweets_count, Integer
      key :users_count, Integer
      key :retweets_count, Integer
      key :processed_jobs_count, Integer
      key :track_item_id, Integer
      timestamps!
      
      # Validations
      validates_presence_of :tweets_count, :track_item_id
      
      belongs_to :track_item
      
      attr_accessible :tweets_count, :users_count, :retweets_count, :processed_jobs_count
    end
  end
end
