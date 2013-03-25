require 'active_support/core_ext/hash'

module Sinatra
  module MyHelpers
    def data_path date=nil
      data_dir = "#{settings.root}/public/data"
      if date == nil
        data_dir
      else
        data_dir + "/#{date[0..3]}/#{date}.xml"
      end
    end

    def parse_datetime location
      DateTime.parse Hash.from_xml(File.read(location))['sports_content']['sports_metadata']['date_time']
    end

  end
  helpers MyHelpers
end
