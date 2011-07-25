module GroupHelper
  def group_attributes(name="Test group")
    { :name => name, :timeout => 120, :delay => 30, :callback_url => nil }
  end
  
  def create_group
    TrackTweets::Models::Group.create(group_attributes)
  end
  
  def create_group_with_name(name)
    TrackTweets::Models::Group.create(group_attributes(name))
  end
  
  def track_item_attributes(options = {})
    rand_string = ActiveSupport::SecureRandom.base64(15).tr('+/=', 'xyz')
    { :query => rand_string, :track_type_id => 1 }.merge(options)
  end
end
