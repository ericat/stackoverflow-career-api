require "./app"

run Sinatra::Application
run Rack::Cascade.new [API, Web]
