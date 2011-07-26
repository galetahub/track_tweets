module TrackTweets
  module Models
    class Tweet
      include Base
      
      # Columns
      key :id_str, String
      key :from_user_id, Integer
      key :to_user_id, Integer
      key :from_user, String
      key :state, Integer, :default => TrackTweets::ACTIVE
      timestamps!
      
      # Validations
      validates_presence_of :id_str, :from_user_id
      validates_uniqueness_of :id_str, :scope => :track_item_id
      
      belongs_to :track_item, :class_name => 'TrackTweets::Models::TrackItem'
      belongs_to :track_job, :class_name => 'TrackTweets::Models::TrackJob'
      
      attr_accessible :id_str, :from_user_id, :to_user_id, :from_user, :track_item
      
      scope :active, where(:state => TrackTweets::ACTIVE)
      scope :completed, where(:state => TrackTweets::COMPLETED)
      
      def self.count_by(column, options = {})
        options = { :out => "count_tweets_#{column}" }.merge(options)
        
        map_function = "function() { emit( this.#{column}, {count: 1}); }"

        reduce_function = "function(key, values) { 
          var count = 0;

          values.forEach(function(v) {
            count += v['count'];
          });

          return {count: count};
        }"
        
        count = collection.map_reduce(map_function, reduce_function, options).find
        count.first['value']['count']
      end
      
      def self.mark_completed(ids)
        set(ids, :state => TrackTweets::COMPLETED)
      end
      
      def self.by_users(track_item_id)
        distinct(:from_user_id, {:track_item_id => track_item_id, :state => TrackTweets::ACTIVE})
      end
      
      def active?
        self.state == TrackTweets::ACTIVE
      end
    end
  end
end
