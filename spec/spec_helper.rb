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
