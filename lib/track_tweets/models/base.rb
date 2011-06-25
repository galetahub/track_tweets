module TrackTweets
  module Models
    module Base
      def self.included(base)
        base.send :include, ::MongoMapper::Document
        base.send :include, InstanceMethods
        base.send :extend, ClassMethods
      end
      
      module ClassMethods
      end
      
      module InstanceMethods
        
        def to_xml(options = {}, &block)
          options[:root] = self.class.name.to_s.downcase.split('::').last
          super
        end
      end
    end
  end
end
