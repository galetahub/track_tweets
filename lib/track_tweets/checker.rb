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
        
        # results - [{"created_at"=>"Wed, 29 Jun 2011 12:14:34 +0000", "profile_image_url"=>"http://a2.twimg.com/profile_images/1419946812/148831_470104903327_773263327_5376119_2785649_n_normal.jpg", "from_user_id_str"=>"217828692", "id_str"=>"86044888235393024", "from_user"=>"cako_bianchi", "text"=>"Tomando control (@ UDP facultad de econom\303\255a y empresa) http://4sq.com/iio5Fn", "to_user_id"=>nil, "metadata"=>{"result_type"=>"recent"}, "id"=>86044888235393024, "geo"=>{"coordinates"=>[-33.4527, -70.6583], "type"=>"Point"}, "from_user_id"=>217828692, "iso_language_code"=>"es", "source"=>"&lt;a href=&quot;http://foursquare.com&quot; rel=&quot;nofollow&quot;&gt;foursquare&lt;/a&gt;", "to_user_id_str"=>nil, "place"=>{"id"=>"1b107df3ccc0aaa1", "type"=>"country", "full_name"=>"Brasil"}}]
        # info - "max_id"=>86403642382499840, "since_id"=>0, "refresh_url"=>"?since_id=86403642382499840&q=udp", "next_page"=>"?page=2&max_id=86403642382499840&rpp=10&q=udp", "page"=>1, "results_per_page"=>10, "completed_in"=>0.398884, "since_id_str"=>"0", "query"=>"udp", "max_id_str"=>"86403642382499840"
        def parse(data)
          json = JSON.parse(data)
          
          json
          
          puts json.inspect
        end
    end
  end
end
