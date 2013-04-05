require 'active_support/core_ext/hash'
require 'json'
require 'open-uri'

class Daily
  attr_accessor :xml, :hash

  def initialize xmlstr=nil
    @xml=xmlstr
  end

  def hash
    @hash ||= Hash.from_xml(@xml)
  end

  def json
    hash.to_json
  end

  def file_date
    @file_date ||=  DateTime.parse hash['sports_content']['sports_metadata']['date_time']
  end

  def stored_as
    # it appears that dates with 0 hours and 0 minutes are actually for the prior day
    (file_date - (1/86400.0)).strftime('%Y%m%d')+".xml"
  end

  def same_as? daily
    self.hash == daily.hash
  end

  def to_s
    "Daily file for #{file_date}"
  end

  def persist_to data_dir, overwrite=false
    file_location = Daily.get_file_location(stored_as, data_dir)
    raise RuntimeError.new "Not overwriting, File already exists, #{file_location}" if File.exists?(file_location) && !overwrite
    File.open(file_location,'w') do |f|
      f.write @xml
    end
  end

  def self.from_stored_file date_str, data_dir
    validate_date date_str
    xml_file = get_file_location("#{date_str}.xml", data_dir)
    begin
      Daily.new File.read(xml_file)
    rescue
      nil
    end
  end

  def self.fetch_today
    self.fetch Date.today.strftime('%Y%m%d')
  end

  def self.fetch date_str, base_url="http://erikberg.com/mlb/standings/"
    validate_date date_str
    file = open("#{base_url}#{date_str}.xml")
    Daily.new file.read
  end

  private
  def self.validate_date date
    unless /\d{8}/.match date
      raise RuntimeError.new "Invalid Date format: #{date}"
    end
    DateTime.parse date
  end

  private
  def self.get_file_location filename, data_dir
     raise new RuntimeException "Directory does not exist: #{data_dir}" unless  Dir.exists? data_dir
     "#{data_dir}/#{filename[0..3]}/#{filename}"
  end
end
