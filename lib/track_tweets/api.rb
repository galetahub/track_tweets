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
        case params[:format]
          when 'xml' then collection.to_xml(options)
          when 'json' then collection.to_json(options)
          else collection
        end
      end
    end
    
    resource :groups do
      get do
        render Models::Group.all
      end
      
      get '/:id/show' do
        render Models::Group.find(params[:id])
      end
      
      post :create do
        render Models::Group.create(params[:group])
      end
    end
    
    resource :track_items do
      get '/:group_id' do
      end
    end
    
    resource :track_item_stats do
    end
  end
end
