require_relative "../models.rb"

desc "Fetch lastest XML"
task :fetch do
  msg = "Running rake fetch"
  data_dir = File.dirname(__FILE__) + "/../../data"
  #yesterday_str = (Date.today - 1).strftime('%Y%m%d')
  # to test file delivery, remove 20121003.xml
  yesterday_str = "20121003"
  # to test existing file
  # yesterday_str = "20121002"
  msg += "\nYesterday: #{yesterday_str}\nDataDir: #{data_dir}"
  begin
    msg += "\nChecking if we already have the latest"
    existing = Daily.from_xml_file yesterday_str, data_dir
    msg += "\nYep: File exists for #{yesterday_str}"
  rescue Errno::ENOENT => e
    # not really an error
    msg += "\nNope: " + e.message
  end
  if existing == nil
    msg += "\nGetting the latest from the internet"
    daily = Daily.fetch_latest
    begin
      daily.persist_to data_dir
      msg += "\nSaved file-----------\n"
      msg += daily.xml
    rescue RuntimeError => e
      msg += "\nERROR: " + e.message
      msg += "\nDate on file: #{daily.file_date.strftime('%Y%m%d')}"
      msg += "\nShould have been today's data"
    end
  end
  # sendmail here
  puts msg
end
