module TrackTweets
  module Models
    class Group
      include MongoMapper::Document

      key :name, String
      key :public_token, String
      key :callback_url, String
      key :timeout, Integer
      key :delay, Integer
      key :state,  Integer
      
      attr_accessible :name, :callback_url, :timeout, :delay
      
      def to_xml(options = {}, &block)
        options[:root] = "group"
        super
      end
    end
  end
end
