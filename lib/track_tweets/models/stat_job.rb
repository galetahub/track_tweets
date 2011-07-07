module TrackTweets
  module Models
    class StatJob
      include Base
      plugin MongoMapper::Plugins::IdentityMap
      
      # Columns
      key :invoke_at, Time
      key :status, Integer, :default => TrackJob::ACTIVE
      timestamps!
      
      scope :active, where(:status => TrackJob::ACTIVE)
      
      belongs_to :track_item, :class_name => 'TrackTweets::Models::TrackItem'
      
      attr_accessible :invoke_at, :track_item
      
      def start
        tweets = track_item.tweets
        uniq_tweets = Tweet.count_by(:from_user_id, :query => {:track_item_id => track_item.id}).find() 
        
        #puts tweets.group_by{|t| t.from_user_id}.count
        #puts uniq_tweets.count
        
        track_item.track_item_stats.create(:tweets_count => tweets.count, 
                                           :users_count => uniq_tweets.count, 
                                           :retweets_count => 0, 
                                           :processed_jobs_count => 0)
                                           
        track_item.tweets.destroy_all
                                           
        self.status = TrackJob::DONE
        save
                                           
        track_item.stat_jobs.create(:invoke_at => Time.now + track_item.group.timeout)
      end
    end
  end
end
