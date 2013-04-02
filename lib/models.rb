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
    # file used to come out early in the day and only contain data for the previous day's games
    # looks like as of 2013 the date is late on the same day
    @file_date ||=  DateTime.parse hash['sports_content']['sports_metadata']['date_time']
  end

  def file_location
    @file_location ||= set_file_location
  end

  def persist
    # will be stored with previous days date as filename
    raise RuntimeError.new "Not overwriting, File already exists, #{file_location}" if File.exists?(file_location)
    directory = File.dirname(file_location)
    Dir.mkdir directory  unless Dir.exists?(directory)
    File.open(file_location,'w') do |f|
      f.write @xml
    end
    puts "File saved to #{file_location}"
  end

  def persist_to data_dir
    @data_dir = data_dir
    persist
  end

  def self.fetch_latest
    today_str = Date.today.strftime('%Y%m%d')
    d = Daily.new
    d.instance_variable_set(:@file_date, DateTime.now)
    open("http://erikberg.com/mlb/standings/#{today_str}.xml") do |f|
      d.xml = f.read
    end
    d
  end

  private
  def set_file_location
    raise RuntimeError.new "No data directory specificed" if data_dir == nil
    raise RuntimeError.new "No file date specified" if file_date == nil
    prior_date = (file_date - 1).strftime('%Y%m%d')
    "#{@data_dir}/#{prior_date[0..3]}/#{prior_date}.xml"
  end
end
