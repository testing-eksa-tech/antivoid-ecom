require 'dotenv/load'
require 'rack'
require 'rackup'
require 'rack/session'
require_relative 'app/app'
require_relative 'app/router'

# Load Environment Variables
Dotenv.load

# Use Rack::Static to serve files from the public folder
use Rack::Static, 
  urls: ["/css", "/js", "/images"],
  root: "public"

# Use Rack::Session::Cookie for simple session management
use Rack::Session::Cookie, 
  key: 'rack.session',
  path: '/',
  secret: ENV['JWT_SECRET'] || 'change_me'

# Run the application
run App.new
