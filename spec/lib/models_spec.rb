require File.expand_path '../../spec_helper.rb', __FILE__

describe Daily do
  before do
    @daily = Daily.new
  end
  describe "#get_xml" do
    it "should take an 8 digit string" do
      @daily.get_xml("20120416").wont_be_nil
    end

    it "should look for an associated file under the data_path/year" do
    end

    it "should return XML for the file" do
    end

    it "should error if the file is not found" do
    end

    it "should error if the input is not an 8 digit string" do
    end

  end

  describe "xml to json" do
    it "should be json" do
      assert_equal "1", "1"
    end
  end
end
