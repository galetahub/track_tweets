require ::File.expand_path('../config/environment',  __FILE__)
require "rack/contrib"

use Rack::CommonLogger
use Rack::ShowExceptions
use Rack::Access, '/api' => [ '127.0.0.1', '213.186.118.202/24' ]
use Rack::StaticCache, :urls => ["/stylesheets", "/images", "/javascripts", "/favicon.ico"], :root => "public"

use Rack::RubyProf if ENV['RACK_ENV'] == 'test'

use MongoMapper::Middleware::IdentityMap

run TrackTweets::API
