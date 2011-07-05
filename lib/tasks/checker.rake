#require ''

namespace :checker do
  desc "track jobs"
  task :track_jobs do
    TrackTweets::Checker.track_jobs
  end
  
  desc "stats jobs"
  task :stats_jobs do
    TrackTweets::Checker.stats_jobs
  end
  
  task :temp_data do
    TrackTweets::Models::Group.destroy_all
    TrackTweets::Models::TrackItem.destroy_all
    
    group = TrackTweets::Models::Group.create(:name => 'McDonalds', :timeout => 60, :delay => 20)
    
    item = group.track_items.create(:query => 'udp')
  end
  
  task :temp do
    item = TrackTweets::Models::TrackItem.first 
    item.stat_jobs.create(:invoke_at => Time.now + item.group.timeout)
  end
end
