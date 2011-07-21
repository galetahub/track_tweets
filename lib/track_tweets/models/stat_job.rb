module TrackTweets
  module Models
    class StatJob
      include JobBase
      
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
                                           
        self.status = DONE
        save
                                           
        track_item.stat_jobs.create(:invoke_at => Time.now.utc + track_item.group.timeout)
      end
    end
  end
end
