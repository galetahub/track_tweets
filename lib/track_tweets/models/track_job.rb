module TrackTweets
  module Models
    class TrackJob
      include JobBase
      
      # Columns
      key :completed_in, Float
      key :max_id, Integer
      key :since_id, Integer
      key :parent_id, ObjectId
      key :page, Integer, :default => 1
      
      belongs_to :parent, :class_name => 'TrackTweets::Models::TrackJob'
      many :tweets, :class_name => 'TrackTweets::Models::Tweet'
      
      attr_accessible :completed_in, :max_id, :since_id, :page
          
      def start
        response = Checker.get(params)
        
        # create tweets
        response[:results].each do |tweet|
          tweet.symbolize_keys!
          tweets.create(:id_str => tweet[:id_str], 
                        :from_user_id => tweet[:from_user_id], 
                        :to_user_id => tweet[:to_user_id],
                        :from_user => tweet[:from_user],
                        :track_item => track_item)
        end
        
        # create next job
        job = self.class.new(:invoke_at => Time.now + track_item.group.delay, :track_item => track_item)
        
        unless response[:next_page].blank?
          job.parent =  self
          job.max_id = response[:max_id]
          job.page = response[:page] + 1
        else
          job.since_id = response[:max_id]
        end
        
        job.save
        
        # save and close current job
        self.max_id = response[:max_id]
        self.since_id = response[:since_id]
        self.completed_in = response[:completed_in]
        self.status = DONE
        save
      end
      
      protected
      
        def params
          { :q => track_item.query, :rpp => 100, :page => self.page, :max_id => self.max_id, :since_id => self.since_id }
        end
      
=begin      
 results - [{"created_at"=>"Wed, 29 Jun 2011 12:14:34 +0000", 
             "profile_image_url"=>"http://a2.twimg.com/profile_images/1419946812/148831_470104903327_773263327_5376119_2785649_n_normal.jpg", 
             "from_user_id_str"=>"217828692", 
             "id_str"=>"86044888235393024", 
             "from_user"=>"cako_bianchi", 
             "text"=>"Tomando control (@ UDP facultad de econom\303\255a y empresa) http://4sq.com/iio5Fn", 
             "to_user_id"=>nil, 
             "metadata"=>{"result_type"=>"recent"}, 
             "id"=>86044888235393024,
             "geo"=>{"coordinates"=>[-33.4527, -70.6583], "type"=>"Point"}, 
             "from_user_id"=>217828692, 
             "iso_language_code"=>"es", 
             "source"=>"&lt;a href=&quot;http://foursquare.com&quot; rel=&quot;nofollow&quot;&gt;foursquare&lt;/a&gt;",
             "to_user_id_str"=>nil, 
             "place"=>{"id"=>"1b107df3ccc0aaa1", "type"=>"country", "full_name"=>"Brasil"}}]
             
 info - "max_id"=>86403642382499840, 
        "since_id"=>0, 
        "refresh_url"=>"?since_id=86403642382499840&q=udp", 
        "next_page"=>"?page=2&max_id=86403642382499840&rpp=10&q=udp", 
        "page"=>1, 
        "results_per_page"=>10, 
        "completed_in"=>0.398884, 
        "since_id_str"=>"0", 
        "query"=>"udp", 
        "max_id_str"=>"86403642382499840"
=end
    
    end
  end
end
