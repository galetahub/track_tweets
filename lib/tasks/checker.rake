namespace :checker do
  desc "Start tracking tweets jobs (must run every 5 minutes)"
  task :track_jobs do
    TrackTweets::Checker.track_jobs
  end
  
  desc "Start statisticts jobs (must run every hour)"
  task :stats_jobs do
    TrackTweets::Checker.stats_jobs
  end
end
