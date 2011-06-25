module TrackTweets
  module Models
    class TrackJob
      include Base
      
      # Columns
      key :invoke_at, Time
      key :completed_in, Float
      key :max_id, Integer
      key :since_id, Integer
      key :track_item_id, Integer
      key :track_job_id, Integer
      timestamps!
      
      belongs_to :track_item
      many :track_job
      many :tweets
      
      attr_accessible :invoke_at, :completed_in, :max_id, :since_id
    end
  end
end
