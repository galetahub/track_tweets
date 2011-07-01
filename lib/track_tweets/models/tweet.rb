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
      
      belongs_to :track_item, :class_name => 'TrackTweets::Models::TrackItem'
      belongs_to :track_job, :class_name => 'TrackTweets::Models::TrackJob'
      
      attr_accessible :id_str, :from_user_id, :to_user_id, :from_user
    end
  end
end
