require File.expand_path '../../spec_helper.rb', __FILE__

describe Daily do
  describe "#new" do
    it "should not be empty" do
      Daily.new.wont_be_nil
    end
  end

  describe "#for_date" do
    it "should take an 8 digit string" do
      Daily.for_date("20120416").wont_be_nil
    end

    it "should error if the input is not an 8 digit string" do
      exception = lambda {
        Daily.for_date("asdf")
      }.must_raise RuntimeError
      exception.message.must_equal "Not an 8 digit date"
    end


    it "should look for an associated file under the data_path/year" do
      exception = lambda {
        Daily.for_date("19431213")
      }.must_raise RuntimeError
      exception.message.must_equal "Path not found"
    end

    it "should return XML for the file" do
    end

    it "should error if the file is not found" do
    end

  end

  describe "xml to json" do
    it "should be json" do
      assert_equal "1", "1"
    end
  end
end
