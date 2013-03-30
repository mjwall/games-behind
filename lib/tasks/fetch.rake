require_relative "../models.rb"

desc "Fetch lastest XML"
task :fetch do
  puts "Checking latest XML"
  data_dir = File.dirname(__FILE__) + "/../../data"
  puts data_dir
  yesterday_str = (Date.today - 1).strftime('%Y%m%d')
  yesterday_str = "20120416"
  begin
    daily = Daily.from_xml_file yesterday_str, data_dir
    puts "File exists for #{yesterday_str}"
  rescue Errno::ENOENT
    puts "File missing, let's go get it"
  end
  # if file for yesterday doesn't exist, go get it
  # if it does exist, make sure the date in the xml is today
end
