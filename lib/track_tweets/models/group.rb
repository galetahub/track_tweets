module TrackTweets
  module Models
    class Group
      include Base
      
      # Columns
      key :name, String
      key :callback_url, String
      key :timeout, Integer, :default => (60 * 60 * 4)
      key :delay, Integer, :default => (60 * 60 * 2)
      key :state,  Integer, :default => 1
      timestamps!
      
      # Validations
      validates_presence_of :name
      validates_numericality_of :timeout, :delay, :only_integer => true
      validate :timeout_vs_delay
      
      many :track_items, :class_name => 'TrackTweets::Models::TrackItem', :dependent => :destroy
      
      attr_accessible :name, :callback_url, :timeout, :delay
      
      def all_stats
        track_items.map{|item| item.all_count}
      end
      
      private
      
        def timeout_vs_delay
          if timeout <= delay
            errors.add(:timeout, "Timeout must be more than delay")
          end
        end
    end
  end
end
