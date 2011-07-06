module TrackTweets
  module Models
    class TrackItemStat
      include Base
      
      # Columns
      key :tweets_count, Integer
      key :users_count, Integer
      key :retweets_count, Integer
      key :processed_jobs_count, Integer
      timestamps!
      
      # Validations
      validates_presence_of :tweets_count, :track_item_id
      
      belongs_to :track_item, :class_name => 'TrackTweets::Models::TrackItem'
      
      attr_accessible :tweets_count, :users_count, :retweets_count, :processed_jobs_count, :track_item
      
      def self.sum_count_by(column, options = {})
        map_function = "function() { emit( this.#{column}, 1); }"

        reduce_function = %Q( function(key, values) { 
          var sum = 0;  
  
          for (index in values) {  
              sum += values[index];  
          }  
      
          return {sum: sum};
        }) 
        
        collection.map_reduce(map_function, reduce_function, options)
      end
    end
  end
end
