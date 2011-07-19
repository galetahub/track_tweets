module GroupHelper
  def group_attributes
    { :name => "Test group", :timeout => 120, :delay => 30, :callback_url => nil }
  end
  
  def create_group
    TrackTweets::Models::Group.create(group_attributes)
  end
end
