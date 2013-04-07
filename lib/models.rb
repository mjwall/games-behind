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

  def parsed_date
    @parsed_date ||= DateTime.parse hash['sports_content']['sports_metadata']['date_time']
  end

  def formatted_date
    @formatted_date ||= parsed_date.strftime(Daily.date_format)
  end

  def file_name
    # it appears that dates with 0 hours and 0 minutes are actually for the prior day
    @file_name ||= formatted_date + Daily.file_ext
  end

  def == other_daily
    unless other_daily.class == self.class
      raise RuntimeException.new "You tried to compare a #{other_daily.class} to a #{self.class}"
    end
    self.hash == other_daily.hash
  end

  #do I need to override this too?
  def != other_daily
    ! self == other_daily
  end

  def to_s
    "Daily file #{file_name} on #{parsed_date}"
  end

  def file_location data_dir
    Daily.get_file_location file_name, data_dir
  end

  def persist_to data_dir
    stored = Daily.from_local(formatted_date, data_dir)
    location = file_location data_dir
    if stored.nil? || self != stored
      Zlib::GzipWriter.open(location) do |gz|
        gz.mtime = parsed_date
        gz.write @xml
      end
    else
      raise RuntimeError.new "Not overwriting, same file already exists at #{location}"
    end
  end

  def self.date_format
    "%Y%m%d"
  end

  def self.file_ext
    ".xml.gz"
  end

  def self.from_local date_str, data_dir
    validate_date date_str
    file = get_file_location("#{date_str}#{file_ext}", data_dir)
    begin
      Daily.new Zlib::GzipReader.new(File.open(file)).read
    rescue
      nil
    end
  end

  def self.latest_source base_url="http://erikberg.com/mlb/standings"
    Daily.new open("#{base_url}.xml").read
  end

  def self.yesterday_source base_url="http://erikberg.com/mlb/standings"
    Daily.source (Date.today - 1).strftime(Daily.date_format), base_url
  end

  def self.source date_str, base_url="http://erikberg.com/mlb/standings"
    validate_date date_str
    file = open("#{base_url}/#{date_str}.xml")
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
    # stored in a subdirectory by year
    file_dir = "#{data_dir}/#{filename[0..3]}"
    raise new RuntimeException "Directory does not exist: #{file_dir}" unless  Dir.exists? file_dir
    "#{file_dir}/#{filename}"
  end
end
