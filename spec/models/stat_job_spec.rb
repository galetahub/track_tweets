require 'spec_helper'

describe TrackTweets::Models::StatJob do
  include GroupHelper
  
  before(:each) do
    @group = create_group
    @track_item = @group.track_items.create(track_item_attributes)
    @stat_job = @track_item.stat_jobs.first
  end
  
  it "should be not ready" do
    @stat_job.ready?(:timeout).should be_false
  end
  
  context "active job" do
    before(:each) do
      @stat_job.invoke_at = 5.minutes.ago
      @stat_job.save
    end
    
    it "should be ready for start" do
      @stat_job.ready?(:timeout).should be_true
    end
    
    it "should run job start" do
      @stat_job.should_receive(:start)
      TrackTweets::Checker.stats_jobs
    end
    
    context "job start" do
      before(:each) do
        (1..5).to_a.each do |num|
          @track_item.tweets.create(
            :id_str => num.to_s, 
            :from_user_id => num + 1,
            :to_user_id => nil,
            :from_user => (num + 1).to_s)
        end
        
        @track_item.tweets.create(
            :id_str => '10', 
            :from_user_id => 2,
            :to_user_id => nil,
            :from_user => '2')
        
        @stat_job.start
      end
      
      it "should set status done" do
        @stat_job.status.should == TrackTweets::Models::StatJob::DONE
      end
      
      it "should create new statistict job" do
        @track_item.stat_jobs.count.should == 2
      end
      
      it "should calculate statisticts" do
        stat = @track_item.track_item_stats.last
        stat.tweets_count.should == 6
        stat.users_count.should == 5
      end
    end
  end
end
