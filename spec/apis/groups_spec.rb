require 'spec_helper'

describe TrackTweets::API do
  include GroupHelper
  
  def app
    TrackTweets::API
  end
  
  before(:all) do
    @attrs = group_attributes
  end
  
  context "with_authentication" do
    before(:each) do
      authorize 'demo', 'demo'
    end
    
    it 'should create new group' do
      lambda {
        post "/api/v1/groups.xml", :group => @attrs
      }.should change { TrackTweets::Models::Group.count }.by(1)
      
      last_response.status.should == 201
    end
    
    it "should not create group with invalid params" do
      lambda {
        post "/api/v1/groups.xml", :group => @attrs.merge(:delay => 'wrong')
      }.should_not change { TrackTweets::Models::Group.count }
      
      last_response.status.should == 422
      last_response.body.should include("<errors>")
    end
    
    context "exists group" do
      before(:each) do
        @group = create_group
      end
      
      it "should render all groups" do
        get "/api/v1/groups.xml"
        
        last_response.status.should == 200
        last_response.body.should include(@group.id.to_s)
      end
      
      it "should render one group" do
        get "/api/v1/groups/#{@group.id}.xml"
        
        last_response.status.should == 200
        last_response.body.should include(@group.id.to_s)
      end
      
      it "should render group stats" do
        item = @group.track_items.create(track_item_attributes)
        
        (1..5).to_a.each do |num|
          item.track_item_stats.create(:tweets_count => num + 1, :users_count => num)
        end
        
        get "/api/v1/groups/#{@group.id}/stats.xml"
        
        last_response.status.should == 200
        last_response.body.should include("<query>#{item.query}</query>")
        last_response.body.should include("<id>#{item.id}</id>")
        last_response.body.should include("<users type=\"integer\">15</users>")
        last_response.body.should include("<tweets type=\"integer\">20</tweets>")
      end
      
      it "should update group" do
        put "/api/v1/groups/#{@group.id}.xml", :group => { :name => "Super group" }
        
        last_response.status.should == 200
        last_response.body.should include(@group.id.to_s)
        last_response.body.should include("<name>Super group</name>")
      end
      
      it "should destroy group" do
        lambda {
          delete "/api/v1/groups/#{@group.id}.xml"
        }.should change { TrackTweets::Models::Group.count }.by(-1)
      end
    end
  end
  
  context "without authentication" do
    it "should not render all groups" do
      get "/api/v1/groups.xml"
      last_response.status.should == 401
    end
    
    it "should not create group" do
      post "/api/v1/groups.xml", :group => @attrs
      last_response.status.should == 401
    end
  end
  
  context "with bad authentication" do
    before(:each) do
      authorize 'wrong', 'wrong'
    end
    
    it "should not render all groups" do
      get "/api/v1/groups.xml"
      last_response.status.should == 401
    end
    
    it "should not create groups" do
      post "/api/v1/groups.xml", :group => @attrs
      last_response.status.should == 401
    end
  end
end
