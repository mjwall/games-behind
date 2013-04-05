require 'sinatra/base'
require 'sinatra/twitter-bootstrap'
require 'haml'

require_relative 'lib/helpers.rb'
require_relative 'lib/models.rb'
require_relative 'lib/fetcher.rb'

#TODO, set up environments

class MyApp < Sinatra::Base
  register Sinatra::Twitter::Bootstrap::Assets

  #helpers Sinatra::MyHelpers

  configure do
    set :data_dir , root + "/data"
  end

  get '/' do
    haml :index
  end

  get %r{/daily/([\d]{8})\.(json|xml)$} do |d, format|
    if format == "json"
      content_type :json
      get_daily(d).json.to_s
    elsif format == "xml"
      content_type :xml
      get_daily(d).xml.to_s
    end
  end

  get %r{/daily/([\d]{8})$} do |d|
    content_type :xml
    get_daily(d).xml.to_s
  end

  get '/fetch' do
    content_type :text
    Fetcher.fetch
  end

  private
  def get_daily date_str
    Daily.from_stored_file date_str, settings.data_dir
  end

  run! if app_file == $0
end
