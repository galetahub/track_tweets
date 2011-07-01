module TrackTweets
  module Models
    class StatJob
      include Base
      plugin MongoMapper::Plugins::IdentityMap
      
      # Columns
      key :invoke_at, Time
      key :completed_in, Float
      key :parent_id, ObjectId
      key :status, Integer, :default => 1
      timestamps!
      
      belongs_to :track_item, :class_name => 'TrackTweets::Models::TrackItem'
      belongs_to :parent, :class_name => 'TrackTweets::Models::StatJob'
      many :track_item_stats, :class_name => 'TrackTweets::Models::TrackItemStat'
      
      attr_accessible :invoke_at, :completed_in, :max_id, :since_id
    end
  end
end
