require 'sinatra/base'
require 'haml'

class MyApp < Sinatra::Base

  get '/' do
    haml :index
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
