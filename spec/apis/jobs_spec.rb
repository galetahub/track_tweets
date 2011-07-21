require 'spec_helper'

describe TrackTweets::API do
  include GroupHelper
  
  def app
    TrackTweets::API
  end
  
  before(:all) do
    @group = create_group
    @group.track_items.create(track_item_attributes)
  end
  
  context "with_authentication" do
    before(:each) do
      authorize 'demo', 'demo'
    end
    
    it 'should render list track jobs' do
      get "/api/v1/jobs/tracks.xml"
      last_response.status.should == 200
    end
    
    it 'should render list stats jobs' do
      get "/api/v1/jobs/stats.xml"
      last_response.status.should == 200
    end
  end
  
  context "without authentication" do
    it 'should not render list track jobs' do
      get "/api/v1/jobs/tracks.xml"
      last_response.status.should == 401
    end
    
    it 'should not render list stats jobs' do
      get "/api/v1/jobs/stats.xml"
      last_response.status.should == 401
    end
  end
end
