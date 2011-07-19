desc 'Display all API routes'
task :routes do
  all_routes = TrackTweets::API.send(:route_set).instance_variable_get("@routes")
  
  all_routes.each do |r|
    puts r.conditions
  end
end
