require 'spec_helper'

describe TrackTweets::Models::TrackItem do
  include GroupHelper
  
  before(:each) do
    @group = create_group
    @track_item = @group.track_items.build(track_item_attributes)
  end
  
  it "should create a new instance given valid attributes" do
    @track_item.save!
  end
  
  context "validations" do
    it "should not be valid with invalid query" do
      @track_item.query = nil
      @track_item.should_not be_valid
    end
    
    it "should not be valid with invalid track_type_id" do
      @track_item.track_type_id = 'wrong'
      @track_item.should_not be_valid
    end
    
    it "should not be valid with taken query" do
      @group.track_items.create(track_item_attributes.merge(:query => @track_item.query))
      @track_item.should_not be_valid
    end
  end
  
  context "after_create" do
    before(:each) do
      @track_item.save
    end
    
    it "should set active status" do
      @track_item.should be_active
    end
    
    it "should create track_job" do
      @track_item.track_jobs.count.should == 1
    end
    
    it "should create stat_job" do
      @track_item.stat_jobs.count.should == 1
    end
    
    it "should run new track_job" do
      track_job = @track_item.track_jobs.first
      track_job.ready?(:delay).should be_false
      
      track_job.invoke_at = 1.day.ago
      track_job.save
      
      track_job.ready?(:delay).should be_true
    end
  end
end
