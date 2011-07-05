module TrackTweets
  module Models
    class StatJob
      include Base
      plugin MongoMapper::Plugins::IdentityMap
      
      # Columns
      key :invoke_at, Time
      key :status, Integer, :default => TrackTweets::Models::TrackJob::ACTIVE
      timestamps!
      
      scope :active, where(:status => TrackTweets::Models::TrackJob::ACTIVE)
      
      belongs_to :track_item, :class_name => 'TrackTweets::Models::TrackItem'
      
      attr_accessible :invoke_at, :track_item
      
      def start
        tweets = track_item.tweets
        
        track_item.track_item_stats.create(:tweets_count => tweets.count, 
                                           :users_count => tweets.group_by('from_user_id').count, 
                                           :retweets_count => 0, 
                                           :processed_jobs_count => 0)
                                           
        track_item.tweets.destroy_all
                                           
        self.status = TrackTweets::Models::TrackJob::DONE
        save
                                           
        track_item.stat_jobs.create(:invoke_at => Time.now + track_item.group.timeout)
      end
    end
  end
end
