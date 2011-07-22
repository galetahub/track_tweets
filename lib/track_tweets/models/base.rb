module TrackTweets
  module Models
    module Base
      def self.included(base)
        base.send :include, ::MongoMapper::Document
        base.send :include, InstanceMethods
        base.send :extend, ClassMethods
      end
      
      module ClassMethods
        def distinct(*args)
          collection.distinct(*args)
        end
      end
      
      module InstanceMethods
        
        def to_xml(options = {}, &block)
          options[:root] = Utils.singularize(self.class)
          super
        end
      end
    end
  end
end
