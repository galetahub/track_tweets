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
      get '/:group_id' do
      end
    end
    
    resources :track_item_stats do
    end
  end
end
