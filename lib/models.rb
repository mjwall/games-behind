require 'active_support/core_ext/hash'
require 'json'

class Daily
  attr_accessor :xml, :data_dir

  def self.from_xml_file date_str, data_dir
    unless /\d{8}/.match date_str
      raise RuntimeError.new "Not an 8 digit date"
    end
    d = Daily.new
    d.data_dir = data_dir
    d.xml= File.read("#{data_dir}/#{date_str[0..3]}/#{date_str}.xml")
    d
  end

  def json
    Hash.from_xml(@xml).to_json
  end
end
