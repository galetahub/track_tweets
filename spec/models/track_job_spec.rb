require 'spec_helper'

describe TrackTweets::Models::TrackJob do
  include GroupHelper
  
  before(:each) do
    @group = create_group
    @track_item = @group.track_items.create(track_item_attributes)
    @track_job = @track_item.track_jobs.first
  end
  
  it "should be not ready" do
    @track_job.ready?(:delay).should be_false
  end
  
  context "active job" do
    before(:each) do
      @track_job.invoke_at = 5.minutes.ago
      @track_job.save
    end
    
    it "should be ready for start" do
      @track_job.ready?(:delay).should be_true
    end
    
    it "should run job start" do
      @track_job.should_receive(:start)
      TrackTweets::Checker.track_jobs
    end
  end
end
