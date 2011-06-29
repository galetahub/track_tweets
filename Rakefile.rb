require ::File.expand_path('../config/environment',  __FILE__)
require 'rake'

Dir.glob('lib/tasks/*.rake').each { |r| import r }
