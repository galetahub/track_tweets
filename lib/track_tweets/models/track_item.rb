module TrackTweets
  module Models
    class TrackItem
      include Base
      
      # Columns
      key :query, String
      key :track_type_id, Integer, :default => 1
      key :state, Integer, :default => 1
      timestamps!
      
      # Validations
      validates_presence_of :query
      validates_uniqueness_of :query
      
      many :tweets, :class_name => 'TrackTweets::Models::Tweet'
      many :track_jobs, :class_name => 'TrackTweets::Models::TrackJob'
      many :track_item_stats, :class_name => 'TrackTweets::Models::TrackItemStat'
      many :stat_jobs, :class_name => 'TrackTweets::Models::StatJob'
      belongs_to :group, :class_name => 'TrackTweets::Models::Group'
      
      attr_accessible :query, :track_type_id
      
      after_create :create_jobs
      
      def active?
        self.state == TrackTweets::ACTIVE
      end
      
      private 
        
        def create_jobs
          track_jobs.create(:invoke_at => Time.now + group.delay)
          stat_jobs.create(:invoke_at => Time.now + group.timeout)
        end
    end
  end
end
