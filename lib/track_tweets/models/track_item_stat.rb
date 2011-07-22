module TrackTweets
  module Models
    class TrackItemStat
      include Base
      
      # Columns
      key :tweets_count, Integer, :default => 0
      key :users_count, Integer, :default => 0
      key :retweets_count, Integer, :default => 0
      key :processed_jobs_count, Integer, :default => 0
      timestamps!
      
      # Validations
      validates_presence_of :tweets_count, :track_item_id
      
      belongs_to :track_item, :class_name => 'TrackTweets::Models::TrackItem'
      
      attr_accessible :tweets_count, :users_count, :retweets_count, :processed_jobs_count, :track_item
      
      def self.sum_count_by(column, options = {})
        options = { :out => "sum_track_item_#{column}" }.merge(options)
        map_function = "function() { emit( this.track_item_id, {rows: 1, count: this.#{column}}); }"

        reduce_function = "function(key, values) { 
          var result = {rows: 0, count: 0};

          for(var i = 0; i < values.length; i++) {
            result.rows += values[i].rows;
            result.count += values[i].count;
          }

          return result;
        }"
        
        collection.map_reduce(map_function, reduce_function, options)
      end
    end
  end
end
