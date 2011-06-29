#require ''

namespace :checker do
  desc "track jobs"
  task :track_jobs do
    TrackTweets::Checker.get(:q => 'udp', :rpp => 100, :page => 1, :max_id => 86044888235393024)
  end
end
