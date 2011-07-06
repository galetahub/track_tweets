module TrackTweets
  module Models
    class Tweet
      include Base
      
      # Columns
      key :id_str, String
      key :from_user_id, Integer
      key :to_user_id, Integer
      key :from_user, String
      timestamps!
      
      # Validations
      validates_presence_of :id_str, :from_user_id
      validates_uniqueness_of :id_str
      
      belongs_to :track_item, :class_name => 'TrackTweets::Models::TrackItem'
      belongs_to :track_job, :class_name => 'TrackTweets::Models::TrackJob'
      
      attr_accessible :id_str, :from_user_id, :to_user_id, :from_user, :track_item
      
      def self.count_by(column, options = {})
        map_function = "function() { emit( this.#{column}, 1); }"

        reduce_function = %Q( function(key, values) { 
          return true;
        }) 
        
        collection.map_reduce(map_function, reduce_function, options)
      end
    end
  end
end
