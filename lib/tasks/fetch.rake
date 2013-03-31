require_relative "../fetcher.rb"
require 'mail'

desc "Fetch lastest XML"
task :fetch do
  puts "Rake fetch task"
  puts Fetcher.fetch
end
