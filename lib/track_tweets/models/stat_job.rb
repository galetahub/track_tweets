module TrackTweets
  module Models
    class StatJob
      include Base
      
      # Columns
      key :invoke_at, Time
      key :completed_in, Float
      key :track_item_id, Integer
      key :stat_job_id, Integer
      key :status, Integer
      timestamps!
      
      belongs_to :track_item
      many :stat_job
      many :track_item_stats
      
      attr_accessible :invoke_at, :completed_in, :max_id, :since_id
    end
  end
end
