require 'active_support'

module TrackTweets
  module Utils  
    def self.pluralize(klass)
      value = extract_klass(klass)
      ActiveSupport::Inflector.pluralize(value).tr('/', '_')
    end
    
    def self.singularize(klass)
      value = extract_klass(klass)
      ActiveSupport::Inflector.singularize(value).tr('/', '_')
    end
    
    def self.extract_klass(klass)
      class_name = klass.to_s.downcase.split('::').last
      ActiveSupport::Inflector.underscore(class_name)
    end
  end
end
