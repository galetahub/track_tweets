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
          http = Curl::Easy.new(url) do |curl| 
            curl.headers["User-Agent"] = "tracktweets-bot-#{VERSION}"
          end
          
          http.perform
          parse(http.body_str)
        rescue Exception => e
          TrackTweets.logger.info "Error to try request: #{e.message}"
          nil
        end
      end
      
      def track_jobs     
        start_jobs(Models::TrackJob.active.all, :delay)
      end
      
      def stats_jobs
        start_jobs(Models::StatJob.active.all, :timeout)
      end
      
      private 
        
        def parse(data)
          json = JSON.parse(data)
          json.blank? ? nil : json.symbolize_keys
        end
        
        # TODO: Do it by query, pass scope
        def start_jobs(jobs, increment_column)
          jobs.each do |job|
            job.start if job.ready?(increment_column)
          end
        end
    end
  end
end
