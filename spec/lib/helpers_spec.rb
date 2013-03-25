require File.expand_path '../../spec_helper.rb', __FILE__

describe Sinatra::MyHelpers do
  before do
    @app = MyApp.new
  end

  describe "#data_path" do
    it "should point to root + '/public/data' with nil" do
      @app.helpers.data_path.must_equal @app.settings.root + '/public/data'
    end
  end
end
