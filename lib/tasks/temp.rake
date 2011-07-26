namespace :temp do
  task :data do
    TrackTweets::Models::Group.destroy_all
    TrackTweets::Models::TrackItem.destroy_all
    
    group = TrackTweets::Models::Group.create(:name => 'McDonalds', :timeout => 60, :delay => 20)
    
    item = group.track_items.create(:query => 'udp')
  end
  
  task :create_group do
    url = "http://localhost:3000/api/v1/groups"
    
    http = Curl::Easy.new(url)
    http.http_auth_types = :basic
    http.username = 'demo'
    http.password = ''
    
    http.perform
    puts http.body_str
    
    # post
    http.http_post("http://localhost:3000/api/v1/groups", 
                          Curl::PostField.content('group[name]', 'Pepsi'),
                          Curl::PostField.content('group[timeout]', '120'),
                          Curl::PostField.content('group[delay]', '10'))
    puts http.body_str
  end
  
  task :includes do
    jobs = TrackTweets::Models::TrackJob.can_started.where(:"track_item.state" => 1).all
    puts jobs.inspect
  end
end
