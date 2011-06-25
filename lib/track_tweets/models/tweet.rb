module TrackTweets
  module Models
    class Tweet
      include Base
      
      # Columns
      key :id_str, String
      key :from_user_id, Integer
      key :to_user_id, Integer
      key :from_user, String
      key :track_item_id, Integer
      key :track_job_id, Integer
      timestamps!
      
      # Validations
      validates_presence_of :id_str, :from_user_id
      
      belongs_to :track_item
      belongs_to :track_job
      
      attr_accessible :id_str, :from_user_id, :to_user_id, :from_user
    end
  end
end
