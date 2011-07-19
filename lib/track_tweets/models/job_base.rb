module TrackTweets
  module Models
    module JobBase
      ACTIVE = 1
      DONE = 2
            
      def self.included(base)
        base.send :include, InstanceMethods
        base.send :extend, ClassMethods
      end
      
      module ClassMethods
        def self.extended(base)
          base.class_eval do
            include TrackTweets::Models::Base
            plugin MongoMapper::Plugins::IdentityMap
            
            # Columns
            key :invoke_at, Time
            key :status, Integer, :default => ACTIVE
            timestamps!
            
            belongs_to :track_item, :class_name => 'TrackTweets::Models::TrackItem'
      
            attr_accessible :invoke_at, :track_item
            
            scope :active, where(:status => ACTIVE)
          end
        end
      end
      
      module InstanceMethods
        
        def ready?(increment_column)
          track_item.active? && (invoke_at + track_item.group.read_attribute(increment_column)) <= Time.now
        end
        
        def start
          raise "not implemented"
        end
      end
    end
  end
end
