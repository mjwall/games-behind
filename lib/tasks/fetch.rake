require_relative "../fetcher.rb"
require 'mail'

desc "Hourly fetch, yesterdays and latest"
task :hourly_fetch do
  puts Fetcher.hourly_fetch
end

desc "Fetch file for given date"
task :fetch_for, :date_str do |t, args|
  #raise RuntimeError.new "You need one date string argument" if args.size != 1
  puts Fetcher.fetch_for args.date_str
end
