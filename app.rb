require 'sinatra/base'
require 'sinatra/twitter-bootstrap'
require 'haml'

require './lib/helpers.rb'
require './lib/daily.rb'

#TODO, set up environments

class MyApp < Sinatra::Base
  register Sinatra::Twitter::Bootstrap::Assets

  configure do
    set :root, File.dirname(__FILE__)
  end
  helpers Utils

  get '/' do
    haml :index
  end

  get %r{/datetime/([\d]{8})} do |d|
    parse_datetime(data_path(d)).strftime("%F")
  end

  get '/orig' do
    "the time where this server lives is #{Time.now}
    <br /><br />check out your <a href=\"/agent\">user_agent</a>"
  end

  get '/agent' do
    "you're using #{request.user_agent}"
  end

  run! if app_file == $0
end
