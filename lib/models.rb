require 'active_support/core_ext/hash'
require 'json'
require 'open-uri'

class Daily
  attr_accessor :xml, :data_dir, :hash

  def self.from_xml_file date_str, data_dir
    unless /\d{8}/.match date_str
      raise RuntimeError.new "Not an 8 digit date"
    end
    xml_file = "#{data_dir}/#{date_str[0..3]}/#{date_str}.xml"
    d = Daily.new
    d.data_dir = data_dir
    d.xml= File.read(xml_file)
    d
  end

  def hash
    @hash ||= Hash.from_xml(@xml)
  end

  def json
    hash.to_json
  end

  def file_date
    # file usually comes out early in the day and only contains data for the previous day's games
    DateTime.parse hash['sports_content']['sports_metadata']['date_time']
  end

  def persist
    raise RuntimeError.new "No data directory specificed" if data_dir == nil
    # will be stored with previous days date as filename
    prior_date = (file_date - 1).strftime('%Y%m%d')
    location = "#{data_dir}/#{prior_date[0..3]}/#{prior_date}.xml"
    raise RuntimeError.new "Not overwriting, File already exists, #{location}" if File.exists?(location)
    File.open(location,'w') do |f|
      f.write @xml
    end
    puts "File saved to @{location}"
  end

  def persist_to data_dir
    @data_dir = data_dir
    persist
  end

  def self.fetch_latest
    d = Daily.new
    open("http://erikberg.com/mlb/standings.xml") do |f|
      d.xml = f.read
    end
    d
  end
end
