require 'active_support/core_ext/hash'

module Utils
  def data_path date
    "#{options.root}/public/data/#{date[0..3]}/#{date}.xml"
  end

  def parse_datetime location
    DateTime.parse Hash.from_xml(File.read(location))['sports_content']['sports_metadata']['date_time']
  end

end
