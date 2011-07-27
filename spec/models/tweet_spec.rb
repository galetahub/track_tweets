require 'spec_helper'

describe TrackTweets::Models::Tweet do
  include GroupHelper
  
  before(:each) do
    @group = create_group
    @track_item = @group.track_items.create(track_item_attributes)
    @tweet = @track_item.tweets.build(tweet_attributes)
  end
  
  it "should create a new instance given valid attributes" do
    @tweet.save!
  end
  
  context "validations" do
    it "should not be valid without id_str" do
      @tweet.id_str = nil
      @tweet.should_not be_valid
    end
    
    it "should not be valid without from_user_id" do
      @tweet.from_user_id = nil
      @tweet.should_not be_valid
    end
    
    it "should not be valid with invalid from_user_id" do
      @tweet.from_user_id = 'wrong'
      @tweet.should_not be_valid
    end
    
    it "should not be valid with same id_str" do
      @track_item.tweets.create(tweet_attributes(:id_str => @tweet.id_str))
      @tweet.should_not be_valid
    end
    
    it "should be valid with same id_str and another track_item" do
      another_item = @group.track_items.create(track_item_attributes)
      another_item.tweets.create(tweet_attributes(:id_str => @tweet.id_str))
      @tweet.should be_valid
    end
  end
  
  context "after_create" do
    before(:each) do
      @tweet.save
    end
    
    it "should set active status" do
      @tweet.should be_active
    end
  end
  
  context "jobs" do
    before(:each) do
      (1..5).to_a.each do |num|
        @track_item.tweets.create(
          :id_str => num.to_s, 
          :from_user_id => num + 1,
          :to_user_id => nil,
          :from_user => (num + 1).to_s)
      end
    end
    
    it "should set completed status" do
      TrackTweets::Models::Tweet.mark_completed(@track_item.id)
      
      @track_item.tweets.completed.count.should == 5
      @track_item.tweets.active.count.should == 0
    end
  end
end
