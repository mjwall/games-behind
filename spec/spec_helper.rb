ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'mocha/setup'

require File.expand_path '../../app.rb', __FILE__

begin
  require 'turn/autorun'
  # fix the color
  Turn.config.ansi = true
rescue
  # just keep going, turn no installed
  LoadError
end

# class MiniTest::Spec
#   include Rack::Test::Methods

#   def app
#     Rack::Builder.parse_file(File.dirname(__FILE__) + "/../config.ru").first
#   end
# end
