require 'active_support/core_ext/hash'

module Sinatra
  module MyHelpers
    def parse_datetime location
      DateTime.parse Hash.from_xml(File.read(location))['sports_content']['sports_metadata']['date_time']
    end

  end
  helpers MyHelpers
end
