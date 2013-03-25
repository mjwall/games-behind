require File.expand_path '../../spec_helper.rb', __FILE__

describe Daily do
  describe "#new" do
    it "should allow an empty" do
      Daily.new.wont_be_nil
    end

    it "should take a valid date" do
      Daily.new("20120415").wont_be_nil
    end

    it "should error if file corresponding to date can't be found" do
    end
  end

  describe "xml to json" do
    it "should be json" do
      assert_equal "1", "1"
    end
  end
end
