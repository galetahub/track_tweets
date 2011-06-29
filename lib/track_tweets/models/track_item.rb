module TrackTweets
  module Models
    class TrackItem
      include Base
      
      # Columns
      key :query, String
      key :track_type_id, Integer
      key :group_id, Integer
      key :state, Integer
      timestamps!
      
      # Validations
      validates_presence_of :query, :group_id
      
      many :tweets
      many :track_jobs
      many :track_item_stats
      many :stat_jobs
      belongs_to :group
      
      attr_accessible :query, :track_type_id, :group_id
    end
  end
end
