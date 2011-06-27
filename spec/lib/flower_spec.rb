require 'spec_helper'

describe Flower do
  before do
    @flower = Flower.new
  end

  describe "#new" do
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

  describe "#say" do
    it "should post the message" do
      def @flower.post(*args)
        @posted = true if args == ["Hello World", nil]
      end
      @flower.say("Hello World")
      @flower.instance_variable_get("@posted").should be_true
    end

    it "should mention a user by passing a tag" do
      def @flower.post(*args)
        @posted = true if args == ["Hello World", ":highlight:1"]
      end
      @flower.say("Hello World", :mention => 1)
      @flower.instance_variable_get("@posted").should be_true
    end
  end

  describe "#paste" do
    it "should post a message preceded with 4 spaces" do
      def @flower.post(*args)
        @posted = true if args.first == "    Hello World"
      end
      @flower.paste("Hello World")
      @flower.instance_variable_get("@posted").should be_true
    end

    it "should join an array into a multi-line paste" do
      def @flower.post(*args)
        @posted = true if args.first == "    Hello\\n    World"
      end
      @flower.paste(%w(Hello World))
      @flower.instance_variable_get("@posted").should be_true
    end

    it "should mention a user by passing a tag" do
      def @flower.post(*args)
        @mentioned = true if args[1] == ":highlight:2"
      end
      @flower.paste("Hello World", :mention => 2)
      @flower.instance_variable_get("@mentioned").should be_true
    end
  end
end
