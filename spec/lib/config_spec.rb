require 'spec_helper'

describe Flower::Config do
  describe ".method_missing" do
    it "should map methods to keys in config constant" do
      Flower::Config::CONFIG["test"] = "foo"
      Flower::Config.test.should == "foo"
    end
  end
end
