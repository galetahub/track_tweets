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
      
      def track_jobs     
        start_jobs(TrackTweets::Models::TrackJob.active.all, :delay)
      end
      
      def stats_jobs
        start_jobs(TrackTweets::Models::StatJob.active.all, :timeout)
      end
      
      private 
        
        def parse(data)
          json = JSON.parse(data)
          json.symbolize_keys! unless json.blank?
        end
        
        def start_jobs(jobs, increment_column)
          jobs.each do |job|
            job.start if job.track_item.active? && (job.invoke_at + job.track_item.group.read_attribute(increment_column)) <= Time.now
          end
        end
    end
  end
end
