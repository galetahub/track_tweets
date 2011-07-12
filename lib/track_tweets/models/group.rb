module TrackTweets
  module Models
    class Group
      include Base
      
      # Columns
      key :name, String
      key :callback_url, String
      key :timeout, Integer, :default => 60
      key :delay, Integer, :default => 30
      key :state,  Integer, :default => 1
      timestamps!
      
      # Validations
      validates_presence_of :name
      validate :timeout_vs_delay
      
      many :track_items, :class_name => 'TrackTweets::Models::TrackItem'
      
      attr_accessible :name, :callback_url, :timeout, :delay
      
      private
      
        def timeout_vs_delay
          if timeout <= delay
            errors.add(:timeout, "Timeout must be more than delay")
          end
        end
    end
  end
end
