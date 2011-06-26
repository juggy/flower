require 'spec_helper'

describe Flower do
  describe "#new" do
    before do
      @flower = Flower.new
    end

    %w(messages_url post_url flow_url uuid).each do |attribute|
      it "should set the #{attribute} attributes" do
        @flower.send(attribute).should_not be_nil
        @flower.send(attribute).should be_a(String)
      end
    end

    it "should set a session" do
      @flower.session.should be_a(Flower::Session)
    end

    it "should default users to empty hash" do
      @flower.users.should == {}
    end
  end
end