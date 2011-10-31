namespace :data do
  desc "Clear all jobs, tweets and stats. Then create new jobs to all track_items"
  task :clear do
    TrackTweets::Models::StatJob.destroy_all
    TrackTweets::Models::TrackJob.destroy_all
    TrackTweets::Models::Tweet.destroy_all
    TrackTweets::Models::TrackItemStat.destroy_all
    
    TrackTweets::Models::TrackItem.all.each do |item|
      item.create_jobs
    end
  end
  
  task :items_without_group do
    TrackTweets::Models::TrackItem.all.each do |item|
      puts item.destroy if item.group.nil?
    end
  end
end
