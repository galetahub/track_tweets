module TrackTweets
  module Models
    class TrackItem
      include Base
      
      # Columns
      key :query, String
      key :track_type_id, Integer, :default => 1
      key :state, Integer, :default => TrackTweets::ACTIVE
      timestamps!
      
      # Validations
      validates_presence_of :query
      validates_uniqueness_of :query, :scope => :group_id
      validates_numericality_of :track_type_id, :only_integer => true
      
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
      
      def all_count
        { :id => id, :query => query, :tweets => tweets_count, :users => users_count }
      end
      
      def tweets_count
        calc_sum(:tweets_count)
      end
      
      def users_count
        calc_sum(:users_count)
      end
      
      private 
        
        def create_jobs
          track_jobs.create(:invoke_at => Time.now.utc + group.delay)
          stat_jobs.create(:invoke_at => Time.now.utc + group.timeout)
        end
        
        def calc_sum(column)
          unless TrackItemStat.count.zero?
            count = TrackItemStat.sum_count_by(column, :query => {:track_item_id => self.id}).find
              
            count.first['value']
          end
        end
    end
  end
end
