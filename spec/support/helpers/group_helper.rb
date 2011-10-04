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
    { :query => rand_str, :track_type_id => 1 }.merge(options)
  end
  
  def tweet_attributes(options = {})
    { :id_str => rand_str, :from_user_id => 1111 }.merge(options)
  end
  
  private
  
    def rand_str(count=15)
      ActiveSupport::SecureRandom.base64(count).tr('+/=', 'xyz')
    end 
end
