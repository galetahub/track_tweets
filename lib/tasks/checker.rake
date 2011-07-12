namespace :checker do
  desc "Start tracking tweets jobs"
  task :track_jobs do
    TrackTweets::Checker.track_jobs
  end
  
  desc "Start statisticts jobs"
  task :stats_jobs do
    TrackTweets::Checker.stats_jobs
  end
end
