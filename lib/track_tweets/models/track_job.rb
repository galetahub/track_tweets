module TrackTweets
  module Models
    class TrackJob
      include Base
      plugin MongoMapper::Plugins::IdentityMap
      
      # Columns
      key :invoke_at, Time
      key :completed_in, Float
      key :max_id, Integer
      key :since_id, Integer
      key :parent_id, ObjectId
      key :status, Integer, :default => 1
      timestamps!
      
      belongs_to :track_item, :class_name => 'TrackTweets::Models::TrackItem'
      belongs_to :parent, :class_name => 'TrackTweets::Models::TrackJob'
      many :tweets, :class_name => 'TrackTweets::Models::Tweet'
      
      attr_accessible :invoke_at, :completed_in, :max_id, :since_id
    end
  end
end
