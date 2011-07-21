require "grape"

module TrackTweets
  class API < ::Grape::API
    prefix 'api'
    version 'v1'
    default_format :json
    
    class << self
      def logger
        TrackTweets.logger
      end
      
      # Fix issue:
      # https://github.com/josh/rack-mount/issues/16
      # Commit: https://github.com/intridea/grape/commit/316d863a5049ef99ce802af37b35284123878fe8
      #
      def route(methods, paths, &block)
        methods = Array(methods)
        paths = ['/'] if paths == []
        paths = Array(paths)
        endpoint = build_endpoint(&block)
        options = {}
        options[:version] = /#{version.join('|')}/ if version
        
        methods.each do |method|
          paths.each do |path|
            path = Rack::Mount::Strexp.compile(compile_path(path), options, %w( / . ? ), true)
            route_set.add_route(endpoint,
              :path_info => path,
              :request_method => (method.to_s.upcase unless method == :any)
            )
          end
        end
      end
    end
    
    http_basic do |username, password|
      username == "aimbulance" && password == "F>bxHe(7Zvod@2'+HuQR"
    end
    
    helpers do
      def render(collection, options = {})
        format = (params[:format] || API.settings[:default_format]).to_s.downcase
        method = request.request_method.to_s.upcase
        
        unless method == 'GET'
          if collection.errors.empty?
            status(method == 'POST' ? 201 : 200)
          else
            collection = collection.errors
            status(422)
          end
        end
        
        to_format(collection, format, options)
      end
      
      def to_format(collection, format = 'xml', options = nil)
        options ||= {}
        
        case format
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
      
      post do
        render Models::Group.create(params[:group])
      end
      
      put ':id' do
        group.update_attributes(params[:group])
        render group
      end
      
      delete ':id' do
        group.destroy
        render group
      end
    end
    
    namespace :groups do
      helpers do
        def group
          @group ||= Models::Group.find(params[:group_id])
        end
        
        def track_item
          @track_item ||= group.track_items.find(params[:id])
        end
      end
      
      get ':group_id/track_items' do
        render group.track_items
      end
      
      get ':group_id/track_items/:id' do
        render track_item
      end
      
      get ':group_id/track_items/:id/tweets' do
        render track_item.all_count, :root => "track_item"
      end
      
      post ':group_id/track_items' do
        render group.track_items.create(params[:track_item])
      end
    end
    
    resources :track_items do
      helpers do
        def track_item
          @track_item ||= Models::TrackItem.find(params[:id])
        end
      end
      
      get ':id' do
        render track_item
      end
      
      get ':id/tweets' do
        render track_item.all_count, :root => "track_item"
      end
      
      put ':id' do
        track_item.update_attributes(params[:track_item])
        render track_item
      end
      
      delete ':id' do
        track_item.destroy
        render track_item
      end
    end
  end
end
