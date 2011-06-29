require 'curl'
require 'json'

module TrackTweets
  class Checker   
    BASE_URL = "http://search.twitter.com/search.json"
        
    class << self
      
      # send request by curl and parse by json
      # example: Checker.get(:q => 'udp', :rpp => 100, :page => 2, :since_id => 86044888235393024, :max_id => 86044888235393024)
      def get(params)
        query = Rack::Utils.build_query(params)
        url = [BASE_URL, query].join('?')
        
        TrackTweets.logger.info "Send request: #{url}"
        
        begin
          http = Curl::Easy.new(url)
          
          http = Curl::Easy.new(url) do |curl| 
            curl.headers["User-Agent"] = "track_tweets-#{VERSION}"
          end
          
          http.perform
          
          TrackTweets.logger.info "Successfully get response: #{url}"
          
          parse(http.body_str)
        rescue Exception => e
          TrackTweets.logger.info "Error to try request: #{e.message}"
          nil
        end
      end
      
      private 
      
        def parse(data)
          json = JSON.parse(data)
          
          puts json.inspect
        end
    end
  end
end
