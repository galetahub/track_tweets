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
end
