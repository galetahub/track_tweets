require "grape"

module TrackTweets
  class API < ::Grape::API
    prefix 'api'
    version 'v1'
    default_format :json
    
    http_basic do |username, password|
      username == "demo"
    end
    
    helpers do
      def render(collection, options = {})
        case (params[:format] || API.settings[:default_format]).to_s
          when 'xml' then collection.to_xml(options)
          when 'json' then collection.to_json(options)
          else collection
        end
      end
    end
    
    resources :groups do
      helpers do
        def group
          @group ||= Models::Group.find(params[:id])
        end
      end
      
      get do
        render Models::Group.all
      end
      
      get ':id' do
        render group
      end
      
      get ':id/show' do
        render group
      end
      
      post do
        render Models::Group.create(params[:group])
      end
      
      put ':id' do
        render group.update_attributes(params[:group])
      end
      
      delete '/:id' do
        group.destroy
        render group
      end
    end
    
    resources :track_items do
      helpers do
        def group
          @group ||= Models::Group.find(params[:group_id])
        end
        
        def track_item
          @track_item ||= Models::TrackItem.find(params[:id])
        end
      end
      
      get ':group_id' do
        render group.track_items
      end
      
      get ':group_id/:id/show' do
        render track_item
      end
      
      get ':group_id/:id/tweets' do
        render track_item.all_count
      end
      
      post ':group_id' do
        render group.track_items.create(params[:track_item])
      end
      
      put ':id' do
        render track_item.update_attributes(params[:track_item])
      end
      
      delete ':id' do
        track_item.destroy
        render track_item
      end
    end
  end
end
