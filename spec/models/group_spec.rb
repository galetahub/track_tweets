require 'spec_helper'

describe TrackTweets::Models::Group do
  include GroupHelper
  
  before(:each) do
    @group = create_group
  end
  
  it "should create a new instance given valid attributes" do
    @group.save!
  end
  
  context "validations" do
    it "should not be valid with invalid name" do
      @group.name = nil
      @group.should_not be_valid
    end
    
    it "should not be valid with invalid timeout" do
      @group.timeout = 'wrong'
      @group.should_not be_valid
    end
    
    it "should not be valid with timeout <= delay" do
      @group.timeout = 50
      @group.delay = 100
      @group.should_not be_valid
      
      @group.delay = 50
      @group.should_not be_valid
    end
  end
end
