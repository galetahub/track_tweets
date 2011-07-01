#require ''

namespace :checker do
  desc "track jobs"
  task :track_jobs do
    TrackTweets::Checker.get(:q => 'udp', :rpp => 10, :page => 1)
  end
  
  task :temp_data do
    TrackTweets::Models::Group.destroy_all
    TrackTweets::Models::TrackItem.destroy_all
    
    group = TrackTweets::Models::Group.create(:name => 'McDonalds', :timeout => 60, :delay => 10)
    
    item = group.track_items.create(:query => 'udp')
  end
end
