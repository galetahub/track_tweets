require 'spec_helper'

describe TrackTweets::API do
  include GroupHelper
  
  def app
    TrackTweets::API
  end
  
  before(:all) do
    @group = create_group
    @attrs = track_item_attributes
  end
  
  context "with_authentication" do
    before(:each) do
      authorize 'demo', 'demo'
    end
    
    it 'should create new track_item' do
      lambda {
        post "/api/v1/groups/#{@group.id}/track_items.xml", :track_item => @attrs
      }.should change { @group.track_items.count }.by(1)
      
      last_response.status.should == 201
    end
    
    it "should not create track_item with invalid params" do
      lambda {
        post "/api/v1/groups/#{@group.id}/track_items.xml", :track_item => @attrs.merge(:query => nil)
      }.should_not change { @group.track_items.count }
      
      last_response.status.should == 422
      last_response.body.should include("<errors>")
    end
    
    context "exists track_item" do
      before(:each) do
        @track_item = @group.track_items.create(track_item_attributes)
      end
      
      it "should render all track_items group" do
        get "/api/v1/groups/#{@group.id}/track_items.xml"
        
        last_response.status.should == 200
        last_response.body.should include(@track_item.id.to_s)
      end
      
      it "should render one track_item" do
        get "/api/v1/groups/#{@group.id}/track_items/#{@track_item.id}.xml"
        
        last_response.status.should == 200
        last_response.body.should include(@track_item.id.to_s)
      end
      
      it "should render track_item tweets statisticts" do
        get "/api/v1/groups/#{@group.id}/track_items/#{@track_item.id}/tweets.xml"
        
        last_response.status.should == 200
        last_response.body.should == ''
      end
      
      it "should render one track_item without group" do
        get "/api/v1/track_items/#{@track_item.id}.xml"
        
        last_response.status.should == 200
        last_response.body.should include(@track_item.id.to_s)
      end
      
      it "should render track_item tweets statisticts without group" do
        get "/api/v1/track_items/#{@track_item.id}/tweets.xml"
        
        last_response.status.should == 200
        last_response.body.should == ''
      end
      
      it "should update track_item" do
        put "/api/v1/track_items/#{@track_item.id}.xml", :track_item => { :query => 'superpuper' }
        
        last_response.status.should == 200
        last_response.body.should include(@track_item.id.to_s)
        last_response.body.should include("<query>superpuper</query>")
      end
      
      it "should destroy track_item" do
        lambda {
          delete "/api/v1/track_items/#{@track_item.id}.xml"
        }.should change { @group.track_items.count }.by(-1)
      end
    end
  end
  
  context "without authentication" do
    it "should not render all track_items group" do
      get "/api/v1/groups/#{@group.id}/track_items.xml"
      last_response.status.should == 401
    end
    
    it "should not create track_items" do
      lambda {
        post "/api/v1/groups/#{@group.id}/track_items.xml", :track_item => @attrs
      }.should_not change { @group.track_items.count }
      
      last_response.status.should == 401
    end
  end
  
  context "with bad authentication" do
    before(:each) do
      authorize 'wrong', 'wrong'
    end
    
    it "should not render all track_items group" do
      get "/api/v1/groups/#{@group.id}/track_items.xml"
      last_response.status.should == 401
    end
    
    it "should not create track_items" do
      lambda {
        post "/api/v1/groups/#{@group.id}/track_items.xml", :track_item => @attrs
      }.should_not change { @group.track_items.count }
      
      last_response.status.should == 401
    end
  end
end
