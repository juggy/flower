require 'spec_helper'

describe Flower::Command do
  describe ".respond_to" do
    it "should add self to the hash, with command as key" do
      Flower::COMMANDS.keys.should_not include("test")

      class TestCommand < Flower::Command
        respond_to "test"
      end

      Flower::COMMANDS.should include({"test" => TestCommand})
    end

    it "should not override already defined command if called twice" do
      class FirstTestCommand < Flower::Command
        respond_to "dup_test"
      end
      class SecondTestCommand < Flower::Command
        respond_to "dup_test"
      end

      Flower::COMMANDS["dup_test"].should == FirstTestCommand
    end
  end
  
  describe ".delegate_command" do
    it "should return if command is not defined" do
      Flower::COMMANDS["foo"].should be_nil
      Flower::Command.delegate_command("foo", "testing", {}, nil).should be_false
    end

    it "should call class defined in command constant" do
      class TestCommand < Flower::Command
        respond_to "delegate_me"
        def self.respond(*args)
          @responded = true
        end
      end

      Flower::Command.delegate_command("delegate_me", "testing", {}, nil).should be_true
      TestCommand.instance_variable_get("@responded").should be_true
    end
  end
end
