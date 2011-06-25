module TrackTweets
  module Models
    class Group
      include Base
      
      # Columns
      key :name, String
      key :public_token, String
      key :callback_url, String
      key :timeout, Integer, :default => 30
      key :delay, Integer, :default => 30
      key :state,  Integer, :default => 1
      timestamps!
      
      # Validations
      validates_presence_of :name
      
      many :track_items
      
      attr_accessible :name, :callback_url, :timeout, :delay
    end
  end
end
