require ::File.expand_path('../config/environment',  __FILE__)

use Rack::CommonLogger
use Rack::ShowExceptions
use MongoMapper::Middleware::IdentityMap

run TrackTweets::API
