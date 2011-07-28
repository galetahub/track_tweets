module TrackTweets
  module Models
    class StatJob
      include JobBase
      
      def start
        tweets_count = track_item.tweets.active.count
        users_count = Tweet.by_users_count(track_item.id)
        
        # TODO: do it by map_reduce
        #users_count = tweets_count.zero? ? 0 : Tweet.count_by(:from_user_id
        #  :query => {:track_item_id => track_item.id}
        #)
        
        track_item.track_item_stats.create(:tweets_count => tweets_count, 
                                           :users_count => users_count, 
                                           :retweets_count => 0, 
                                           :processed_jobs_count => 0)
                                           
        #track_item.tweets.destroy_all
        Tweet.mark_completed(track_item.id)
                                           
        self.status = DONE
        save
                                           
        track_item.stat_jobs.create(:invoke_at => Time.now.utc + track_item.group.timeout)
      end
    end
  end
end
